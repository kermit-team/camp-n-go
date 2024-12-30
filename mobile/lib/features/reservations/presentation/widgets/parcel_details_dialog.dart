import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/presentation/widgets/parcel_details.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/subtitle_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParcelDetailsDialog extends StatelessWidget {
  final Parcel parcel;
  final GetParcelListParams params;

  const ParcelDetailsDialog({
    super.key,
    required this.parcel,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const Border(),
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.width * 0.05,
      ),
      titlePadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        top: MediaQuery.of(context).size.width * 0.05,
        bottom: 0,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SubtitleText(
              "${LocaleKeys.parcelNumber.tr()} ${parcel.parcelNumber}",
              isUnderlined: false,
            ),
          ),
          Divider(
            color: Theme.of(context).colorScheme.primary,
            height: 2,
            thickness: 2,
          ),
          SizedBox(height: Constants.spaceS),
          Image.asset(
            'assets/images/parcel_example.png',
          ),
          SizedBox(height: Constants.spaceS),
          Divider(
            color: Theme.of(context).colorScheme.primary,
            height: 2,
            thickness: 2,
          ),
        ],
      ),
      content: ParcelDetailsWidget(parcel: parcel),
      contentPadding: EdgeInsets.symmetric(
        // top: Constants.spaceM,
        vertical: 0,
        horizontal: Constants.spaceM,
      ),
      actions: [
        Column(
          children: [
            Divider(
              color: Theme.of(context).colorScheme.primary,
              height: 2,
              thickness: 2,
            ),
            SizedBox(height: Constants.spaceS),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: Constants.textSizeMS,
                ),
                SizedBox(width: Constants.spaceXXS),
                StandardText(
                    '${params.startDate.toDateString()} - ${params.endDate.toDateString()}'),
              ],
            ),
            SizedBox(height: Constants.spaceXXS),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: Constants.textSizeMS,
                ),
                SizedBox(width: Constants.spaceXXS),
                StandardText(
                    '${LocaleKeys.numberOfAdults.tr()}: ${params.adults}'),
              ],
            ),
            SizedBox(height: Constants.spaceXXS),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: Constants.textSizeMS,
                ),
                SizedBox(width: Constants.spaceXXS),
                StandardText(
                    '${LocaleKeys.numberOfChildren.tr()}: ${params.children}'),
              ],
            ),
            SizedBox(height: Constants.spaceS),
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
                SizedBox(width: Constants.spaceS),
                Expanded(
                  child: CustomButton(
                    text: LocaleKeys.reserve.tr(),
                    onPressed: () {
                      Navigator.of(context).pop();
                      serviceLocator<GoRouter>().push(
                        '/reservationSummary',
                        extra: {
                          'parcel': parcel,
                          'params': params,
                        },
                      );
                    },
                    width: double.minPositive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
