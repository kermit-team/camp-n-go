import 'package:campngo/core/resources/data_result.dart';
import 'package:campngo/core/resources/submission_status.dart';
import 'package:campngo/features/account_settings/domain/repository/account_settings_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'contact_form_state.dart';

class ContactFormCubit extends Cubit<ContactFormState> {
  final AccountSettingsRepository accountSettingsRepository;

  ContactFormCubit({
    required this.accountSettingsRepository,
  }) : super(const ContactFormState());

  Future<void> sendContactEmail({
    required String email,
    required String content,
  }) async {
    try {
      emit(state.copyWith(sendStatus: SubmissionStatus.loading));

      final Result<void, Exception> result =
          await accountSettingsRepository.sendContactEmail(
        email: email,
        content: content,
      );

      switch (result) {
        case Success<void, Exception>():
          emit(state.copyWith(
            sendStatus: SubmissionStatus.success,
          ));
        case Failure<void, Exception>():
          emit(state.copyWith(
            sendStatus: SubmissionStatus.failure,
            exception: result.exception,
          ));
      }
    } on DioException catch (dioException) {
      emit(state.copyWith(
        sendStatus: SubmissionStatus.failure,
        exception: dioException,
      ));
    } on Exception catch (exception) {
      emit(state.copyWith(
        sendStatus: SubmissionStatus.failure,
        exception: exception,
      ));
    }
  }
}
