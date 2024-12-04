import 'package:campngo/features/account_settings/domain/entities/account_entity.dart';
import 'package:equatable/equatable.dart';

enum LoadAccountSettingsStatus { initial, loading, failure, success }

enum EditPropertyStatus { unknown, loading, failure, success }

class AccountSettingsState extends Equatable {
  final LoadAccountSettingsStatus status;
  final EditPropertyStatus editPropertyStatus;
  final AccountEntity? accountEntity;
  final Exception? exception;

  const AccountSettingsState({
    required this.status,
    this.editPropertyStatus = EditPropertyStatus.unknown,
    this.accountEntity,
    this.exception,
  });

  AccountSettingsState copyWith({
    LoadAccountSettingsStatus? status,
    EditPropertyStatus? editPropertyStatus,
    AccountEntity? accountEntity,
    Exception? exception,
  }) =>
      AccountSettingsState(
        status: status ?? this.status,
        editPropertyStatus: editPropertyStatus ?? this.editPropertyStatus,
        accountEntity: accountEntity ?? this.accountEntity,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        editPropertyStatus,
        accountEntity,
        exception,
      ];
}
