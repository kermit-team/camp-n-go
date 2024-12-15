import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/data/data_sources/account_settings_api_service.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
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

    // final account = await const Account(
    //   email: "kamil.gajczak@gmail.com",
    //   profile: AccountProfile(
    //     firstName: "Kamil",
    //     lastName: "Gajczak",
    //     phoneNumber: "123456789",
    //     avatar: "avatar",
    //     idCard: "id_card",
    //   ),
    // );
    // return Success(account);
  }

  @override
  Future<Result<dynamic, Exception>> updateAccountProperty({
    required AccountProperty property,
    required String newValue,
  }) async {
    final failure = await Failure(Exception(newValue));
    return failure;
  }

  @override
  Future<Result<Car, Exception>> addCar({
    required String registrationPlate,
  }) async {
    try {
      final httpResponse = await _accountSettingsApiService.addCar(
        registrationPlate: registrationPlate,
        // registrationPlate: {"registration_plate": registrationPlate},
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
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
  Future<Result<Car, Exception>> deleteCar({
    required String registrationPlate,
  }) async {
    try {
      final httpResponse = await _accountSettingsApiService.deleteCar(
        registrationPlate: registrationPlate,
      );

      // if (httpResponse.response.statusCode == HttpStatus.204 ||
      if (httpResponse.response.statusCode == 204) {
        final Car car = httpResponse.data.toEntity();
        return Success(car);
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
