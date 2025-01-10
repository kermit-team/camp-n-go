import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelDetailsWidget extends StatelessWidget {
  final Parcel parcel;

  const ParcelDetailsWidget({
    super.key,
    required this.parcel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Constants.spaceS),
          KeyValueText(
            keyText: LocaleKeys.description.tr(),
            valueText: parcel.description,
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.pricePerParcel.tr(),
            valueText: parcel.campingSection.basePrice.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.pricePerAdult.tr(),
            valueText: parcel.campingSection.pricePerAdult.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.pricePerChild.tr(),
            valueText: parcel.campingSection.pricePerChild.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.maxPeople.tr(),
            valueText: parcel.maxNumberOfPeople.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.parcelLength.tr(),
            valueText: parcel.length.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.parcelWidth.tr(),
            valueText: parcel.width.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.hasElectricity.tr(),
            valueText: parcel.electricityConnection ? "Yes" : "No",
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.hasWater.tr(),
            valueText: parcel.waterConnection ? "Yes" : "No",
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.hasGreyWaterDisposal.tr(),
            valueText: parcel.greyWaterDischarge ? "Yes" : "No",
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.isShaded.tr(),
            valueText: parcel.isShaded ? "Yes" : "No",
          ),
          SizedBox(height: Constants.spaceXS),
        ],
      ),
    );
  }
}
