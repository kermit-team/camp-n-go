import 'package:equatable/equatable.dart';

class ParcelEntity extends Equatable {
  final int parcelNumber;
  final int pricePerDay;
  final String description;
  final Map<String, dynamic> generalInfo;

  const ParcelEntity({
    required this.parcelNumber,
    required this.pricePerDay,
    required this.description,
    required this.generalInfo,
  });

  @override
  List<Object?> get props => [
        parcelNumber,
        pricePerDay,
        description,
        generalInfo,
      ];
}
