abstract class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });
}

class InitialLogin extends AuthEvent {}

class SaveCredentials extends AuthEvent {
  final String email;
  final String password;
  final String accessToken;
  final String refreshToken;

  SaveCredentials({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
    required this.password,
  });
}

class LoadCredentials extends AuthEvent {}

class DeleteCredentials extends AuthEvent {}
