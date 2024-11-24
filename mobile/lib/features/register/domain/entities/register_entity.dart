import 'package:campngo/features/register/domain/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final String email;
  final String password;
  final ProfileEntity profile;

  const RegisterEntity({
    required this.email,
    required this.password,
    required this.profile,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        email,
        profile,
      ];
}
