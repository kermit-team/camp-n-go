import 'package:campngo/features/reservations/data/models/camping_section_dto.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parcel_dto.g.dart';

@JsonSerializable()
class ParcelDto {
  final String position;
  @JsonKey(name: 'max_number_of_people')
  final int maxNumberOfPeople;
  final String width;
  final String length;
  @JsonKey(name: 'water_connection')
  final bool waterConnection;
  @JsonKey(name: 'electricity_connection')
  final bool electricityConnection;
  @JsonKey(name: 'is_shaded')
  final bool isShaded;
  @JsonKey(name: 'grey_water_discharge')
  final bool greyWaterDischarge;
  final String description;
  @JsonKey(name: 'camping_section')
  final CampingSectionDto campingSection;

  ParcelDto({
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

  factory ParcelDto.fromJson(Map<String, dynamic> json) =>
      _$ParcelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelDtoToJson(this);

  factory ParcelDto.fromEntity(Parcel parcel) => ParcelDto(
        position: parcel.position,
        maxNumberOfPeople: parcel.maxNumberOfPeople,
        width: parcel.width.toStringAsFixed(2),
        length: parcel.length.toStringAsFixed(2),
        waterConnection: parcel.waterConnection,
        electricityConnection: parcel.electricityConnection,
        isShaded: parcel.isShaded,
        greyWaterDischarge: parcel.greyWaterDischarge,
        description: parcel.description,
        campingSection: CampingSectionDto.fromEntity(parcel.campingSection),
      );

  Parcel toEntity() => Parcel(
        position: position,
        maxNumberOfPeople: maxNumberOfPeople,
        description: description,
        length: double.tryParse(length) ?? 0.0,
        width: double.tryParse(width) ?? 0.0,
        electricityConnection: electricityConnection,
        waterConnection: waterConnection,
        greyWaterDischarge: greyWaterDischarge,
        isShaded: isShaded,
        campingSection: campingSection.toEntity(),
      );
}
