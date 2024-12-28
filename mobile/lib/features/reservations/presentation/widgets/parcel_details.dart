import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelDetails extends StatelessWidget {
  final ParcelEntity parcel;

  const ParcelDetails({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/parcel_example.png'),
        SizedBox(height: Constants.spaceS),
        KeyValueText(
          keyText: LocaleKeys.pricePerDay.tr(),
          valueText: parcel.pricePerDay.toString(),
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.description.tr(),
          valueText: parcel.description,
        ),
        SizedBox(height: Constants.spaceXS),
        ...parcel.generalInfo.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: Constants.spaceXS),
            child: KeyValueText(
              keyText: entry.key,
              valueText: entry.value,
            ),
          );
        }),
      ],
    );
  }
}
