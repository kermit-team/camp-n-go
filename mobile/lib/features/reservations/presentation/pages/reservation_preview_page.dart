import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_preview_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/golden_car_dropdown.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/lines.dart';
import 'package:campngo/features/shared/widgets/texts/key_value_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationPreviewPage extends StatefulWidget {
  final int reservationId;

  const ReservationPreviewPage({
    super.key,
    required this.reservationId,
  });

  @override
  State<ReservationPreviewPage> createState() => _ReservationPreviewPageState();
}

class _ReservationPreviewPageState extends State<ReservationPreviewPage> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ReservationPreviewCubit>().getReservationData(
          reservationId: widget.reservationId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationPreviewCubit, ReservationPreviewState>(
      builder: (context, state) {
        switch (state.getReservationStatus) {
          case SubmissionStatus.initial:
          case SubmissionStatus.loading:
            return AppBody(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          case SubmissionStatus.failure:
            context.read<ReservationPreviewCubit>().resetGetReservationStatus();
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: state.exception.toString(),
            );
            return AppBody(
              child: Center(
                child: StandardText(
                  LocaleKeys.reservationNotLoadedCorrectly.tr(),
                ),
              ),
            );
          case SubmissionStatus.success:
            return AppBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: TitleText(LocaleKeys.reservationPreview.tr()),
                  ),
                  SizedBox(height: Constants.spaceL),
                  _ReservationData(
                    params: GetParcelListParams(
                      startDate: state.reservation!.startDate,
                      endDate: state.reservation!.endDate,
                      adults: state.reservation!.numberOfAdults,
                      children: state.reservation!.numberOfChildren,
                    ),
                    parcel: state.reservation!.parcel,
                  ),
                  SizedBox(height: Constants.spaceML),
                  _UserData(
                    account: state.reservation!.account,
                    formKey: formKey,
                    reservationId: widget.reservationId,
                  ),
                  SizedBox(height: Constants.spaceML),
                  SizedBox(height: Constants.spaceL),
                ],
              ),
            );
        }
      },
    );
  }
}

class _UserData extends StatelessWidget {
  final Account account;
  final int reservationId;

  const _UserData({
    required this.account,
    required this.formKey,
    required this.reservationId,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationPreviewCubit, ReservationPreviewState>(
        listener: (context, state) {
      switch (state.editCarStatus) {
        case SubmissionStatus.initial:
        case SubmissionStatus.loading:
          break;
        case SubmissionStatus.success:
          context.read<ReservationPreviewCubit>().resetEditCarStatus();
          if (context.mounted) {
            AppSnackBar.showSnackBar(
              context: context,
              text: LocaleKeys.carEdited.tr(),
            );
          }
        // context.read<ReservationPreviewCubit>().getReservationData(
        //       reservationId: reservationId,
        //     );
        case SubmissionStatus.failure:
          context.read<ReservationPreviewCubit>().resetEditCarStatus();
          if (context.mounted) {
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: LocaleKeys.carNotEdited.tr(),
            );
          }
      }
    }, builder: (context, state) {
      return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StandardText(
              LocaleKeys.userData.tr(),
              isBold: true,
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
            state.reservation!.isCarModifiable
                ? GoldenCarDropdown(
                    cars: state.reservation!.account.carList,
                    hintText: LocaleKeys.selectCar.tr(),
                    validations: const [RequiredValidation()],
                    selectedCar: state.reservation!.car,
                    onChanged: (car) {
                      context.read<ReservationPreviewCubit>().editCar(
                            reservationId: reservationId,
                            carId: car!.id,
                          );
                    },
                  )
                : KeyValueText(
                    keyText: LocaleKeys.selectedCar.tr(),
                    valueText: state.reservation?.car.registrationPlate ?? '',
                  ),
          ],
        ),
      );
    });
  }
}

class _ReservationData extends StatelessWidget {
  final GetParcelListParams params;
  final Parcel parcel;

  const _ReservationData({
    required this.params,
    required this.parcel,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocBuilder<ReservationPreviewCubit, ReservationPreviewState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StandardText(
              LocaleKeys.reservationData.tr(),
              isBold: true,
            ),
            Lines.goldenDivider,
            KeyValueText(
              keyText: LocaleKeys.parcelNumber.tr(),
              valueText: parcel.position,
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
                  params.endDate.difference(params.startDate).inDays.toString(),
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
            SizedBox(height: Constants.spaceXS),
            KeyValueText(
              keyText: LocaleKeys.reservationStatus.tr(),
              valueText: state.reservation?.payment.status.name.tr() ??
                  LocaleKeys.unknown.tr(),
            ),
          ],
        );
      },
    );
  }
}
