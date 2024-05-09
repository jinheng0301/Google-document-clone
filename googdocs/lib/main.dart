import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/screens/login_screens.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
    // this provider scope allow us to usse other providers 
    // it will act storehouse for other providers as well
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
