part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final Exception? exception;

  const AuthState({
    this.status = AuthStatus.initial,
    this.exception,
  });

  AuthState copyWith({
    AuthStatus? status,
    Exception? exception,
  }) =>
      AuthState(
        status: status ?? this.status,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        exception,
      ];
}
