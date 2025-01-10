import 'package:campngo/features/reservations/domain/entities/camping_section.dart';
import 'package:json_annotation/json_annotation.dart';

part 'camping_section_dto.g.dart';

@JsonSerializable()
class CampingSectionDto {
  final String name;
  @JsonKey(name: 'base_price')
  final String basePrice;
  @JsonKey(name: 'price_per_adult')
  final String pricePerAdult;
  @JsonKey(name: 'price_per_child')
  final String pricePerChild;

  CampingSectionDto({
    required this.name,
    required this.basePrice,
    required this.pricePerAdult,
    required this.pricePerChild,
  });

  factory CampingSectionDto.fromJson(Map<String, dynamic> json) =>
      _$CampingSectionDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CampingSectionDtoToJson(this);

  factory CampingSectionDto.fromEntity(CampingSection section) =>
      CampingSectionDto(
        name: section.name,
        basePrice: section.basePrice.toString(),
        pricePerAdult: section.pricePerAdult.toString(),
        pricePerChild: section.pricePerChild.toString(),
      );

  CampingSection toEntity() => CampingSection(
        name: name,
        basePrice: double.tryParse(basePrice) ?? 0,
        pricePerAdult: double.tryParse(pricePerAdult) ?? 0,
        pricePerChild: double.tryParse(pricePerChild) ?? 0,
      );
}
