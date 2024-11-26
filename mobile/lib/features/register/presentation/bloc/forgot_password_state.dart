import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  final String? email;
  final Exception? exception;

  const ForgotPasswordState({
    this.email,
    this.exception,
  });

  @override
  List<Object?> get props => [
        email,
        exception,
      ];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess();
}

class ForgotPasswordFailure extends ForgotPasswordState {
  const ForgotPasswordFailure(Exception exception)
      : super(exception: exception);
}
