import 'package:flutter/material.dart';
import 'package:source_auth/services/auth_sdk.dart';

class AuthTestScreen extends StatelessWidget {
  const AuthTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SDK Demo')),
      body: Center(
        child: ElevatedButton(
          child: Text("Launch Auth SDK"),
          onPressed: () async {
            final userData = await AuthSDK.launchAuthScreen(
              primaryColor: "#6200EE",
              backgroundColor: "#FFFFFF",
              textColor: "#000000",
              submitButtonText: "Register",
              showUsername: true,
            );

            if (userData != null) {
              print("User: $userData");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Welcome, ${userData['firstName']}!")),
              );
            }
          },
        ),
      ),
    );
  }
}
