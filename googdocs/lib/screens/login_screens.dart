import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/colors.dart';
import 'package:googdocs/repository/auth_repository.dart';
import 'package:googdocs/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update(
            (state) => errorModel.data,
          );
      navigator.push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
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
