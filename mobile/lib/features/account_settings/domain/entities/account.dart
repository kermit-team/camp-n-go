import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:equatable/equatable.dart';

enum AccountProperty {
  firstName,
  lastName,
  email,
  phoneNumber,
  idCard,
  avatar,
}

class Account extends Equatable {
  final String email;
  final AccountProfile profile;
  final List<Car> carList;

  const Account({
    required this.email,
    required this.profile,
    required this.carList,
  });

  copyWith({
    String? email,
    AccountProfile? profile,
    List<Car>? carList,
  }) =>
      Account(
        email: email ?? this.email,
        profile: profile ?? this.profile,
        carList: carList ?? this.carList,
      );

  @override
  List<Object?> get props => [
        email,
        profile,
        carList,
      ];
}
