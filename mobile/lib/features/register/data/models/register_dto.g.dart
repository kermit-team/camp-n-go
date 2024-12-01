// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterDTO _$RegisterDTOFromJson(Map<String, dynamic> json) => RegisterDTO(
      password: json['password'] as String?,
      email: json['email'] as String,
      profile: ProfileDTO.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RegisterDTOToJson(RegisterDTO instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'profile': instance.profile,
    };
