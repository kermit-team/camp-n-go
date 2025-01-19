import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: serviceLocator<AuthCubit>(),
      builder: (context, state) {
        final isLoggedIn = state.status == AuthStatus.authenticated;
        return Drawer(
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: Constants.spaceL,
                  bottom: Constants.spaceS,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 10.h,
                      width: double.maxFinite,
                    ),
                    TitleText(
                      'Menu',
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              _DrawerListTile(
                icon: Icons.home,
                title: LocaleKeys.searchParcel.tr(),
                isVisible: isLoggedIn,
                onTap: () {
                  _navigateToRoute(
                    context,
                    AppRoutes.searchParcel.route,
                  );
                },
              ),
              _DrawerListTile(
                icon: Icons.home,
                title: LocaleKeys.searchParcel.tr(),
                isVisible: !isLoggedIn,
                onTap: () {
                  _navigateToRoute(
                    context,
                    AppRoutes.searchParcelUnauthenticated.route,
                  );
                },
              ),
              _DrawerListTile(
                icon: Icons.list,
                title: LocaleKeys.reservationList.tr(),
                isVisible: isLoggedIn,
                onTap: () {
                  _navigateToRoute(
                    context,
                    AppRoutes.reservationList.route,
                  );
                },
              ),
              _DrawerListTile(
                icon: Icons.email_outlined,
                title: LocaleKeys.contact.tr(),
                onTap: () {
                  final String email = serviceLocator<FlutterSecureStorage>()
                      .read(key: 'email')
                      .toString();
                  _navigateToRoute(
                    context,
                    AppRoutes.contactForm.route,
                    extra: {'email': email},
                  );
                },
              ),
              _DrawerListTile(
                icon: Icons.info_outline,
                title: 'Test',
                onTap: () {
                  _navigateToRoute(
                    context,
                    AppRoutes.testWebView.route,
                    extraString: "https://www.google.com",
                    isPush: true,
                  );
                },
              ),
              const Spacer(),
              _DrawerListTile(
                icon: Icons.settings,
                title: LocaleKeys.accountSettings.tr(),
                isVisible: isLoggedIn,
                onTap: () {
                  _navigateToRoute(
                    context,
                    AppRoutes.accountSettings.route,
                  );
                },
              ),
              _DrawerListTile(
                icon: Icons.logout,
                title: LocaleKeys.logout.tr(),
                isVisible: isLoggedIn,
                onTap: () {
                  serviceLocator<AuthCubit>().logout();
                  Navigator.pop(context);
                },
              ),
              _DrawerListTile(
                icon: Icons.login,
                title: LocaleKeys.login.tr(),
                isVisible: !isLoggedIn,
                onTap: () {
                  _navigateToRoute(
                    context,
                    AppRoutes.login.route,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToRoute(
    BuildContext context,
    String route, {
    bool isPush = false,
    Map<String, dynamic>? extra,
    String? extraString,
  }) {
    final currentRoute = GoRouter.of(context).state?.matchedLocation;
    if (currentRoute != route) {
      if (isPush) {
        context.push(route, extra: extra ?? extraString);
      } else {
        context.go(route, extra: extra ?? extraString);
      }
    }
    Navigator.pop(context);
  }
}

class _DrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isVisible;

  const _DrawerListTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      title: StandardText(
        title,
        textAlign: TextAlign.start,
      ),
      onTap: onTap,
    );
  }
}
