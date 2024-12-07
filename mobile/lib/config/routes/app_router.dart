import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/account_settings/presentation/pages/account_settings_page.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_event.dart';
import 'package:campngo/features/auth/presentation/pages/login_page.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:campngo/features/register/presentation/pages/confirm_aacount_page.dart';
import 'package:campngo/features/register/presentation/pages/forgot_password_page.dart';
import 'package:campngo/features/register/presentation/pages/register_page.dart';
import 'package:campngo/features/register/presentation/pages/reset_password_info_page.dart';
import 'package:campngo/features/reservations/presentations/pages/search_parcel_page.dart';
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // final AuthBloc authBloc;

  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: "/searchParcel",
    routes: <GoRoute>[
      GoRoute(
        path: "/",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Cześć anon, przejdź nazot do logowania!",
                      style: AppTextStyles.mainTextStyle(),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(DeleteCredentials());
                        serviceLocator<GoRouter>().go("/login");
                      },
                      icon: const Icon(Icons.login),
                    ),
                    const SizedBox(height: Constants.spaceM),
                    Text(
                      "Przejdź do edycji swojego konta.",
                      style: AppTextStyles.mainTextStyle(),
                    ),
                    IconButton(
                      onPressed: () {
                        serviceLocator<GoRouter>().push("/accountSettings");
                      },
                      icon: const Icon(Icons.login),
                    ),
                  ],
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
      GoRoute(
        path: "/forgotPassword",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider<ForgotPasswordBloc>(
              create: (context) => serviceLocator<ForgotPasswordBloc>(),
              child: const ForgotPasswordPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: "/confirmAccount",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ConfirmAccountPage(),
          );
        },
      ),
      GoRoute(
        path: "/resetPasswordInfo",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ResetPasswordInfoPage(),
          );
        },
      ),
      GoRoute(
        path: "/accountSettings",
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider(
              create: (context) => serviceLocator<AccountSettingsCubit>()
                ..getAccountData()
                ..getCarList(),
              child: const AccountSettingsPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: "/searchParcel",
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SearchParcelPage(),
          );
        },
      )
    ],
  );
}
