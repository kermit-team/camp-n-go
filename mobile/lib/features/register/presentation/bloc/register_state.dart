import 'package:campngo/features/register/domain/entities/register_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  final RegisterEntity? registerEntity;
  final String? email;
  final String? password;
  final String? firstName; // Added firstName
  final String? lastName; // Added lastName
  final String? confirmPassword; // Added confirmPassword
  final Exception? exception;

  const RegisterState({
    this.registerEntity,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.confirmPassword,
    this.exception,
  });

  @override
  List<Object?> get props => [
        registerEntity,
        email,
        password,
        firstName,
        lastName,
        confirmPassword,
        exception,
      ];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess(RegisterEntity registerEntity)
      : super(registerEntity: registerEntity);
}

class RegisterFailure extends RegisterState {
  const RegisterFailure(Exception exception) : super(exception: exception);
}

class RegisterEmailEmpty extends RegisterState {
  const RegisterEmailEmpty();
}

class RegisterPasswordEmpty extends RegisterState {
  const RegisterPasswordEmpty();
}

class RegisterCredentialsLoaded extends RegisterState {
  const RegisterCredentialsLoaded({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String confirmPassword,
  }) : super(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          confirmPassword: confirmPassword,
        );
}

class RegisterFirstNameEmpty extends RegisterState {
  const RegisterFirstNameEmpty();
}

class RegisterLastNameEmpty extends RegisterState {
  const RegisterLastNameEmpty();
}

class RegisterConfirmPasswordEmpty extends RegisterState {
  const RegisterConfirmPasswordEmpty();
}

class RegisterPasswordsNotMatch extends RegisterState {
  const RegisterPasswordsNotMatch();
}
