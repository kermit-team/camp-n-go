import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:json_annotation/json_annotation.dart';

part "car_dto.g.dart";

@JsonSerializable()
class CarDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'registration_plate')
  final String registrationPlate;

  CarDto({
    required this.id,
    required this.registrationPlate,
  });

  factory CarDto.fromJson(Map<String, dynamic> json) => _$CarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CarDtoToJson(this);

  factory CarDto.fromEntity(Car car) => CarDto(
        id: car.id,
        registrationPlate: car.registrationPlate,
      );

  Car toEntity() => Car(
        id: id,
        registrationPlate: registrationPlate,
      );
}
