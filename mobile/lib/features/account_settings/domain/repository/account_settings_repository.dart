import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/account_settings/domain/entities/account.dart';
import 'package:campngo/features/account_settings/domain/entities/car.dart';

abstract class AccountSettingsRepository {
  Future<Result<Account, Exception>> getAccountData({
    required String identifier,
  });

  Future<Result<dynamic, Exception>> updateAccountProperty({
    required AccountProperty property,
    required String newValue,
  });

  //TODO: check if tha car entity is given from backend
  Future<Result<Car, Exception>> addCar({
    required String registrationPlate,
  });

  Future<Result<Car, Exception>> deleteCar({
    required String registrationPlate,
  });
}
