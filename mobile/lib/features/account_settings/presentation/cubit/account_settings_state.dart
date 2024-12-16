part of 'account_settings_cubit.dart';

enum LoadAccountSettingsStatus { initial, loading, failure, success }

enum EditPropertyStatus { unknown, loading, failure, success }

enum EditPasswordStatus { unknown, loading, failure, success }

enum CarListStatus { unknown, loading, failure, success }

enum CarOperationStatus {
  unknown,
  loading,
  notDeleted,
  deleted,
  notAdded,
  added
}

class AccountSettingsState extends Equatable {
  final LoadAccountSettingsStatus status;
  final EditPropertyStatus editPropertyStatus;
  final EditPasswordStatus editPasswordStatus;
  final CarListStatus carListStatus;
  final CarOperationStatus carOperationStatus;

  final Account? accountEntity;
  final List<Car>? carList;
  final Exception? exception;

  const AccountSettingsState({
    required this.status,
    this.editPropertyStatus = EditPropertyStatus.unknown,
    this.editPasswordStatus = EditPasswordStatus.unknown,
    this.carListStatus = CarListStatus.unknown,
    this.carOperationStatus = CarOperationStatus.unknown,
    this.accountEntity,
    this.carList,
    this.exception,
  });

  AccountSettingsState copyWith({
    LoadAccountSettingsStatus? status,
    EditPropertyStatus? editPropertyStatus,
    EditPasswordStatus? editPasswordStatus,
    CarListStatus? carListStatus,
    CarOperationStatus? carOperationStatus,
    Account? accountEntity,
    List<Car>? carList,
    Exception? exception,
  }) =>
      AccountSettingsState(
        status: status ?? this.status,
        editPropertyStatus: editPropertyStatus ?? this.editPropertyStatus,
        editPasswordStatus: editPasswordStatus ?? this.editPasswordStatus,
        carListStatus: carListStatus ?? this.carListStatus,
        carOperationStatus: carOperationStatus ?? this.carOperationStatus,
        accountEntity: accountEntity ?? this.accountEntity,
        carList: carList ?? this.carList,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        editPropertyStatus,
        editPasswordStatus,
        carListStatus,
        carOperationStatus,
        accountEntity,
        carList,
        exception,
      ];
}
