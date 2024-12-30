import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_review_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/personal_data.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/lines.dart';
import 'package:campngo/features/shared/widgets/texts/subtitle_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationReviewPage extends StatelessWidget {
  final String reservationId;

  const ReservationReviewPage({
    super.key,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          const TitleText("Przegląd rezerwacji"),
          SizedBox(height: Constants.spaceS),
          Lines.lineGoldNormal,
          SizedBox(height: Constants.spaceM),

          // SubtitleText(LocaleKeys.parcelData.tr()),
          const SubtitleText("Dane parceli"),
          SizedBox(height: Constants.spaceS),
          Lines.lineGoldThin,
          SizedBox(height: Constants.spaceM),

          // SubtitleText(LocaleKeys.personalData.tr()),
          const SubtitleText("Dane osobowe"),
          SizedBox(height: Constants.spaceS),
          Lines.lineGoldThin,
          SizedBox(height: Constants.spaceM),
          BlocBuilder<ReservationReviewCubit, ReservationReviewState>(
            builder: (context, state) {
              if (state.userStatus == SubmissionStatus.loading) {
                return CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                );
              } else if (state.userStatus == SubmissionStatus.success) {
                if (state.user != null) {
                  return PersonalData(account: state.user!);
                } else {
                  Text(LocaleKeys.empty.tr());
                }
              }
              return const Text('User data loading error');
            },
          ),
        ],
      ),
    );
  }
}
