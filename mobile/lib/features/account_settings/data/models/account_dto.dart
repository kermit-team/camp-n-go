import 'package:campngo/features/account_settings/data/models/account_profile_dto.dart';
import 'package:campngo/features/account_settings/data/models/car_dto.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_dto.g.dart';

@JsonSerializable()
class AccountDto {
  final String email;
  final AccountProfileDto profile;
  @JsonKey(name: "cars")
  final List<CarDto> carList;

  AccountDto({
    required this.email,
    required this.profile,
    required this.carList,
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDtoToJson(this);

  factory AccountDto.fromEntity(Account account, List<Car>? carList) =>
      AccountDto(
        email: account.email,
        profile: AccountProfileDto.fromEntity(account.profile),
        carList: carList?.map((car) => CarDto.fromEntity(car)).toList() ?? [],
      );

  Account toEntity() => Account(
      email: email,
      profile: profile.toEntity(),
      carList: carList.map((carDto) => carDto.toEntity()).toList());
}
