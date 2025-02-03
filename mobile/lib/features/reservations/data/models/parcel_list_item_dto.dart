// parcel_list_item_dto.dart

import 'package:campngo/features/reservations/data/models/camping_section_dto.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parcel_list_item_dto.g.dart';

@JsonSerializable()
class ParcelListItemDto {
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
  @JsonKey(name: 'metadata')
  final ParcelMetadataDto metadata;

  ParcelListItemDto({
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

  factory ParcelListItemDto.fromJson(Map<String, dynamic> json) =>
      _$ParcelListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelListItemDtoToJson(this);

  factory ParcelListItemDto.fromEntity(ParcelListItem entity) =>
      ParcelListItemDto(
        id: entity.id,
        position: entity.position,
        maxNumberOfPeople: entity.maxNumberOfPeople,
        width: entity.width.toString(),
        length: entity.length.toString(),
        waterConnection: entity.waterConnection,
        electricityConnection: entity.electricityConnection,
        isShaded: entity.isShaded,
        greyWaterDischarge: entity.greyWaterDischarge,
        description: entity.description,
        campingSection: CampingSectionDto.fromEntity(entity.campingSection),
        metadata: ParcelMetadataDto.fromEntity(entity.metadata),
      );

  ParcelListItem toEntity() => ParcelListItem(
        id: id,
        position: position,
        maxNumberOfPeople: maxNumberOfPeople,
        width: double.tryParse(width) ?? 0,
        length: double.tryParse(length) ?? 0,
        waterConnection: waterConnection,
        electricityConnection: electricityConnection,
        isShaded: isShaded,
        greyWaterDischarge: greyWaterDischarge,
        description: description,
        campingSection: campingSection.toEntity(),
        metadata: metadata.toEntity(),
      );
}

@JsonSerializable()
class ParcelMetadataDto {
  @JsonKey(name: 'overall_price')
  final int overallPrice;
  @JsonKey(name: 'base_price')
  final int basePrice;
  @JsonKey(name: 'adults_price')
  final int adultsPrice;
  @JsonKey(name: 'children_price')
  final int childrenPrice;

  ParcelMetadataDto({
    required this.overallPrice,
    required this.basePrice,
    required this.adultsPrice,
    required this.childrenPrice,
  });

  factory ParcelMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$ParcelMetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelMetadataDtoToJson(this);

  factory ParcelMetadataDto.fromEntity(ParcelMetadata entity) =>
      ParcelMetadataDto(
        overallPrice: entity.overallPrice,
        basePrice: entity.basePrice,
        adultsPrice: entity.adultsPrice,
        childrenPrice: entity.childrenPrice,
      );

  ParcelMetadata toEntity() => ParcelMetadata(
        overallPrice: overallPrice,
        basePrice: basePrice,
        adultsPrice: adultsPrice,
        childrenPrice: childrenPrice,
      );
}
