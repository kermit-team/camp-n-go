import 'package:equatable/equatable.dart';

enum AccountProperty {
  firstName,
  lastName,
  email,
  phoneNumber,
  idNumber,
  password,
}

class AccountEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String idNumber;
  final String password;

  const AccountEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.idNumber,
    required this.password,
  });

  copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? idNumber,
    String? password,
  }) =>
      AccountEntity(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        idNumber: idNumber ?? this.idNumber,
        password: password ?? this.password,
      );

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phoneNumber,
        idNumber,
        password,
      ];
}
