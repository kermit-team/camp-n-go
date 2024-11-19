import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/auth/data/data_sources/auth_api_service.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<Result<AuthEntity, Exception>> login({
    required String email,
    required String password,
  }) async {
    try {
      final httpResponse = await _authApiService.login(
        credentials: {
          "email": email,
          "password": password,
        },
      );

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == 200) {
        final AuthEntity authEntity = httpResponse.data.toEntity();
        return Success(authEntity);
      }
      final errorResponse = json.decode(httpResponse.response.data);
      log('Login error: $errorResponse');
      return Failure(Exception(errorResponse['message']));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  Exception handleApiError(DioException dioException) {
    if (dioException.response != null) {
      log('Login error: $dioException');
      return Exception(dioException.error);
    }
    String errorMessage = dioException.error!.toString();
    log('Login error: $errorMessage');
    return Exception(errorMessage);
  }
}
