import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/presentation/widgets/car_list.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_summary_cubit.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
          SizedBox(height: Constants.spaceL),
          _ReservationData(
            params: params,
            parcel: parcel,
          ),
          SizedBox(height: Constants.spaceML),
          BlocBuilder<ReservationSummaryCubit, ReservationSummaryState>(
            builder: (context, state) {
              switch (state.getUserDataStatus) {
                case SubmissionStatus.initial:
                case SubmissionStatus.loading:
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  );
                case SubmissionStatus.success:
                  if (state.account != null && state.carList != null) {
                    return _UserData(
                      account: state.account!,
                      carList: state.carList!,
                    );
                  }
                  return Center(
                    child: StandardText(
                      LocaleKeys.loadingDataError.tr(),
                    ),
                  );
                case SubmissionStatus.failure:
                  return Center(
                    child: StandardText(
                      LocaleKeys.loadingDataError.tr(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _UserData extends StatelessWidget {
  final Account account;
  final List<Car> carList;

  const _UserData({
    super.key,
    required this.account,
    required this.carList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StandardText(
          LocaleKeys.userData.tr(),
          isBold: true,
        ),
        Divider(color: Theme.of(context).colorScheme.primary),
        KeyValueText(
          keyText: LocaleKeys.firstName.tr(),
          valueText: account.profile.firstName,
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.lastName.tr(),
          valueText: account.profile.lastName,
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.email.tr(),
          valueText: account.email,
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.phoneNumber.tr(),
          valueText: account.profile.phoneNumber != null
              ? account.profile.phoneNumber.toString()
              : '---',
        ),
        SizedBox(height: Constants.spaceXS),
        KeyValueText(
          keyText: LocaleKeys.idNumber.tr(),
          valueText: account.profile.idCard != null
              ? account.profile.idCard.toString()
              : '---',
        ),
        SizedBox(height: Constants.spaceXS),
        StandardText('${LocaleKeys.assignCarToReservation.tr()}:'),
        SizedBox(height: Constants.spaceXS),
        carList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemCount: carList.length,
                itemBuilder: (context, index) {
                  return CarListItem(
                    car: carList[index],
                    isAssigned: carList[index].assignedToReservation,
                    showDots: false,
                    onListTilePressed: (Car car) {
                      context
                          .read<ReservationSummaryCubit>()
                          .assignCarToReservation(carToAssign: car);
                    },
                  );
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StandardText(
                    LocaleKeys.addCarToFinalize.tr(),
                    isBold: true,
                  ),
                  CustomButton(
                    text: LocaleKeys.accountSettings,
                    onPressed: () {
                      serviceLocator<GoRouter>()
                          .push(AppRoutes.accountSettings.route)
                          .then((value) {
                        if (context.mounted) {
                          context
                              .read<ReservationSummaryCubit>()
                              .getAccountData();
                        }
                      });
                    },
                  ),
                ],
              ),
      ],
    );
  }
}

class _ReservationData extends StatelessWidget {
  final Parcel parcel;
  final GetParcelListParams params;

  const _ReservationData({
    super.key,
    required this.params,
    required this.parcel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StandardText(
          LocaleKeys.reservationData.tr(),
          isBold: true,
        ),
        Divider(color: Theme.of(context).colorScheme.primary),
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
      ],
    );
  }
}
