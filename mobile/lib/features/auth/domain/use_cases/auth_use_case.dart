import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/use_case/use_case.dart';
import 'package:campngo/features/auth/domain/entities/auth_credentials.dart';
import 'package:campngo/features/auth/domain/entities/auth_entity.dart';
import 'package:campngo/features/auth/domain/repository/auth_repository.dart';

class AuthUseCase implements UseCase<AuthEntity, AuthCredentials> {
  final AuthRepository _authRepository;

  AuthUseCase(this._authRepository);

  @override
  Future<Result<AuthEntity, Exception>> call({
    required AuthCredentials params,
  }) async {
    return await _authRepository.login(params: params);
  }
}
