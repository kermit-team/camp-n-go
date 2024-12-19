import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_entity.dart';
import 'package:campngo/features/reservations/presentation/widgets/parcel_details_dialog.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/subtitle_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ParcelList extends StatelessWidget {
  final void Function(ParcelEntity) onListTilePressed;
  final List<ParcelEntity> parcelList;

  const ParcelList({
    super.key,
    required this.onListTilePressed,
    required this.parcelList,
  });

  @override
  Widget build(BuildContext context) {
    //TODO: add cubit handling
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemCount: parcelList.length,
          itemBuilder: (context, index) {
            final parcel = parcelList[index];
            return ParcelListItem(
              parcel: parcel,
              onListTilePressed: onListTilePressed,
            );
          },
        )
      ],
    );
  }
}

class ParcelListItem extends StatelessWidget {
  final ParcelEntity parcel;
  final void Function(ParcelEntity) onListTilePressed;

  const ParcelListItem({
    super.key,
    required this.parcel,
    required this.onListTilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
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
          showDialog(
            context: context,
            builder: (context) {
              return ParcelDetailsDialog(
                parcel: parcel,
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Constants.spaceM,
            horizontal: Constants.spaceM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SubtitleText(
                  "${LocaleKeys.parcelNumber.tr()} ${parcel.parcelNumber}",
                  isUnderlined: true,
                ),
              ),
              const SizedBox(height: Constants.spaceS),
              KeyValueText(
                keyText: "Price per day (USD)",
                valueText: "${parcel.pricePerDay}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
