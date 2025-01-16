part of 'parcel_list_cubit.dart';

class ParcelListState extends Equatable {
  final SubmissionStatus getParcelListStatus;
  final List<ParcelListItem>? parcels;
  final int? currentPage;
  final int? totalParcels;
  final bool? hasMoreParcels;
  final Exception? exception;

  final GetParcelListParams? params;

  const ParcelListState({
    this.getParcelListStatus = SubmissionStatus.initial,
    this.parcels,
    this.currentPage,
    this.totalParcels,
    this.hasMoreParcels,
    this.exception,
    this.params,
  });

  copyWith({
    SubmissionStatus? getParcelListStatus,
    List<ParcelListItem>? parcels,
    int? currentPage,
    int? totalParcels,
    bool? hasMoreParcels,
    Exception? exception,
    GetParcelListParams? params,
  }) =>
      ParcelListState(
        getParcelListStatus: getParcelListStatus ?? this.getParcelListStatus,
        parcels: parcels ?? this.parcels,
        currentPage: currentPage ?? this.currentPage,
        totalParcels: totalParcels ?? this.totalParcels,
        hasMoreParcels: hasMoreParcels ?? this.hasMoreParcels,
        exception: exception ?? this.exception,
        params: params ?? this.params,
      );

  @override
  List<Object?> get props => [
        getParcelListStatus,
        parcels,
        currentPage,
        totalParcels,
        hasMoreParcels,
        exception,
        params,
      ];
}
