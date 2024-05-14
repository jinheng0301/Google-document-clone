import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googdocs/models/error_models.dart';
import 'package:googdocs/repository/auth_repository.dart';
import 'package:googdocs/router.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
    // this provider scope allow us to usse other providers
    // it will act storehouse for other providers as well
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();

    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final user = ref.watch(userProvider);

          if (user != null && user.token.isNotEmpty) {
            return loggedInRoute;
          } else {
            return loggedOutRoute;
          }
        },
      ),
      routeInformationParser: RoutemasterParser(),
    );
  }
}
