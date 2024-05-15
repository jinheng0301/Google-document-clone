import 'package:flutter/material.dart';
import 'package:googdocs/screens/document_screen.dart';
import 'package:googdocs/screens/home_screen.dart';
import 'package:googdocs/screens/login_screens.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': ((route) => MaterialPage(child: LoginScreen())),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (route) => MaterialPage(child: HomeScreen()),
    '/document/:id': (route) => MaterialPage(
          child: DocumentScreen(
            id: route.pathParameters['id'] ?? '',
          ),
        ),
  },
);
