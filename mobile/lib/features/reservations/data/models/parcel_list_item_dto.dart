// parcel_list_item_dto.dart

import 'package:campngo/features/reservations/data/models/camping_section_dto.dart';
import 'package:campngo/features/reservations/domain/entities/parcel_list_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parcel_list_item_dto.g.dart';

@JsonSerializable()
class ParcelListItemDto {
  @JsonKey(name: 'id')
  final int parcelNumber;
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
  @JsonKey(name: 'price')
  final String price;

  ParcelListItemDto({
    required this.parcelNumber,
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
    required this.price,
  });

  factory ParcelListItemDto.fromJson(Map<String, dynamic> json) =>
      _$ParcelListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelListItemDtoToJson(this);

  factory ParcelListItemDto.fromEntity(ParcelListItem entity) =>
      ParcelListItemDto(
        parcelNumber: entity.parcelNumber,
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
        price: entity.price.toString(),
      );

  ParcelListItem toEntity() => ParcelListItem(
        parcelNumber: parcelNumber,
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
        price: double.tryParse(price) ?? 0,
      );
}
