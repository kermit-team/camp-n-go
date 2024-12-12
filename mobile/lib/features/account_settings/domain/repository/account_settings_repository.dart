import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';

abstract class AccountSettingsRepository {
  Future<Result<Account, Exception>> getAccountData({
    required String identifier,
  });

  Future<Result<dynamic, Exception>> updateAccountProperty({
    required AccountProperty property,
    required String newValue,
  });
}
