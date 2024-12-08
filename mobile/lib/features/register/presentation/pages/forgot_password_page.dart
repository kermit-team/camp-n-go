import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_event.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_state.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/features/shared/widgets/icon_app_bar.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          const IconAppBar(),
          TitleText(LocaleKeys.forgotPassword.tr()),
          const SizedBox(height: Constants.spaceS),
          StandardText(LocaleKeys.weWillSendYouEmail.tr()),
          const SizedBox(height: Constants.spaceL),
          Form(
            key: _formKey,
            child: Column(
              children: [
                GoldenTextField(
                  controller: emailController,
                  hintText: LocaleKeys.email.tr(),
                  validations: const [
                    RequiredValidation(),
                    EmailValidation(),
                  ],
                ),
                const SizedBox(height: Constants.spaceML),
                _getButtons(
                  context,
                  _formKey,
                  emailController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getButtons(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
  ) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (forgotPasswordContext, forgotPasswordState) {
        if (forgotPasswordState is ForgotPasswordFailure) {
          AppSnackBar.showErrorSnackBar(
            context: context,
            text: _getExceptionMessage(forgotPasswordState.exception!),
          );
        } else if (forgotPasswordState is ForgotPasswordSuccess) {
          serviceLocator<GoRouter>().replace("/resetPasswordInfo");
        }
      },
      builder: (forgotPasswordContext, forgotPasswordState) {
        if (forgotPasswordState is ForgotPasswordLoading) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
        return CustomButton(
          text: LocaleKeys.resetPassword.tr(),
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              context
                  .read<ForgotPasswordBloc>()
                  .add(ForgotPassword(email: emailController.text.trim()));
            }
          },
        );
      },
    );
  }

  String _getExceptionMessage(Exception exception) {
    if (exception is DioException) {
      return exception.message ?? exception.toString();
    }
    String exceptionWithPrefix = exception.toString();
    return exceptionWithPrefix.replaceFirst('Exception: ', '');
  }
}
