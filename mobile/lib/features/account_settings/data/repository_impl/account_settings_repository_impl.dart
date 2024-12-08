import 'dart:developer';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account_entity.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:dio/dio.dart';

class AccountSettingsRepositoryImpl implements AccountSettingsRepository {
  // final AccountSettingsApiService _accountSettingsApiService;

  // AccountSettingsRepositoryImpl(this._accountSettingsApiService);

  @override
  Future<Result<AccountEntity, Exception>> getAccountData() async {
    // try {
    //   final httpResponse = await _accountSettingsApiService.getAccountData();
    //
    //   if (httpResponse.response.statusCode == 200) {
    //     final AccountEntity accountEntity = httpResponse.data.toEntity();
    //     return Success(accountEntity);
    //   }
    //
    //   final errorResponse = json.decode(httpResponse.response.data);
    //   log("Get account data error: $errorResponse");
    //   return Failure(Exception(errorResponse));
    // } on DioException catch (dioException) {
    //   return Failure(handleApiError(dioException));
    // } on Exception catch (exception) {
    //   return Failure(exception);
    // }

    final accountEntity = await const AccountEntity(
      firstName: "Kamil",
      lastName: "Gajczak",
      email: "kamil.gajczak@gmail.com",
      phoneNumber: "+48606857193",
      idNumber: "12349876501",
      password: "123qwe!@#QWE",
    );
    return Success(accountEntity);
  }

  @override
  Future<Result<dynamic, Exception>> updateAccountProperty({
    required AccountProperty property,
    required String newValue,
  }) async {
    final failure = await Failure(Exception(newValue));
    return failure;
  }
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
