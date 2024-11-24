import 'package:campngo/features/register/domain/entities/profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable()
class ProfileDTO {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'phone_number', includeIfNull: false)
  final String? phoneNumber;
  @JsonKey(includeIfNull: false)
  final String? avatar;
  @JsonKey(name: 'id_card', includeIfNull: false)
  final String? idCard;

  ProfileDTO({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    this.idCard,
  });

  factory ProfileDTO.fromJson(Map<String, dynamic> json) =>
      _$ProfileDTOFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDTOToJson(this);

  ProfileEntity toEntity() => ProfileEntity(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        avatar: avatar,
        idCard: idCard,
      );

  factory ProfileDTO.fromEntity(ProfileEntity entity) => ProfileDTO(
        firstName: entity.firstName,
        lastName: entity.lastName,
        phoneNumber: entity.phoneNumber,
        avatar: entity.avatar,
        idCard: entity.idCard,
      );
}
