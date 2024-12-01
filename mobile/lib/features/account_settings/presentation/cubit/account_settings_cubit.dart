import 'package:campngo/features/account_settings/presentation/cubit/account_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountSettingsCubit extends Cubit<AccountSettingsState> {
  final FlutterSecureStorage storage;

  AccountSettingsCubit({
    required this.storage,
  }) : super(const AccountSettingsState(status: AccountSettingsStatus.initial));

  setLoading() {
    emit(const AccountSettingsState(status: AccountSettingsStatus.loading));
  }

  setSuccess() {
    emit(const AccountSettingsState(status: AccountSettingsStatus.success));
  }

  setError(Exception exception) {
    emit(AccountSettingsState(
      status: AccountSettingsStatus.error,
      exception: exception,
    ));
  }

  resetState() {
    emit(const AccountSettingsState(status: AccountSettingsStatus.initial));
  }
}
