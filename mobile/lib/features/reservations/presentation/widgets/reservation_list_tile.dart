import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/texts/hyperlink_text.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReservationListTile extends StatelessWidget {
  final ReservationPreview reservation;
  final void Function(ReservationPreview) onListTilePressed;

  const ReservationListTile({
    super.key,
    required this.reservation,
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
          onListTilePressed(reservation);
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
                  "${LocaleKeys.parcelNumber.tr()} ${reservation.parcelNumber}",
                  isUnderlined: true,
                ),
              ),
              SizedBox(height: Constants.spaceS),
              Center(
                child: KeyValueText(
                  keyText: LocaleKeys.stayingPeriod.tr(),
                  valueText:
                      '\n${reservation.startDate.toDisplayString(context)}'
                      ' - ${reservation.endDate.toDisplayString(context)}',
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Constants.spaceS),
              KeyValueText(
                keyText: LocaleKeys.price.tr(),
                valueText:
                    '${reservation.reservationPrice.toStringAsFixed(2)} zł',
              ),
              SizedBox(height: Constants.spaceXXS),
              KeyValueText(
                keyText: LocaleKeys.sector.tr(),
                valueText: reservation.sector,
              ),
              SizedBox(height: Constants.spaceXXS),
              Row(
                children: [
                  KeyValueText(
                    keyText: LocaleKeys.status.tr(),
                    valueText: reservation.reservationStatus,
                  ),
                  const Spacer(),
                  if (reservation.canCancel)
                    HyperlinkText(
                      text: LocaleKeys.cancel.tr(),
                      onTap: () {
                        AppSnackBar.showSnackBar(
                          text: 'odwoływanie...',
                          context: context,
                        );
                      },
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
