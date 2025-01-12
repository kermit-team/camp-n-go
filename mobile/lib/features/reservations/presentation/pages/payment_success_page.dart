import 'package:campngo/config/constants.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/icon_app_bar.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PaymentResultPage extends StatelessWidget {
  final bool isSuccessful;
  final String? paymentId;
  final String? errorCode;

  const PaymentResultPage({
    super.key,
    required this.isSuccessful,
    this.paymentId,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: isSuccessful
          ? Column(
              children: [
                const IconAppBar(),
                TitleText('${LocaleKeys.success.tr()}!'),
                SizedBox(height: Constants.spaceS),
                StandardText(LocaleKeys.paymentSuccessful.tr()),
                SizedBox(height: Constants.spaceL),
                CustomButton(
                  text: LocaleKeys.returnFrom.tr(),
                  onPressed: Navigator.of(context).pop,
                )
              ],
            )
          : Column(
              children: [
                const IconAppBar(),
                TitleText('${LocaleKeys.failure.tr()}!'),
                SizedBox(height: Constants.spaceS),
                StandardText(LocaleKeys.paymentFailure.tr()),
                SizedBox(height: Constants.spaceL),
                CustomButton(
                  text: LocaleKeys.returnFrom.tr(),
                  onPressed: Navigator.of(context).pop,
                )
              ],
            ),
    );
  }
}
