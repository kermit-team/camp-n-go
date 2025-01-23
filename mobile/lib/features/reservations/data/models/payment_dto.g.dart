// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDto _$PaymentDtoFromJson(Map<String, dynamic> json) => PaymentDto(
      id: (json['id'] as num).toInt(),
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      price: json['price'] as String,
    );

Map<String, dynamic> _$PaymentDtoToJson(PaymentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'price': instance.price,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 0,
  PaymentStatus.cancelled: 1,
  PaymentStatus.unpaid: 2,
  PaymentStatus.paid: 3,
  PaymentStatus.refunded: 4,
};
