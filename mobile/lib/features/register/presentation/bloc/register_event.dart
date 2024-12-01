abstract class RegisterEvent {}

class Register extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;

  Register({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
