import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/token_storage.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:campngo/features/shared/token_decoder.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part "account_settings_state.dart";

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

  addCar({required Car car}) async {
    try {
      emit(state.copyWith(
        carOperationStatus: CarOperationStatus.loading,
      ));

      final Result<Car, Exception> result =
          await accountSettingsRepository.addCar(car: car);

      switch (result) {
        case Success<Car, Exception>():
          emit(state.copyWith(
            carOperationStatus: CarOperationStatus.added,
          ));
          getAccountData();
        case Failure<Car, Exception>():
          emit(state.copyWith(
            carOperationStatus: CarOperationStatus.notAdded,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        carOperationStatus: CarOperationStatus.notAdded,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        carOperationStatus: CarOperationStatus.notAdded,
        exception: exception,
      ));
    }
  }

  deleteCar({required Car car}) async {
    try {
      emit(state.copyWith(
        carOperationStatus: CarOperationStatus.loading,
      ));

      final Result<void, Exception> result =
          await accountSettingsRepository.deleteCar(car: car);

      switch (result) {
        case Success<void, Exception>():
          emit(state.copyWith(
            carOperationStatus: CarOperationStatus.deleted,
          ));
          getAccountData();
        case Failure<void, Exception>():
          emit(state.copyWith(
            carOperationStatus: CarOperationStatus.notDeleted,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        carOperationStatus: CarOperationStatus.notDeleted,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        carOperationStatus: CarOperationStatus.notDeleted,
        exception: exception,
      ));
    }
  }

  editPassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      emit(state.copyWith(
        editPasswordStatus: EditPasswordStatus.loading,
      ));

      final token = await serviceLocator<TokenStorage>().getAccessToken();
      if (token != null) {
        final userId = TokenDecoder.getUserId(
          token: token,
        );

        final Result<AccountProfile, Exception> result =
            await accountSettingsRepository.updateAccountPassword(
          identifier: userId,
          oldPassword: oldPassword,
          newPassword: newPassword,
        );

        switch (result) {
          case Success<AccountProfile, Exception>(
              value: AccountProfile profileEntity,
            ):
            {
              serviceLocator<FlutterSecureStorage>().write(
                key: 'password',
                value: newPassword,
              );
              emit(state.copyWith(
                editPasswordStatus: EditPasswordStatus.success,
                accountEntity: state.accountEntity?.copyWith(
                  profile: profileEntity,
                ),
              ));
              break;
            }
          case Failure<AccountProfile, Exception>(exception: final exception):
            {
              emit(state.copyWith(
                editPasswordStatus: EditPasswordStatus.failure,
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

  editProperty({
    required AccountProperty property,
    required String newValue,
  }) async {
    try {
      emit(state.copyWith(
        editPropertyStatus: EditPropertyStatus.loading,
      ));

      final token = await serviceLocator<TokenStorage>().getAccessToken();
      if (token != null) {
        final userId = TokenDecoder.getUserId(
          token: token,
        );

        final Result<AccountProfile, Exception> result =
            await accountSettingsRepository.updateAccountProperty(
          identifier: userId,
          property: property,
          newValue: newValue,
        );

        switch (result) {
          case Success<AccountProfile, Exception>(
              value: AccountProfile profileEntity,
            ):
            {
              emit(state.copyWith(
                editPropertyStatus: EditPropertyStatus.success,
                accountEntity: state.accountEntity?.copyWith(
                  profile: profileEntity,
                ),
              ));
              break;
            }
          case Failure<AccountProfile, Exception>(exception: final exception):
            {
              emit(state.copyWith(
                editPropertyStatus: EditPropertyStatus.failure,
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

      emit(state.copyWith(
        exception: Exception("[account_settings_cubit] Not implemented yet"),
        editPropertyStatus: EditPropertyStatus.failure,
      ));
    }
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
