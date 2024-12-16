import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/account_profile.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';

abstract class AccountSettingsRepository {
  Future<Result<Account, Exception>> getAccountData({
    required String identifier,
  });

  Future<Result<AccountProfile, Exception>> updateAccountProperty({
    required String identifier,
    required AccountProperty property,
    required String newValue,
  });

  Future<Result<AccountProfile, Exception>> updateAccountPassword({
    required String identifier,
    required String oldPassword,
    required String newPassword,
  });

  //TODO: check if tha car entity is given from backend
  Future<Result<Car, Exception>> addCar({
    required String registrationPlate,
  });

  Future<Result<Car, Exception>> deleteCar({
    required String registrationPlate,
  });
}
