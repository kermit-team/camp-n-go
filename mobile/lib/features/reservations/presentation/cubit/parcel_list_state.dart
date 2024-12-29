part of 'parcel_list_cubit.dart';

class ParcelListState extends Equatable {
  final SubmissionStatus getParcelListStatus;
  final List<Parcel>? parcels;
  final int? currentPage;
  final int? parcelsPerPage;
  final int? totalParcels;
  final bool? hasMoreParcels;
  final Exception? exception;

  final GetParcelListParams? params;

  const ParcelListState({
    this.getParcelListStatus = SubmissionStatus.initial,
    this.parcels,
    this.currentPage,
    this.parcelsPerPage,
    this.totalParcels,
    this.hasMoreParcels,
    this.exception,
    this.params,
  });

  copyWith({
    SubmissionStatus? getParcelListStatus,
    List<Parcel>? parcels,
    int? currentPage,
    int? parcelsPerPage,
    int? totalParcels,
    bool? hasMoreParcels,
    Exception? exception,
    GetParcelListParams? params,
  }) =>
      ParcelListState(
        getParcelListStatus: getParcelListStatus ?? this.getParcelListStatus,
        parcels: parcels ?? this.parcels,
        currentPage: currentPage ?? this.currentPage,
        parcelsPerPage: parcelsPerPage ?? this.parcelsPerPage,
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
        parcelsPerPage,
        totalParcels,
        hasMoreParcels,
        exception,
        params,
      ];
}
