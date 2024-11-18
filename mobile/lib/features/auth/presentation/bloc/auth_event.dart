abstract class AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({
    required this.email,
    required this.password,
  });
}

class SaveCredentials extends AuthEvent {
  final String email;
  final String password;

  SaveCredentials({
    required this.email,
    required this.password,
  });
}

class LoadCredentials extends AuthEvent {}

class DeleteCredentials extends AuthEvent {}
