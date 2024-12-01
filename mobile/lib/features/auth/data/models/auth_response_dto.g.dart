// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseDTO _$AuthResponseDTOFromJson(Map<String, dynamic> json) =>
    AuthResponseDTO(
      accessToken: json['access'] as String,
      refreshToken: json['refresh'] as String,
    );

Map<String, dynamic> _$AuthResponseDTOToJson(AuthResponseDTO instance) =>
    <String, dynamic>{
      'access': instance.accessToken,
      'refresh': instance.refreshToken,
    };
