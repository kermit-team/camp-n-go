import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelListTile extends StatelessWidget {
  final Parcel parcel;
  final void Function(Parcel) onListTilePressed;

  const ParcelListTile({
    super.key,
    required this.parcel,
    required this.onListTilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: Constants.spaceM,
      ),
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: Border.fromBorderSide(
        BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: InkWell(
        onTap: () {
          onListTilePressed(parcel);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Constants.spaceM,
            horizontal: Constants.spaceM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: StandardText.bigger(
                  "${LocaleKeys.parcelNumber.tr()} ${parcel.parcelNumber}",
                  isUnderlined: true,
                ),
              ),
              SizedBox(height: Constants.spaceS),
              KeyValueText(
                keyText: "Price per day (USD)",
                valueText: "${parcel.pricePerParcel}",
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: 'Max people',
                valueText: parcel.maxPeople.toString(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.parcelLength.tr(),
                valueText: parcel.parcelLength.toString(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.parcelWidth.tr(),
                valueText: parcel.parcelLength.toString(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.hasElectricity.tr(),
                valueText: parcel.hasElectricity
                    ? LocaleKeys.yes.tr()
                    : LocaleKeys.no.tr(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.hasGreyWaterDisposal.tr(),
                valueText: parcel.hasGreyWaterDisposal
                    ? LocaleKeys.yes.tr()
                    : LocaleKeys.no.tr(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.isShaded.tr(),
                valueText:
                    parcel.isShaded ? LocaleKeys.yes.tr() : LocaleKeys.no.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
