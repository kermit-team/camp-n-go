import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDto {
  @JsonKey(name: 'access')
  final String accessToken;
  @JsonKey(name: 'refresh')
  final String refreshToken;

  AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseDtoToJson(this);

  AuthEntity toEntity() => AuthEntity(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}
