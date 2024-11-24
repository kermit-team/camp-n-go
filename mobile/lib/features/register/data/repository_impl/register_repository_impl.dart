import 'dart:convert';
import 'dart:developer';

import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/register/data/data_sources/register_api_service.dart';
import 'package:campngo/features/register/data/models/register_dto.dart';
import 'package:campngo/features/register/domain/entities/register_entity.dart';
import 'package:campngo/features/register/domain/repository/register_repository.dart';
import 'package:dio/dio.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterApiService _registerApiService;

  RegisterRepositoryImpl(this._registerApiService);

  @override
  Future<Result<RegisterEntity, Exception>> register({
    required RegisterEntity params,
  }) async {
    try {
      final httpResponse = await _registerApiService.register(
        userData: RegisterDTO.fromEntity(params).toJson(),
      );

      if (httpResponse.response.statusCode == 201) {
        final RegisterEntity registerEntity = httpResponse.data.toEntity();
        return Success(registerEntity);
      }

      final errorResponse = json.decode(httpResponse.response.data);
      log('Register error: $errorResponse');
      return Failure(Exception(errorResponse));
    } on DioException catch (dioException) {
      return Failure(handleApiError(dioException));
    }
  }

  Exception handleApiError(DioException dioException) {
    if (dioException.response != null) {
      log('Dio Register error details: ${dioException.response!.data}');
      return Exception(dioException.response!.data);
    } else if (dioException.message != null) {
      log('Dio Register error details: ${dioException.message}');
      return Exception(dioException.message);
    }

    return Exception(dioException.toString());
  }
}
