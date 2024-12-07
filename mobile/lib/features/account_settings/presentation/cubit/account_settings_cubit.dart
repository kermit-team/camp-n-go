import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account_entity.dart';
import 'package:campngo/features/account_settings/domain/entities/car_entity.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final AccountSettingsRepository accountSettingsRepository;
  final FlutterSecureStorage storage;

  AccountSettingsCubit({
    required this.accountSettingsRepository,
    required this.storage,
  }) : super(const AccountSettingsState(
          status: LoadAccountSettingsStatus.initial,
        ));

  getAccountData() async {
    emit(const AccountSettingsState(status: LoadAccountSettingsStatus.loading));

    try {
      final Result<AccountEntity, Exception> result =
          await accountSettingsRepository.getAccountData();

      switch (result) {
        case Success<AccountEntity, Exception>(
            value: AccountEntity accountEntity,
          ):
          {
            emit(state.copyWith(
              status: LoadAccountSettingsStatus.success,
              accountEntity: accountEntity,
            ));
            break;
          }
        case Failure<AccountEntity, Exception>(exception: final exception):
          {
            emit(state.copyWith(
              status: LoadAccountSettingsStatus.failure,
              exception: exception,
            ));
          }
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        status: LoadAccountSettingsStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        status: LoadAccountSettingsStatus.failure,
        exception: exception,
      ));
    }
  }

  getCarList() {
    emit(state.copyWith(
      carListStatus: CarListStatus.loading,
    ));
    //TODO: implement getting car list from API
    emit(state.copyWith(
      carListStatus: CarListStatus.success,
      carList: [
        const CarEntity(identifier: "1", registrationPlate: "SPS93049"),
        const CarEntity(identifier: "2", registrationPlate: "SPS59986"),
        const CarEntity(identifier: "3", registrationPlate: "ABC"),
      ],
    ));
  }

  addCar({required CarEntity car}) {
    emit(state.copyWith(
      carOperationStatus: CarOperationStatus.loading,
    ));

    emit(state.copyWith(
        exception: Exception("[account_settings_cubit] Not implemented yet"),
        carOperationStatus: CarOperationStatus.notAdded));
  }

  deleteCar({required CarEntity car}) {
    emit(state.copyWith(
      carOperationStatus: CarOperationStatus.loading,
    ));

    emit(state.copyWith(
      exception: Exception("[account_settings_cubit] Not implemented yet"),
      carOperationStatus: CarOperationStatus.notDeleted,
    ));
  }

  editProperty({
    required AccountProperty property,
    required String newValue,
  }) {
    emit(state.copyWith(
      exception: Exception("[account_settings_cubit] Not implemented yet"),
      editPropertyStatus: EditPropertyStatus.failure,
    ));
  }

  setLoading() {
    emit(const AccountSettingsState(status: LoadAccountSettingsStatus.loading));
  }

  setSuccess() {
    emit(const AccountSettingsState(status: LoadAccountSettingsStatus.success));
  }

  serFailure(Exception exception) {
    emit(AccountSettingsState(
      status: LoadAccountSettingsStatus.failure,
      exception: exception,
    ));
  }

  resetState() {
    emit(const AccountSettingsState(status: LoadAccountSettingsStatus.initial));
  }
}
