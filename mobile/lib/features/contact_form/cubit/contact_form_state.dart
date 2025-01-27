part of 'contact_form_cubit.dart';

class ContactFormState extends Equatable {
  final SubmissionStatus sendStatus;
  final Exception? exception;

  const ContactFormState({
    this.sendStatus = SubmissionStatus.initial,
    this.exception,
  });

  ContactFormState copyWith({
    SubmissionStatus? sendStatus,
    Exception? exception,
  }) =>
      ContactFormState(
        sendStatus: sendStatus ?? this.sendStatus,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        sendStatus,
        exception,
      ];
}
