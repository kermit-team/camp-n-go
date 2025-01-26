// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDto _$AccountDtoFromJson(Map<String, dynamic> json) => AccountDto(
      email: json['email'] as String,
      profile:
          AccountProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
      carList: (json['cars'] as List<dynamic>)
          .map((e) => CarDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountDtoToJson(AccountDto instance) =>
    <String, dynamic>{
      'email': instance.email,
      'profile': instance.profile,
      'cars': instance.carList,
    };
