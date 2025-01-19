import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/features/reservations/domain/entities/reservation_preview.dart';
import 'package:campngo/features/reservations/presentation/cubit/reservation_list_cubit.dart';
import 'package:campngo/features/reservations/presentation/widgets/reservation_list_tile.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReservationListWidget extends StatefulWidget {
  const ReservationListWidget({super.key});

  @override
  State<ReservationListWidget> createState() => _ReservationListWidgetState();
}

class _ReservationListWidgetState extends State<ReservationListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<ReservationListCubit>().getReservationList(page: 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isAtBottom() &&
        context.read<ReservationListCubit>().state.hasMoreItems!) {
      _loadMoreTasks();
    }
  }

  bool _isAtBottom() {
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  void _loadMoreTasks() {
    final currentState = context.read<ReservationListCubit>().state;
    context.read<ReservationListCubit>().getReservationList(
          page: currentState.currentPage! + 1,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationListCubit, ReservationListState>(
      listener: (context, state) {
        switch (state.cancelReservationStatus) {
          case SubmissionStatus.initial:
          case SubmissionStatus.loading:
            break;
          case SubmissionStatus.success:
            AppSnackBar.showSnackBar(
              context: context,
              text: LocaleKeys.reservationCancelled.tr(),
            );
            context.read<ReservationListCubit>().getReservationList(page: 1);
          case SubmissionStatus.failure:
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: state.exception.toString(),
            );
        }
      },
      builder: (context, state) {
        if (state.getReservationListStatus == SubmissionStatus.loading ||
            state.getReservationListStatus == SubmissionStatus.initial) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        } else if (state.getReservationListStatus == SubmissionStatus.failure) {
          return Expanded(
            child: Center(
              child: Text(LocaleKeys.somethingWentWrong.tr()),
            ),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: Constants.spaceM),
              controller: _scrollController,
              itemCount:
                  state.reservations!.length + (state.hasMoreItems! ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.reservations!.length) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: Constants.spaceM),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return ReservationListTile(
                  reservation: state.reservations![index],
                  onListTilePressed: (ReservationPreview reservation) {
                    context.push(
                      AppRoutes.reservationPreview.route,
                      extra: state.reservations![index].id,
                    );
                  },
                  onCancelReservationDialogPressed: (reservationId) {
                    context.read<ReservationListCubit>().cancelReservation(
                          reservationId: reservationId,
                        );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
