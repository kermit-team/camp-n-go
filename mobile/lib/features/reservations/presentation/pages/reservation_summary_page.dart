import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/core/resources/string_extension.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_list_item.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_summary_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/golden_car_dropdown.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/lines.dart';
import 'package:campngo/features/shared/widgets/texts/hyperlink_text.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReservationSummaryPage extends StatefulWidget {
  final ParcelListItem parcel;
  final GetParcelListParams params;

  const ReservationSummaryPage({
    super.key,
    required this.parcel,
    required this.params,
  });

  @override
  State<ReservationSummaryPage> createState() => _ReservationSummaryPageState();
}

class _ReservationSummaryPageState extends State<ReservationSummaryPage> {
  final formKey = GlobalKey<FormState>();
  late double priceForAdults;
  late double priceForChildren;
  late double basePrice;

  @override
  void initState() {
    super.initState();
    basePrice = widget.parcel.campingSection.basePrice *
        widget.params.endDate.difference(widget.params.startDate).inDays;
    priceForAdults =
        widget.parcel.campingSection.pricePerAdult * widget.params.adults;
    priceForChildren =
        widget.parcel.campingSection.pricePerChild * widget.params.children;
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(LocaleKeys.reservationSummary.tr()),
          SizedBox(height: Constants.spaceL),
          _ReservationData(
            params: widget.params,
            parcel: widget.parcel,
          ),
          SizedBox(height: Constants.spaceML),
          BlocBuilder<ReservationSummaryCubit, ReservationSummaryState>(
            builder: (context, state) {
              switch (state.getUserDataStatus) {
                case SubmissionStatus.initial:
                  context.read<ReservationSummaryCubit>().getAccountData();
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  );
                case SubmissionStatus.loading:
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  );
                case SubmissionStatus.success:
                  if (state.account != null && state.carList != null) {
                    return _UserData(
                      account: state.account!,
                      formKey: formKey,
                      // carList: state.carList!,
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
          SizedBox(height: Constants.spaceML),
          StandardText(
            LocaleKeys.payment.tr(),
            isBold: true,
          ),
          Lines.goldenDivider,
          KeyValueText(
            keyText: LocaleKeys.baseParcelPrice.tr(),
            valueText: basePrice.toStringAsFixed(2).toPlnPrice(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.priceForAdults.tr(),
            valueText: priceForAdults.toStringAsFixed(2).toPlnPrice(),
          ),
          SizedBox(height: Constants.spaceXS),
          KeyValueText(
            keyText: LocaleKeys.priceForChildren.tr(),
            valueText: priceForChildren.toStringAsFixed(2).toPlnPrice(),
          ),
          Lines.goldenDivider,
          Row(
            children: [
              StandardText(
                '${LocaleKeys.totalAmount.tr()}: ',
                isBold: true,
              ),
              StandardText(
                (widget.parcel.metadata.overallPrice)
                    .toStringAsFixed(2)
                    .toPlnPrice(),
                isBold: true,
              ),
            ],
          ),
          SizedBox(height: Constants.spaceXS),
          CustomButton(
            text: LocaleKeys.reserve.tr(),
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                // context.read<ReservationSummaryCubit>().makeReservation();
                AppSnackBar.showSnackBar(
                  context: context,
                  text: LocaleKeys.reservationData.tr(),
                );
              }
            },
          ),
          SizedBox(height: Constants.spaceL),
        ],
      ),
    );
  }
}

class _UserData extends StatelessWidget {
  final Account account;

  const _UserData({
    required this.account,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationSummaryCubit, ReservationSummaryState>(
        builder: (context, state) {
      return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                StandardText(
                  LocaleKeys.userData.tr(),
                  isBold: true,
                ),
                const Spacer(),
                HyperlinkText(
                  text: LocaleKeys.edit.tr(),
                  onTap: () async {
                    await context.push(
                      AppRoutes.accountSettings.route,
                    );
                    // .then(
                    if (context.mounted) {
                      context.read<ReservationSummaryCubit>().getAccountData();
                    }
                    // );
                  },
                ),
                // SizedBox(width: Constants.spaceXS),
              ],
            ),
            Lines.goldenDivider,
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
            state.carList != null
                ? GoldenCarDropdown(
                    cars: state.carList!,
                    hintText: LocaleKeys.selectCar.tr(),
                    validations: const [RequiredValidation()],
                    selectedCar: state.assignedCar,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StandardText(
                        LocaleKeys.addCarToFinalize.tr(),
                        isBold: true,
                      ),
                      CustomButton(
                        text: LocaleKeys.accountSettings.tr(),
                        onPressed: () {
                          context
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
        ),
      );
    });
  }
}

class _ReservationData extends StatelessWidget {
  final ParcelListItem parcel;
  final GetParcelListParams params;

  const _ReservationData({
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
        Lines.goldenDivider,
        KeyValueText(
          keyText: LocaleKeys.sector.tr(),
          valueText: parcel.campingSection.name,
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
