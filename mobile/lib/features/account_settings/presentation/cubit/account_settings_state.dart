import 'package:equatable/equatable.dart';

enum AccountSettingsStatus { initial, loading, error, success }

class AccountSettingsState extends Equatable {
  final AccountSettingsStatus status;
  final Exception? exception;

  const AccountSettingsState({
    required this.status,
    this.exception,
  });

  AccountSettingsState copyWith({
    required AccountSettingsStatus status,
    Exception? exception,
  }) =>
      AccountSettingsState(
        status: status,
        exception: exception,
      );

  @override
  List<Object?> get props => [
        status,
        exception,
      ];
}
