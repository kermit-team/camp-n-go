import 'package:campngo/features/auth/presentation/pages/login_page.dart';
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // final AuthBloc authBloc;

  AppRouter();

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: SafeArea(
              child: Scaffold(
                body: IconButton(
                  onPressed: () {
                    serviceLocator<GoRouter>().go("/login");
                  },
                  icon: const Icon(Icons.login),
                ),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: "/login",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: LoginPage(),
          );
        },
      ),
    ],
  );
}
