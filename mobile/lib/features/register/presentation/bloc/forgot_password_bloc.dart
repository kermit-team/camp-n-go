import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/features/register/domain/repository/register_repository.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_event.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_state.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RegisterRepository registerRepository;
  final FlutterSecureStorage secureStorage;

  ForgotPasswordBloc({
    required this.registerRepository,
    required this.secureStorage,
  }) : super(const ForgotPasswordInitial()) {
    on<ForgotPassword>((event, emit) => _forgotPassword(event, emit));
  }

  _forgotPassword(
      ForgotPassword event, Emitter<ForgotPasswordState> emit) async {
    emit(const ForgotPasswordLoading());
    try {
      final Result<dynamic, Exception> result =
          await registerRepository.forgotPassword(email: event.email);

      switch (result) {
        case Success<dynamic, Exception>():
          {
            emit(const ForgotPasswordSuccess());
            serviceLocator<GoRouter>().go("/login");
            emit(const ForgotPasswordInitial());
          }
        case Failure<dynamic, Exception>(exception: final exception):
          {
            emit(ForgotPasswordFailure(exception));
          }
      }
    } on DioException catch (dioException) {
      emit(ForgotPasswordFailure(dioException));
    } on Exception catch (exception) {
      emit(ForgotPasswordFailure(exception));
    }
  }
}
