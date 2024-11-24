import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:campngo/features/auth/domain/entities/auth_credentials.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<Result<AuthEntity, Exception>> login({
    required AuthCredentials params,
  }) async {
    if (params.email.trim().isEmpty || params.password.trim().isEmpty) {
      return Failure(Exception("Credentials not entered"));
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
      final errorResponse = json.decode(httpResponse.response.data["detail"]);
      log('Login error: ${errorResponse["detail"]}');
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
      final errorResponse = json.decode(httpResponse.response.data["detail"]);
      log('Login error: ${errorResponse["detail"]}');
      return Failure(Exception(errorResponse['detail']));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  Exception handleApiError(DioException dioException) {
    if (dioException.response != null) {
      // log('Dio Login error: $dioException');
      log('Dio Login error details: ${dioException.response!.data["detail"]}');
      return Exception(dioException.response!.data["detail"]);
    } else if (dioException.message != null) {
      log('Dio Login error details: ${dioException.message}');
      return Exception(dioException.message);
    }

    return Exception(dioException.toString());
  }
}
