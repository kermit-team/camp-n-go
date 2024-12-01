import 'dart:developer';

import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/presentation/widgets/display_text_field.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/standard_text.dart';
import 'package:campngo/features/shared/widgets/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      children: [
        TitleText(LocaleKeys.accountSettings.tr()),
        const SizedBox(height: Constants.spaceS),
        StandardText(LocaleKeys.updateUserData.tr()),
        const SizedBox(height: Constants.spaceL),
        Form(
          key: _formKey,
          child: Column(
            children: [
              DisplayTextField(
                label: LocaleKeys.firstName.tr(),
                text: 'Kamil',
                validations: const [RequiredValidation()],
                onHyperlinkPressed: (String newValue) {
                  log("New value for firstName: $newValue");
                },
              ),
              DisplayTextField(
                label: LocaleKeys.lastName.tr(),
                text: 'Gajczak',
                validations: const [RequiredValidation()],
                onHyperlinkPressed: (String newValue) {
                  log("New value for firstName: $newValue");
                },
              ),
              DisplayTextField(
                label: LocaleKeys.email.tr(),
                text: 'kamil.gajczak@gmail.com',
                validations: const [RequiredValidation(), EmailValidation()],
                onHyperlinkPressed: (String newValue) {
                  log("New value for firstName: $newValue");
                },
              ),
              DisplayTextField(
                label: LocaleKeys.phoneNumber.tr(),
                text: '+48 123 456 789',
                validations: const [RequiredValidation()],
                onHyperlinkPressed: (String newValue) {
                  log("New value for firstName: $newValue");
                },
              ),
              DisplayTextField(
                label: LocaleKeys.idNumber.tr(),
                text: '12********123',
                validations: const [RequiredValidation()],
                onHyperlinkPressed: (String newValue) {
                  log("New value for firstName: $newValue");
                },
              ),
              DisplayTextField(
                label: LocaleKeys.password.tr(),
                text: '*******',
                validations: const [RequiredValidation()],
                onHyperlinkPressed: (String newValue) {
                  log("New value for firstName: $newValue");
                },
                //todo: zmienić gwiazdki na kropki
              ),
            ],
          ),
        ),
      ],
    );
  }
}
