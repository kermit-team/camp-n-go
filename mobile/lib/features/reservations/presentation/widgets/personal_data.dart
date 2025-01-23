import 'package:campngo/config/constants.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PersonalData extends StatelessWidget {
  final Account account;

  const PersonalData({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        KeyValueText(
          keyText: LocaleKeys.firstName.tr(),
          valueText: account.profile.firstName,
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.lastName.tr(),
          valueText: account.profile.lastName,
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.email.tr(),
          valueText: account.email,
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.phoneNumber.tr(),
          valueText: account.profile.phoneNumber ?? '',
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.idNumber.tr(),
          valueText: account.profile.idCard ?? '',
        ),
        SizedBox(height: Constants.spaceXS),
        // KeyValueText(
        //   keyText: LocaleKeys.password.tr(),
        //   valueText: account.profile.password,
        // ),
      ],
    );
  }
}
