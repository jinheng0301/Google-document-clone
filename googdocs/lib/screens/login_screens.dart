import 'package:flutter/material.dart';
import 'package:googdocs/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Image.asset(
            'images/g-logo-2.png',
            height: 20,
          ),
          label: Text(
            'Sign in with Google',
            style: TextStyle(
              color: kBlackColor,
            ),
          ),
        ),
      ),
    );
  }
}
