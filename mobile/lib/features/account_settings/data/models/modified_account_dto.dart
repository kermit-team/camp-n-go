import 'package:campngo/features/account_settings/data/models/account_profile_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'modified_account_dto.g.dart';

@JsonSerializable()
class ModifiedAccountDto {
  final String? oldPassword;
  final String? newPassword;
  final AccountProfileDto? profile;

  ModifiedAccountDto({
    this.oldPassword,
    this.newPassword,
    this.profile,
  });

  factory ModifiedAccountDto.fromJson(Map<String, dynamic> json) =>
      _$ModifiedAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ModifiedAccountDtoToJson(this);
}
