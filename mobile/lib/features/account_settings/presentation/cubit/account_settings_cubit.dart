import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/account_settings/presentation/cubit/account_settings_state.dart';
import 'package:campngo/features/shared/token_decoder.dart';
import 'package:campngo/injection_container.dart';
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
      final token = await serviceLocator<TokenStorage>().getAccessToken();

      if (token != null) {
        final userId = TokenDecoder.getUserId(
          token: token,
        );

        final Result<Account, Exception> result =
            await accountSettingsRepository.getAccountData(identifier: userId);

        switch (result) {
          case Success<Account, Exception>(
              value: Account accountEntity,
            ):
            {
              emit(state.copyWith(
                status: LoadAccountSettingsStatus.success,
                accountEntity: accountEntity,
              ));
              break;
            }
          case Failure<Account, Exception>(exception: final exception):
            {
              emit(state.copyWith(
                status: LoadAccountSettingsStatus.failure,
                exception: exception,
              ));
            }
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
        const Car(
          // identifier: "1",
          registrationPlate: "SPS93049",
        ),
        const Car(
          // identifier: "2",
          registrationPlate: "SPS59986",
        ),
        const Car(
          // identifier: "3",
          registrationPlate: "ABC",
        ),
      ],
    ));
  }

  addCar({required Car car}) {
    emit(state.copyWith(
      carOperationStatus: CarOperationStatus.loading,
    ));

    emit(state.copyWith(
        exception: Exception("[account_settings_cubit] Not implemented yet"),
        carOperationStatus: CarOperationStatus.notAdded));
  }

  deleteCar({required Car car}) {
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
