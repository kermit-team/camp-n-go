import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Result<AuthEntity, Exception>> login({
    required String email,
    required String password,
  });
}
