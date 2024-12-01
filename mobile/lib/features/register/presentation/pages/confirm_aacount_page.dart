import 'package:campngo/config/constants.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/icon_app_bar.dart';
import 'package:campngo/features/shared/widgets/standard_text.dart';
import 'package:campngo/features/shared/widgets/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmAccountPage extends StatelessWidget {
  const ConfirmAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBody(
      children: [
        const IconAppBar(),
        TitleText(LocaleKeys.confirmAccount.tr()),
        const SizedBox(height: Constants.spaceS),
        StandardText(LocaleKeys.emailToResetPasswordSent.tr()),
        const SizedBox(height: Constants.spaceL),
        CustomButton(
          text: LocaleKeys.returnToLogin.tr(),
          onPressed: () {
            serviceLocator<GoRouter>().go('/login');
          },
        ),
      ],
    );
  }
}
