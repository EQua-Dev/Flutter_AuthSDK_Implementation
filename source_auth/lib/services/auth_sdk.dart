import 'package:flutter/services.dart';

class AuthSDK {
  static const MethodChannel _channel = MethodChannel('auth_sdk_channel');

  static Future<Map<String, dynamic>?> launchAuthScreen({
    required String primaryColor,
    required String backgroundColor,
    required String textColor,
    String submitButtonText = 'Submit',
    bool showUsername = true,
  }) async {
    try {
      final result = await _channel.invokeMethod('launchAuthSDK', {
        'config': {
          'primaryColor': primaryColor,
          'backgroundColor': backgroundColor,
          'textColor': textColor,
          'submitButtonText': submitButtonText,
          'showUsername': showUsername,
        }
      });
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Auth SDK Error: ${e.message}");
      return null;
    }
  }
}
