// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modified_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifiedAccountDto _$ModifiedAccountDtoFromJson(Map<String, dynamic> json) =>
    ModifiedAccountDto(
      oldPassword: json['oldPassword'] as String?,
      newPassword: json['newPassword'] as String?,
      profile: json['profile'] == null
          ? null
          : AccountProfileDto.fromJson(json['profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ModifiedAccountDtoToJson(ModifiedAccountDto instance) =>
    <String, dynamic>{
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
      'profile': instance.profile,
    };
