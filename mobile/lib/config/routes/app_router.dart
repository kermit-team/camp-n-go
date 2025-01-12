import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_cubit.dart';
import 'package:campngo/features/account_settings/presentation/cubit/contact_form_cubit.dart';
import 'package:campngo/features/account_settings/presentation/pages/account_settings_page.dart';
import 'package:campngo/features/account_settings/presentation/pages/contact_form_page.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:campngo/features/auth/presentation/pages/login_page.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:campngo/features/register/presentation/pages/confirm_aacount_page.dart';
import 'package:campngo/features/register/presentation/pages/forgot_password_page.dart';
import 'package:campngo/features/register/presentation/pages/register_page.dart';
import 'package:campngo/features/register/presentation/pages/reset_password_info_page.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/domain/repository/reservation_repository.dart';
import 'package:campngo/features/reservations/presentation/cubit/parcel_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_preview_cubit.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_summary_cubit.dart';
import 'package:campngo/features/reservations/presentation/pages/parcel_list_page.dart';
import 'package:campngo/features/reservations/presentation/pages/payment_page.dart';
import 'package:campngo/features/reservations/presentation/pages/payment_success_page.dart';
import 'package:campngo/features/reservations/presentation/pages/reservation_list_page.dart';
import 'package:campngo/features/reservations/presentation/pages/reservation_preview_page.dart';
import 'package:campngo/features/reservations/presentation/pages/reservation_summary_page.dart';
import 'package:campngo/features/reservations/presentation/pages/search_parcel_page.dart';
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter() {
    _authCubit.stream.listen((_) => _authListenable.notifyListeners());
    _authCubit.appStarted();
  }

  final _authCubit = serviceLocator<AuthCubit>();
  final _authListenable = AuthListenable();

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home.route,
    redirect: (context, state) {
      final authState = _authCubit.state;
      final isLoggedIn = authState.status == AuthStatus.authenticated;
      final currentRoute = AppRoutes.values.firstWhere(
        (element) => element.route == state.matchedLocation,
        orElse: () => AppRoutes.home,
      );
      final accessLevel = getAccessLevel(currentRoute);

      if (!isLoggedIn && accessLevel == AccessLevel.authenticationRequired) {
        return AppRoutes.login.route;
      }
      if (accessLevel == AccessLevel.unknownRoute) {
        _authCubit.logout();
        return AppRoutes.login.route;
      }
      return null;
    },
    refreshListenable: _authListenable,
    routes: <GoRoute>[
      GoRoute(
        path: AppRoutes.home.route,
        redirect: (context, state) {
          if (serviceLocator<AuthCubit>().state.status ==
              AuthStatus.authenticated) {
            return AppRoutes.searchParcel.route;
          } else {
            return AppRoutes.searchParcelUnauthenticated.route;
          }
        },
      ),
      GoRoute(
        path: AppRoutes.login.route,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.register.route,
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
        path: AppRoutes.forgotPassword.route,
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
        path: AppRoutes.confirmAccount.route,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ConfirmAccountPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPasswordInfo.route,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: ResetPasswordInfoPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.accountSettings.route,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider(
              create: (context) =>
                  serviceLocator<AccountSettingsCubit>()..getAccountData(),
              child: const AccountSettingsPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.searchParcel.route,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SearchParcelPage(
              authenticated: true,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.parcelList.route,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final page = extra['page'] as int;
          final params = extra['params'] as GetParcelListParams;

          return MaterialPage(
            child: BlocProvider<ParcelListCubit>(
              create: (context) => ParcelListCubit(
                reservationRepository: serviceLocator<ReservationRepository>(),
              )..getParcelList(params: params, page: page),
              child: ParcelListPage(
                params: params,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.reservationSummary.route,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final parcel = extra['parcel'] as Parcel;
          final params = extra['params'] as GetParcelListParams;
          return MaterialPage(
            child: BlocProvider<ReservationSummaryCubit>(
              create: (context) => ReservationSummaryCubit(
                reservationRepository: serviceLocator<ReservationRepository>(),
                accountSettingsRepository:
                    serviceLocator<AccountSettingsRepository>(),
              ),
              child: ReservationSummaryPage(
                parcel: parcel,
                params: params,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.reservationPreview.route,
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final reservationId = extra['reservationId'] as String;
          return MaterialPage(
            child: BlocProvider(
              create: (context) => ReservationPreviewCubit(
                  reservationRepository:
                      serviceLocator<ReservationRepository>()),
              child: ReservationPreviewPage(
                reservationId: reservationId,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.contactForm.route,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider(
                create: (context) => ContactFormCubit(
                    accountSettingsRepository:
                        serviceLocator<AccountSettingsRepository>()),
                child: const ContactFormPage(unauthenticated: true)),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.reservationList.route,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: BlocProvider(
              create: (context) => ReservationListCubit(
                reservationRepository: serviceLocator<ReservationRepository>(),
              ),
              child: const ReservationListPage(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.searchParcelUnauthenticated.route,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SearchParcelPage(authenticated: false),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.payment.route,
        builder: (BuildContext context, GoRouterState state) {
          final paymentUrl = state.extra! as Map<String, dynamic>;
          return PaymentPage(paymentUrl: paymentUrl['paymentUrl']);
        },
      ),
      GoRoute(
        path: AppRoutes.paymentSuccess.route,
        builder: (BuildContext context, GoRouterState state) {
          final paymentId = state.extra! as Map<String, dynamic>;
          return PaymentResultPage(
            isSuccessful: true,
            paymentId: paymentId['paymentId'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.paymentFailure.route,
        builder: (BuildContext context, GoRouterState state) {
          final errorCode = state.extra! as Map<String, dynamic>;
          return PaymentResultPage(
            isSuccessful: false,
            errorCode: errorCode['errorCode'],
          );
        },
      ),
    ],
  );
}

class AuthListenable extends ChangeNotifier {
  AuthListenable();
}
