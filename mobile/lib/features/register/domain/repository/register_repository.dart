import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/register/domain/entities/register_entity.dart';

abstract class RegisterRepository {
  Future<Result<RegisterEntity, Exception>> register({
    required RegisterEntity params,
  });
}
