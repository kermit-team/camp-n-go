part of 'account_settings_cubit.dart';

enum LoadAccountSettingsStatus { initial, loading, failure, success }

enum EditPropertyStatus { unknown, loading, failure, success }

enum EditPasswordStatus { unknown, loading, failure, success }

enum CarOperationStatus {
  unknown,
  loading,
  notDeleted,
  deleted,
  notAdded,
  added,
  alreadyExists
}

class AccountSettingsState extends Equatable {
  final LoadAccountSettingsStatus status;
  final EditPropertyStatus editPropertyStatus;
  final EditPasswordStatus editPasswordStatus;
  final CarOperationStatus carOperationStatus;

  final Account? accountEntity;

  final Exception? exception;

  const AccountSettingsState({
    required this.status,
    this.editPropertyStatus = EditPropertyStatus.unknown,
    this.editPasswordStatus = EditPasswordStatus.unknown,
    this.carOperationStatus = CarOperationStatus.unknown,
    this.accountEntity,
    this.exception,
  });

  AccountSettingsState copyWith({
    LoadAccountSettingsStatus? status,
    EditPropertyStatus? editPropertyStatus,
    EditPasswordStatus? editPasswordStatus,
    CarOperationStatus? carOperationStatus,
    Account? accountEntity,
    List<Car>? carList,
    Exception? exception,
  }) =>
      AccountSettingsState(
        status: status ?? this.status,
        editPropertyStatus: editPropertyStatus ?? this.editPropertyStatus,
        editPasswordStatus: editPasswordStatus ?? this.editPasswordStatus,
        carOperationStatus: carOperationStatus ?? this.carOperationStatus,
        accountEntity: accountEntity ?? this.accountEntity,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        editPropertyStatus,
        editPasswordStatus,
        carOperationStatus,
        accountEntity,
        exception,
      ];
}
