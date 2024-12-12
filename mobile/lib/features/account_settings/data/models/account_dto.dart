import 'package:campngo/features/account_settings/data/models/account_profile_dto.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountDto {
  final String email;
  final AccountProfileDto profile;

  AccountDto({
    required this.email,
    required this.profile,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  factory AccountDto.fromEntity(Account account) => AccountDto(
        email: account.email,
        profile: AccountProfileDto.fromEntity(account.profile),
      );

  Account toEntity() => Account(
        email: email,
        profile: profile.toEntity(),
      );
}
