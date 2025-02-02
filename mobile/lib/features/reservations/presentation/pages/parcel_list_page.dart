import 'package:campngo/config/constants.dart';
import 'package:campngo/core/resources/date_time_extension.dart';
import 'package:campngo/features/reservations/domain/entities/get_parcel_list_params.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:campngo/features/reservations/presentation/cubit/parcel_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/parcel_list_widget.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ParcelListPage extends StatefulWidget {
  final GetParcelListParams params;

  const ParcelListPage({super.key, required this.params});

  @override
  State<ParcelListPage> createState() => _ParcelListPageState();
}

class _ParcelListPageState extends State<ParcelListPage> {
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
            startDate: widget.params.startDate,
            endDate: widget.params.endDate,
            adults: widget.params.adults,
            children: widget.params.children,
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
          TitleText(LocaleKeys.parcelList.tr()),
          SizedBox(height: Constants.spaceS),
          StandardText(
              '${widget.params.startDate.toDisplayString(context)} - ${widget.params.endDate.toDisplayString(context)}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StandardText(
                '${LocaleKeys.adults.tr()}: ${widget.params.adults}',
              ),
              SizedBox(
                width: Constants.spaceM,
              ),
              StandardText(
                '${LocaleKeys.children.tr()}: ${widget.params.children}',
              ),
            ],
          ),
          SizedBox(height: Constants.spaceS),
          Divider(
            color: Theme.of(context).colorScheme.primary,
            height: 1,
          ),
          const ParcelListWidget(),
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
