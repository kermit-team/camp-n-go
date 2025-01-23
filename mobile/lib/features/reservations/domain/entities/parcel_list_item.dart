// parcel_list_item.dart

import 'package:campngo/features/reservations/domain/entities/camping_section.dart';
import 'package:equatable/equatable.dart';

class ParcelListItem extends Equatable {
  final int id;
  final String position;
  final int maxNumberOfPeople;
  final double width;
  final double length;
  final bool waterConnection;
  final bool electricityConnection;
  final bool isShaded;
  final bool greyWaterDischarge;
  final String description;
  final CampingSection campingSection;
  final ParcelMetadata metadata;

  const ParcelListItem({
    required this.id,
    required this.position,
    required this.maxNumberOfPeople,
    required this.width,
    required this.length,
    required this.waterConnection,
    required this.electricityConnection,
    required this.isShaded,
    required this.greyWaterDischarge,
    required this.description,
    required this.campingSection,
    required this.metadata,
  });

  ParcelListItem copyWith({
    int? id,
    String? position,
    int? maxNumberOfPeople,
    double? width,
    double? length,
    bool? waterConnection,
    bool? electricityConnection,
    bool? isShaded,
    bool? greyWaterDischarge,
    String? description,
    CampingSection? campingSection,
    ParcelMetadata? metadata,
  }) =>
      ParcelListItem(
        id: id ?? this.id,
        position: position ?? this.position,
        maxNumberOfPeople: maxNumberOfPeople ?? this.maxNumberOfPeople,
        width: width ?? this.width,
        length: length ?? this.length,
        waterConnection: waterConnection ?? this.waterConnection,
        electricityConnection:
            electricityConnection ?? this.electricityConnection,
        isShaded: isShaded ?? this.isShaded,
        greyWaterDischarge: greyWaterDischarge ?? this.greyWaterDischarge,
        description: description ?? this.description,
        campingSection: campingSection ?? this.campingSection,
        metadata: metadata ?? this.metadata,
      );

  @override
  List<Object?> get props => [
        id,
        position,
        maxNumberOfPeople,
        width,
        length,
        waterConnection,
        electricityConnection,
        isShaded,
        greyWaterDischarge,
        description,
        campingSection,
        metadata,
      ];
}

class ParcelMetadata extends Equatable {
  final int overallPrice;
  final int basePrice;
  final int adultsPrice;
  final int childrenPrice;

  const ParcelMetadata({
    required this.overallPrice,
    required this.basePrice,
    required this.adultsPrice,
    required this.childrenPrice,
  });

  ParcelMetadata copyWith({
    int? overallPrice,
    int? basePrice,
    int? adultsPrice,
    int? childrenPrice,
  }) =>
      ParcelMetadata(
        overallPrice: overallPrice ?? this.overallPrice,
        basePrice: basePrice ?? this.basePrice,
        adultsPrice: adultsPrice ?? this.adultsPrice,
        childrenPrice: childrenPrice ?? this.childrenPrice,
      );

  @override
  List<Object?> get props => [
        overallPrice,
        basePrice,
        adultsPrice,
        childrenPrice,
      ];
}
