import 'package:campngo/features/register/data/models/profile_dto.dart';
import 'package:campngo/features/register/domain/entities/register_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDTO {
  final String email;
  final String? password;
  final ProfileDTO profile;

  RegisterDTO({
    this.password,
    required this.email,
    required this.profile,
  });

  factory RegisterDTO.fromJson(Map<String, dynamic> json) => RegisterDTO(
        email: json['email'] as String,
        profile: ProfileDTO.fromJson(
          (json['profile'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e == "" ? null : e),
              ) ??
              {},
        ), // Handle null and empty strings
      );

  Map<String, dynamic> toJson() => _$RegisterDTOToJson(this);

  RegisterEntity toEntity() => RegisterEntity(
        email: email,
        password: password ?? "",
        profile: profile.toEntity(),
      );

  factory RegisterDTO.fromEntity(RegisterEntity entity) => RegisterDTO(
        email: entity.email,
        password: entity.password,
        profile: ProfileDTO.fromEntity(entity.profile),
      );
}
