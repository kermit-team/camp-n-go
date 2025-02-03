import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String password;
  final AccountProfile profile;

  const RegisterEntity({
    required this.email,
    required this.password,
    required this.profile,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        profile,
      ];
}
