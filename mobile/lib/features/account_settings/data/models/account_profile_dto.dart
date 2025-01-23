import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_profile_dto.g.dart';

@JsonSerializable()
class AccountProfileDto {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  final String? avatar;
  @JsonKey(name: 'id_card')
  final String? idCard;

  AccountProfileDto({
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    this.idCard,
  });

  /// Metoda do deserializacji z JSON
  factory AccountProfileDto.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileDtoFromJson(json);

  /// Metoda do serializacji do JSON
  Map<String, dynamic> toJson() => _$AccountProfileDtoToJson(this);

  factory AccountProfileDto.fromEntity(AccountProfile profile) =>
      AccountProfileDto(
        firstName: profile.firstName,
        lastName: profile.lastName,
        phoneNumber: profile.phoneNumber,
        avatar: profile.avatar,
        idCard: profile.idCard,
      );

  AccountProfile toEntity() => AccountProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        avatar: avatar,
        idCard: idCard,
      );
}
