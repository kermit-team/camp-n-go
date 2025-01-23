part of 'reservation_list_cubit.dart';

enum SubmissionStatus { initial, loading, success, failure }

class ReservationListState extends Equatable {
  final SubmissionStatus getReservationListStatus;
  final SubmissionStatus cancelReservationStatus;
  final List<ReservationPreview>? reservations;
  final int? currentPage;
  final int? itemsPerPage;
  final int? totalItems;
  final bool? hasMoreItems;
  final Exception? exception;

  const ReservationListState({
    this.getReservationListStatus = SubmissionStatus.initial,
    this.cancelReservationStatus = SubmissionStatus.initial,
    this.reservations,
    this.currentPage,
    this.itemsPerPage,
    this.totalItems,
    this.hasMoreItems,
    this.exception,
  });

  ReservationListState copyWith({
    SubmissionStatus? getReservationListStatus,
    SubmissionStatus? cancelReservationStatus,
    List<ReservationPreview>? reservations,
    int? currentPage,
    int? itemsPerPage,
    int? totalItems,
    bool? hasMoreItems,
    Exception? exception,
  }) =>
      ReservationListState(
        getReservationListStatus:
            getReservationListStatus ?? this.getReservationListStatus,
        cancelReservationStatus:
            cancelReservationStatus ?? this.cancelReservationStatus,
        reservations: reservations ?? this.reservations,
        currentPage: currentPage ?? this.currentPage,
        itemsPerPage: itemsPerPage ?? this.itemsPerPage,
        totalItems: totalItems ?? this.totalItems,
        hasMoreItems: hasMoreItems ?? this.hasMoreItems,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        getReservationListStatus,
        cancelReservationStatus,
        reservations,
        currentPage,
        itemsPerPage,
        totalItems,
        hasMoreItems,
        exception,
      ];
}
