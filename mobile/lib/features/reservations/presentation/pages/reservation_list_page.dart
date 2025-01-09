import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/presentation/widgets/reservation_list_widget.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({
    super.key,
  });

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  @override
  Widget build(BuildContext context) {
    return AppBody(
      scrollable: false,
      child: Column(
        children: [
          TitleText(LocaleKeys.reservationList.tr()),
          SizedBox(height: Constants.spaceS),
          Divider(
            color: Theme.of(context).colorScheme.primary,
            height: 1,
          ),
          const ReservationListWidget(),
        ],
      ),
    );
  }
}
