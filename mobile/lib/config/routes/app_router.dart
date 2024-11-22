import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/features/auth/presentation/pages/login_page.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:campngo/features/register/presentation/pages/register_page.dart';
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Cześć anon, przejdź do logowania!",
                        style: mainTextStyle(),
                      ),
                      IconButton(
                        onPressed: () {
                          serviceLocator<GoRouter>().go("/login");
                        },
                        icon: const Icon(Icons.login),
                      ),
                    ],
                  ),
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
      GoRoute(
        path: "/register",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider<RegisterBloc>(
              create: (context) => serviceLocator<RegisterBloc>(),
              child: const RegisterPage(),
            ),
          );
        },
      ),
    ],
  );
}
