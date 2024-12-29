import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReservationSummaryPage extends StatelessWidget {
  final Parcel parcel;
  final GetParcelListParams params;

  const ReservationSummaryPage({
    super.key,
    required this.parcel,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Constants.spaceL, width: 100.w),
          TitleText(LocaleKeys.reservationSummary.tr()),
          SizedBox(height: Constants.spaceM),
          Center(
            child: StandardText(LocaleKeys.reservationData.tr()),
          ),
          SizedBox(height: Constants.spaceXXS),
          Divider(color: Theme.of(context).colorScheme.primary),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.parcelNumber.tr(),
            valueText: parcel.parcelNumber.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.description.tr(),
            valueText: parcel.description,
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.stayingPeriod.tr(),
            valueText:
                '${params.startDate.toDateString()} - ${params.endDate.toDateString()}',
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.numberOfNights.tr(),
            valueText:
                params.startDate.difference(params.endDate).inDays.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.numberOfAdults.tr(),
            valueText: params.adults.toString(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.numberOfChildren.tr(),
            valueText: params.children.toString(),
          ),
          SizedBox(height: Constants.spaceL),
          Center(child: StandardText(LocaleKeys.userData.tr())),
          SizedBox(height: Constants.spaceXXS),
          Divider(color: Theme.of(context).colorScheme.primary),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText:
                '${LocaleKeys.firstName.tr()} ${LocaleKeys.and.tr()} ${LocaleKeys.lastName.tr()}',
            valueText: 'Katarzyna Szczepańczyk',
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.email.tr(),
            valueText: 'dlugiemail@email.com',
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.phoneNumber.tr(),
            valueText: '123 456 789',
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.idNumber.tr(),
            valueText: '12345678901',
          ),
          SizedBox(height: Constants.spaceXS),
          StandardText('${LocaleKeys.cars.tr()}:')
        ],
      ),
    );
  }
}
