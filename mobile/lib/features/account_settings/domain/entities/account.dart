import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:equatable/equatable.dart';

enum AccountProperty {
  firstName,
  lastName,
  email,
  phoneNumber,
  idNumber,
  password,
}

class Account extends Equatable {
  final String email;
  final AccountProfile profile;

  const Account({
    required this.email,
    required this.profile,
  });

  copyWith({
    String? email,
    AccountProfile? profile,
  }) =>
      Account(
        email: email ?? this.email,
        profile: profile ?? this.profile,
      );

  @override
  List<Object?> get props => [
        email,
        profile,
      ];
}
