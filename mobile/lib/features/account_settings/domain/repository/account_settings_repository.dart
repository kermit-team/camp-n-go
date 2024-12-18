import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account_entity.dart';

abstract class AccountSettingsRepository {
  Future<Result<AccountEntity, Exception>> getAccountData();

  Future<Result<dynamic, Exception>> updateAccountProperty({
    required AccountProperty property,
    required String newValue,
  });
}
