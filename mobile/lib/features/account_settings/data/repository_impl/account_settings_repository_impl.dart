import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/data/data_sources/account_settings_api_service.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:dio/dio.dart';

class AccountSettingsRepositoryImpl implements AccountSettingsRepository {
  final AccountSettingsApiService _accountSettingsApiService;

  AccountSettingsRepositoryImpl(this._accountSettingsApiService);

  @override
  Future<Result<Account, Exception>> getAccountData({
    required String identifier,
  }) async {
    try {
      final httpResponse =
          await _accountSettingsApiService.getAccountDetails(identifier);

      if (httpResponse.response.statusCode == 200) {
        final Account account = httpResponse.data.toEntity();
        return Success(account);
      }

      final errorResponse = json.decode(httpResponse.response.data);
      log("Get account data error: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    } on Exception catch (exception) {
      return Failure(exception);
    }
  }

  @override
  Future<Result<AccountProfile, Exception>> updateAccountProperty({
    required String identifier,
    required AccountProperty property,
    required String newValue,
  }) async {
    try {
      Map<String, dynamic> accountJson = {
        "profile": {
          if (property == AccountProperty.firstName) "first_name": newValue,
          if (property == AccountProperty.lastName) "last_name": newValue,
          if (property == AccountProperty.phoneNumber) "phone_number": newValue,
          if (property == AccountProperty.avatar) "avatar": newValue,
          if (property == AccountProperty.idCard) "id_card": newValue,
        }
      };

      final httpResponse =
          await _accountSettingsApiService.updateAccountProperty(
        identifier: identifier,
        accountJson: accountJson,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final AccountProfile profile = httpResponse.data.profile!.toEntity();
        return Success(profile);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[AccountSettingsRepositoryImpl>AddCar]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<AccountProfile, Exception>> updateAccountPassword({
    required String identifier,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final httpResponse =
          await _accountSettingsApiService.updateAccountPassword(
        identifier: identifier,
        passwordsJson: {
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final AccountProfile profile = httpResponse.data.profile!.toEntity();
        return Success(profile);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[AccountSettingsRepositoryImpl>AddCar]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<Car, Exception>> addCar({
    required Car car,
  }) async {
    try {
      final registrationPlateJson = {
        "registration_plate": car.registrationPlate
      };
      final httpResponse = await _accountSettingsApiService.addCar(
        registrationPlateJson: registrationPlateJson,
      );

      if (httpResponse.response.statusCode == HttpStatus.created ||
          httpResponse.response.statusCode == 201) {
        final Car car = httpResponse.data.toEntity();
        return Success(car);
      }
      final errorResponse = handleError(httpResponse.response);
      log("[AccountSettingsRepositoryImpl>AddCar]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<void, Exception>> deleteCar({
    required Car car,
  }) async {
    try {
      final httpResponse = await _accountSettingsApiService.deleteCar(
        registrationPlate: car.registrationPlate,
      );

      if (httpResponse.response.statusCode == 204) {
        return const Success(null);
      }

      final errorResponse = handleError(httpResponse.response);
      log("[AccountSettingsRepositoryImpl>DeleteCar]: $errorResponse");
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }
}

Exception handleError(Response response) {
  String errorText = "";
  response.data.forEach((key, value) {
    errorText += "$value";
    log('Key: $key');
    log('Value: $value');
  });

  log('Dio Register error details: ${response.data}');
  return Exception(errorText);
}

Exception handleApiError(DioException dioException) {
  if (dioException.response != null) {
    String errorText = "";
    dioException.response!.data.forEach((key, value) {
      errorText += "$value";
      log('Key: $key');
      log('Value: $value');
    });

    log('Dio Register error details: ${dioException.response!.data}');
    return DioException(
      message: errorText,
      requestOptions: dioException.requestOptions,
    );
  } else if (dioException.message != null) {
    log('Dio Register error details: ${dioException.message}');
    return Exception(dioException.message);
  }

  return Exception(dioException.message);
}
