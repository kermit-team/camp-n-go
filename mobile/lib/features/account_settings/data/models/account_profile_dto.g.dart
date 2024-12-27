// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountProfileDto _$AccountProfileDtoFromJson(Map<String, dynamic> json) =>
    AccountProfileDto(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phoneNumber: json['phone_number'] as String?,
      avatar: json['avatar'] as String?,
      idCard: json['id_card'] as String?,
    );

Map<String, dynamic> _$AccountProfileDtoToJson(AccountProfileDto instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone_number': instance.phoneNumber,
      'avatar': instance.avatar,
      'id_card': instance.idCard,
    };
