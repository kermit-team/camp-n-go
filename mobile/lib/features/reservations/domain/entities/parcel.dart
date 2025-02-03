import 'package:campngo/features/reservations/domain/entities/camping_section.dart';
import 'package:equatable/equatable.dart';

class Parcel extends Equatable {
  final int id;
  final String position;
  final int maxNumberOfPeople;
  final String width;
  final String length;
  final bool waterConnection;
  final bool electricityConnection;
  final bool isShaded;
  final bool greyWaterDischarge;
  final String description;
  final CampingSection campingSection;

  const Parcel({
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
  });

  Parcel copyWith({
    int? parcelNumber,
    String? position,
    int? maxNumberOfPeople,
    String? width,
    String? length,
    bool? waterConnection,
    bool? electricityConnection,
    bool? isShaded,
    bool? greyWaterDischarge,
    String? description,
    CampingSection? campingSection,
  }) =>
      Parcel(
        id: parcelNumber ?? this.id,
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
      ];
}
