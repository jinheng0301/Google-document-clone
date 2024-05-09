import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/colors.dart';
import 'package:googdocs/repository/auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref) {
    ref.read(authRepositoryProvider).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref),
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
