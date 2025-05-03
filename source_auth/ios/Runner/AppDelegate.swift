import Flutter
import UIKit
import AuthSDK
import SwiftUI

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var authChannel: FlutterMethodChannel!

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Ensure rootViewController is a FlutterViewController
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("RootViewController is not FlutterViewController")
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        authChannel = FlutterMethodChannel(name: "auth_sdk_channel", binaryMessenger: controller.binaryMessenger)

        authChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            if call.method == "launchAuthSDK" {
                guard let args = call.arguments as? [String: Any],
                      let config = args["config"] as? [String: Any] else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid configuration arguments", details: nil))
                    return
                }

                // Extract configuration values
                let primaryColor = config["primaryColor"] as? String ?? "#6200EE"
                let backgroundColor = config["backgroundColor"] as? String ?? "#FFFFFF"
                let textColor = config["textColor"] as? String ?? "#000000"
                let submitButtonText = config["submitButtonText"] as? String ?? "Submit"
                let showUsername = config["showUsername"] as? Bool ?? true

                // Initialize AuthConfig
                let authConfig = AuthConfig(
                    primaryColorHex: primaryColor,
                    backgroundColorHex: backgroundColor,
                    textColorHex: textColor,
                    submitButtonText: submitButtonText,
                    showUsername: showUsername
                )

                // Launch SDK with config
                let authView = AuthSDKClass.launch(config: authConfig) { userData in
//                    if let userData = userData {
                    let userMap: [String: Any] = [
                        "email": userData.email,
                        "password": userData.password,
                        "username": userData.username ?? "",
                        "firstName": userData.firstName,
                        "lastName": userData.lastName
                    ]

                    result(userMap)
                    DispatchQueue.main.async {
                          controller.presentedViewController?.dismiss(animated: true, completion: nil)
                      }
//                    } else {
//                        result(FlutterError(code: "AUTH_FAILED", message: "Authentication failed", details: nil))
//                    }
                }

                // Present the SwiftUI view
                if #available(iOS 13.0, *) {
                    let hostingController = UIHostingController(rootView: authView)
                    DispatchQueue.main.async {
                        if let rootViewController = self.window?.rootViewController {
                            rootViewController.present(hostingController, animated: true, completion: nil)
                        }
                    }
                } else {
                    result(FlutterError(code: "UNSUPPORTED_IOS_VERSION", message: "iOS 13 or newer is required", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
