abstract class ForgotPasswordEvent {}

class ForgotPassword extends ForgotPasswordEvent {
  final String email;

  ForgotPassword({
    required this.email,
  });
}
