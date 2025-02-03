import 'package:campngo/features/account_settings/data/models/account_profile_dto.dart';
import 'package:campngo/features/register/domain/entities/register_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_dto.g.dart';

@JsonSerializable()
class RegisterDTO {
  final String email;
  final String? password;
  final AccountProfileDto profile;

  RegisterDTO({
    this.password,
    required this.email,
    required this.profile,
  });

  factory RegisterDTO.fromJson(Map<String, dynamic> json) =>
      _$RegisterDTOFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'email': email,
        'password': password,
        'profile': profile.toJson(),
      };

  RegisterEntity toEntity() => RegisterEntity(
        email: email,
        password: password ?? "",
        profile: profile.toEntity(),
      );

  factory RegisterDTO.fromEntity(RegisterEntity entity) => RegisterDTO(
        email: entity.email,
        password: entity.password,
        profile: AccountProfileDto.fromEntity(entity.profile),
      );
}
