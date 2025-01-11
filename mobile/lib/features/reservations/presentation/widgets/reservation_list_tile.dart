import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_list_cubit.dart';
import 'package:campngo/features/shared/widgets/texts/hyperlink_text.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationListTile extends StatelessWidget {
  final ReservationPreview reservation;
  final void Function(ReservationPreview) onListTilePressed;
  final void Function(String) onCancelReservationDialogPressed;
  const ReservationListTile({
    super.key,
    required this.reservation,
    required this.onListTilePressed,
    required this.onCancelReservationDialogPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationListCubit, ReservationListState>(
      builder: (context, state) {
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
                      isBold: true,
                      isUnderlined: true,
                    ),
                  ),
                  SizedBox(height: Constants.spaceS),
                  KeyValueText(
                    keyText: LocaleKeys.stayingPeriod.tr(),
                    valueText: '\n${reservation.startDate.toDateString()}'
                        ' - ${reservation.endDate.toDateString()}',
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: Constants.spaceXXS),
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
                  SizedBox(
                    width: double.maxFinite,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        KeyValueText(
                          keyText: LocaleKeys.status.tr(),
                          valueText: reservation.reservationStatus,
                        ),
                        if (reservation.canCancel)
                          HyperlinkText(
                            text: LocaleKeys.cancel.tr(),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        LocaleKeys.areYouSure.tr(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    content: SizedBox(
                                      width: double.maxFinite,
                                      child: StandardText(
                                        '${LocaleKeys.reservationCancelConfirmation.tr()}'
                                        '${reservation.parcelNumber}?',
                                        // textAlign: TextAlign.start,
                                      ),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: StandardText(
                                          LocaleKeys.returnFrom.tr(),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          onCancelReservationDialogPressed(
                                            'mockReservationId',
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: StandardText(
                                          LocaleKeys.cancel.tr(),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
