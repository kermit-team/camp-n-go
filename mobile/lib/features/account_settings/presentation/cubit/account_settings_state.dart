import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:equatable/equatable.dart';

enum LoadAccountSettingsStatus { initial, loading, failure, success }

enum EditPropertyStatus { unknown, loading, failure, success }

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
  final CarListStatus carListStatus;
  final CarOperationStatus carOperationStatus;

  final Account? accountEntity;
  final List<Car>? carList;
  final Exception? exception;

  const AccountSettingsState({
    required this.status,
    this.editPropertyStatus = EditPropertyStatus.unknown,
    this.carListStatus = CarListStatus.unknown,
    this.carOperationStatus = CarOperationStatus.unknown,
    this.accountEntity,
    this.carList,
    this.exception,
  });

  AccountSettingsState copyWith({
    LoadAccountSettingsStatus? status,
    EditPropertyStatus? editPropertyStatus,
    CarListStatus? carListStatus,
    CarOperationStatus? carOperationStatus,
    Account? accountEntity,
    List<Car>? carList,
    Exception? exception,
  }) =>
      AccountSettingsState(
        status: status ?? this.status,
        editPropertyStatus: editPropertyStatus ?? this.editPropertyStatus,
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
        carListStatus,
        carOperationStatus,
        accountEntity,
        carList,
        exception,
      ];
}
