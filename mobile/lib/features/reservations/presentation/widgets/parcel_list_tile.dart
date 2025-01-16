import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_list_item.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelListTile extends StatelessWidget {
  final ParcelListItem parcel;
  final void Function(ParcelListItem) onListTilePressed;
  final GetParcelListParams params;
  final double pricePerDay;

  ParcelListTile({
    super.key,
    required this.parcel,
    required this.onListTilePressed,
    required this.params,
  }) : pricePerDay = parcel.campingSection.basePrice +
            parcel.campingSection.pricePerAdult * params.adults +
            parcel.campingSection.pricePerChild * params.children;

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
                  "${LocaleKeys.sector.tr()} ${parcel.campingSection.name}",
                  isBold: true,
                  isUnderlined: true,
                ),
              ),
              SizedBox(height: Constants.spaceS),
              KeyValueText(
                keyText: LocaleKeys.pricePerDay.tr(),
                valueText: "$pricePerDay",
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: 'Max people',
                valueText: parcel.maxNumberOfPeople.toString(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.parcelLength.tr(),
                valueText: parcel.length.toString(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.parcelWidth.tr(),
                valueText: parcel.width.toString(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.hasElectricity.tr(),
                valueText: parcel.electricityConnection
                    ? LocaleKeys.yes.tr()
                    : LocaleKeys.no.tr(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.hasWater.tr(),
                valueText: parcel.waterConnection
                    ? LocaleKeys.yes.tr()
                    : LocaleKeys.no.tr(),
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.hasGreyWaterDisposal.tr(),
                valueText: parcel.greyWaterDischarge
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
