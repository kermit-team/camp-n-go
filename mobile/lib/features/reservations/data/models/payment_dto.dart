import 'package:campngo/features/reservations/domain/entities/payment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'status')
  final PaymentStatus status;
  @JsonKey(name: 'price')
  final String price;

  PaymentDto({
    required this.id,
    required this.status,
    required this.price,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDtoToJson(this);

  factory PaymentDto.fromEntity(Payment entity) => PaymentDto(
        id: entity.id,
        status: entity.status,
        price: entity.price.toString(),
      );

  Payment toEntity() => Payment(
        id: id,
        status: status,
        price: double.tryParse(price) ?? 0,
      );
}
