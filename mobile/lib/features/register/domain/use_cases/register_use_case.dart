import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/use_case/use_case.dart';
import 'package:campngo/features/register/domain/entities/register_entity.dart';
import 'package:campngo/features/register/domain/repository/register_repository.dart';

class RegisterUseCase implements UseCase<RegisterEntity, RegisterEntity> {
  final RegisterRepository _registerRepository;

  RegisterUseCase(this._registerRepository);

  @override
  Future<Result<RegisterEntity, Exception>> call({
    required RegisterEntity params,
  }) async {
    return await _registerRepository.register(params: params);
  }
}
