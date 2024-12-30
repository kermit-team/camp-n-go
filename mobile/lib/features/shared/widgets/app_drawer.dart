import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_event.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.zero,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: TitleText(
              'Menu',
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: StandardText(
              LocaleKeys.accountSettings.tr(),
              textAlign: TextAlign.start,
            ),
            onTap: () {
              serviceLocator<GoRouter>().push(
                AppRoutes.accountSettings.route,
              );
              Navigator.pop(context);
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.email_outlined,
          //     color: Theme.of(context).colorScheme.onSurface,
          //   ),
          //   title: StandardText(
          //     LocaleKeys.contact.tr(),
          //     textAlign: TextAlign.start,
          //   ),
          //   onTap: () {
          //     serviceLocator<GoRouter>().push(AppRoutes.contactForm.route);
          //     Navigator.pop(context); // Close the drawer
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            title: StandardText(
              LocaleKeys.logout.tr(),
              textAlign: TextAlign.start,
            ),
            onTap: () {
              context.read<AuthBloc>().add(DeleteCredentials());
              serviceLocator<GoRouter>().go(AppRoutes.login.route);
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
