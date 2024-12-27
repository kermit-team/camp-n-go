import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:json_annotation/json_annotation.dart';

part "car_dto.g.dart";

@JsonSerializable()
class CarDto {
  @JsonKey(name: 'registration_plate')
  final String registrationPlate;

  CarDto({
    // required this.identifier,
    required this.registrationPlate,
  });

  factory CarDto.fromJson(Map<String, dynamic> json) => _$CarDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CarDtoToJson(this);

  factory CarDto.fromEntity(Car car) => CarDto(
        // identifier: car.identifier,
        registrationPlate: car.registrationPlate,
      );

  Car toEntity() => Car(
        // identifier: identifier,
        registrationPlate: registrationPlate,
      );
}
