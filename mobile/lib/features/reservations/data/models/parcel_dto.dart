import 'package:campngo/features/reservations/data/models/camping_section_dto.dart';
import 'package:campngo/features/reservations/domain/entities/parcel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parcel_dto.g.dart';

@JsonSerializable()
class ParcelDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'position')
  final String position;
  @JsonKey(name: 'max_number_of_people')
  final int maxNumberOfPeople;
  @JsonKey(name: 'width')
  final String width;
  @JsonKey(name: 'length')
  final String length;
  @JsonKey(name: 'water_connection')
  final bool waterConnection;
  @JsonKey(name: 'electricity_connection')
  final bool electricityConnection;
  @JsonKey(name: 'is_shaded')
  final bool isShaded;
  @JsonKey(name: 'grey_water_discharge')
  final bool greyWaterDischarge;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'camping_section')
  final CampingSectionDto campingSection;

  ParcelDto({
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

  factory ParcelDto.fromJson(Map<String, dynamic> json) =>
      _$ParcelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelDtoToJson(this);

  factory ParcelDto.fromEntity(Parcel entity) => ParcelDto(
        id: entity.id,
        position: entity.position,
        maxNumberOfPeople: entity.maxNumberOfPeople,
        width: entity.width,
        length: entity.length,
        waterConnection: entity.waterConnection,
        electricityConnection: entity.electricityConnection,
        isShaded: entity.isShaded,
        greyWaterDischarge: entity.greyWaterDischarge,
        description: entity.description,
        campingSection: CampingSectionDto.fromEntity(entity.campingSection),
      );

  Parcel toEntity() => Parcel(
        id: id,
        position: position,
        maxNumberOfPeople: maxNumberOfPeople,
        width: width,
        length: length,
        waterConnection: waterConnection,
        electricityConnection: electricityConnection,
        isShaded: isShaded,
        greyWaterDischarge: greyWaterDischarge,
        description: description,
        campingSection: campingSection.toEntity(),
      );
}
