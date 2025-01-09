import 'package:campngo/config/constants.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/presentation/cubit/parcel_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/reservation_list_widget.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReservationListPage extends StatefulWidget {
  const ReservationListPage({
    super.key,
  });

  @override
  State<ReservationListPage> createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  final PagingController<int, Parcel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    context.read<ParcelListCubit>().getParcelList(
          params: GetParcelListParams(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 7)),
            adults: 2,
            children: 0,
          ),
          page: pageKey,
        );
  }

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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
