import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/subtitle_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelDetailsDialog extends StatelessWidget {
  final ParcelEntity parcel;

  const ParcelDetailsDialog({
    super.key,
    required this.parcel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.width * 0.05),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SubtitleText(
                "${LocaleKeys.parcelNumber.tr()} ${parcel.parcelNumber}",
                isUnderlined: true,
              ),
            ),
            const SizedBox(height: Constants.spaceS),
            Image.asset(
              'assets/images/parcel_example.png',
            ),
            const SizedBox(height: Constants.spaceS),
            KeyValueText(
              keyText: LocaleKeys.pricePerDay.tr(),
              valueText: parcel.pricePerDay.toString(),
            ),
            const SizedBox(height: Constants.spaceXS),
            KeyValueText(
              keyText: LocaleKeys.description.tr(),
              valueText: parcel.description,
            ),
            const SizedBox(height: Constants.spaceXS),
            ...parcel.generalInfo.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Constants.spaceXS),
                child: KeyValueText(
                  keyText: entry.key,
                  valueText: entry.value,
                ),
              );
            }),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: Constants.spaceM,
        left: Constants.spaceM,
        right: Constants.spaceM,
        bottom: 0,
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CustomButtonInverted(
                text: LocaleKeys.cancel.tr(),
                onPressed: Navigator.of(context).pop,
                width: double.minPositive,
              ),
            ),
            const SizedBox(width: Constants.spaceS),
            Expanded(
              child: CustomButton(
                text: LocaleKeys.reserve.tr(),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                width: double.minPositive,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
