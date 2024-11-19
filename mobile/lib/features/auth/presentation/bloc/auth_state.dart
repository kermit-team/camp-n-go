import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final AuthEntity? authEntity;
  final String? email;
  final String? password;
  final Exception? exception;

  const AuthState({this.authEntity, this.email, this.password, this.exception});

  @override
  List<Object?> get props => [authEntity, email, password, exception];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  const AuthSuccess(AuthEntity authEntity) : super(authEntity: authEntity);
}

class AuthFailure extends AuthState {
  const AuthFailure(Exception exception) : super(exception: exception);
}

class AuthEmailEmpty extends AuthState {
  const AuthEmailEmpty();
}

class AuthPasswordEmpty extends AuthState {
  const AuthPasswordEmpty();
}

class AuthCredentialsLoaded extends AuthState {
  const AuthCredentialsLoaded({
    required String email,
    required String password,
  }) : super(email: email, password: password);
}
