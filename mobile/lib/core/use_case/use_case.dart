import 'package:campngo/core/resources/data_result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Type, Exception>> call({required Params params});
}
