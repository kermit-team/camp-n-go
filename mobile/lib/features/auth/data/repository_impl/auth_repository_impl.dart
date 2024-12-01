import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:campngo/features/auth/domain/entities/auth_credentials.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<Result<AuthEntity, Exception>> login({
    required AuthCredentials params,
  }) async {
    if (params.email.trim().isEmpty || params.password.trim().isEmpty) {
      return Failure(Exception(LocaleKeys.credentialsNotEntered.tr()));
    }
    try {
      final httpResponse = await _authApiService.login(
        credentials: {
          "email": params.email,
          "password": params.password,
        },
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final AuthEntity authEntity = httpResponse.data.toEntity();
        return Success(authEntity);
      }

      Map<String, dynamic> responseData =
          jsonDecode(httpResponse.response.data);
      responseData.forEach((key, value) {
        log('Response ---> $key: $value');
      });

      final errorResponse = json.decode(httpResponse.response.data["detail"]);
      log('${LocaleKeys.loginError.tr()}: ${errorResponse["detail"]}');
      return Failure(Exception(errorResponse['detail']));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  @override
  Future<Result<AuthEntity, Exception>> initialLogin({
    required AuthCredentials params,
  }) async {
    try {
      final httpResponse = await _authApiService.login(
        credentials: {
          "email": params.email,
          "password": params.password,
        },
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final AuthEntity authEntity = httpResponse.data.toEntity();
        return Success(authEntity);
      }
      final errorResponse = handleError(httpResponse.response);
      log('${LocaleKeys.loginError.tr()}: $errorResponse');
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
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
}
