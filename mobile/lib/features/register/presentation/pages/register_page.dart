import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:campngo/features/auth/presentation/widgets/golden_text_field.dart';
import 'package:campngo/features/auth/presentation/widgets/hyperlink_text.dart';
import 'package:campngo/features/auth/presentation/widgets/icon_app_bar.dart';
import 'package:campngo/features/auth/presentation/widgets/standard_text.dart';
import 'package:campngo/features/auth/presentation/widgets/title_text.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/register_event.dart';
import 'package:campngo/features/register/presentation/bloc/register_state.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBody(
      children: [
        const IconAppBar(),
        TitleText(LocaleKeys.createAccount.tr()),
        const SizedBox(height: Constants.spaceS),
        StandardText(LocaleKeys.toPlanYourVacation.tr()),
        const SizedBox(height: Constants.spaceL),
        Form(
          key: _formKey,
          child: Column(
            children: [
              GoldenTextField(
                controller: firstNameController,
                hintText: LocaleKeys.firstName.tr(),
                validations: const [
                  RequiredValidation(),
                ],
              ),
              const SizedBox(height: Constants.spaceM),
              GoldenTextField(
                controller: lastNameController,
                hintText: LocaleKeys.lastName.tr(),
                validations: const [
                  RequiredValidation(),
                ],
              ),
              const SizedBox(height: Constants.spaceM),
              GoldenTextField(
                controller: emailController,
                hintText: LocaleKeys.email.tr(),
                validations: const [
                  RequiredValidation(),
                  EmailValidation(),
                ],
              ),
              const SizedBox(height: Constants.spaceM),
              GoldenTextField(
                controller: passwordController,
                hintText: LocaleKeys.password.tr(),
                isPassword: true,
                validations: const [
                  RequiredValidation(),
                  PasswordValidation(),
                ],
              ),
              const SizedBox(height: Constants.spaceM),
              GoldenTextField(
                controller: confirmPasswordController,
                hintText: LocaleKeys.repeatPassword.tr(),
                isPassword: true,
                validations: const [
                  RequiredValidation(),
                  PasswordValidation(),
                ],
              ),
              const SizedBox(height: Constants.spaceML),
              _getButtons(
                context,
                _formKey,
                firstNameController,
                lastNameController,
                emailController,
                passwordController,
                confirmPasswordController,
              ),
              const SizedBox(height: Constants.spaceS),
              // CustomButtonInverted(
              //   text: "GOOGLE Zaloguj się przez Google",
              //   onPressed: () {},
              // ),
              // const SizedBox(height: Constants.spaceS),
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StandardText("${LocaleKeys.alreadyHaveAccount.tr()}?"),
                      const SizedBox(width: Constants.spaceXS),
                      HyperlinkText(
                          text: LocaleKeys.login.tr(),
                          onTap: () {
                            serviceLocator<GoRouter>().go("/login");
                          }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: Constants.spaceL,
        ),
      ],
    );
  }

  _getButtons(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController confirmPasswordController,
  ) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          AppSnackBar.showErrorSnackBar(
            context: context,
            text: _getExceptionMessage(state.exception!),
          );
        } else if (state is RegisterSuccess) {
          AppSnackBar.showSnackBar(
            context: context,
            text: LocaleKeys.emailToResetPasswordSent.tr(),
          );
          serviceLocator<GoRouter>().go("/confirmAccount");
        }
      },
      builder: (context, state) {
        return CustomButton(
          text: LocaleKeys.createAccount.tr(),
          onPressed: () {
            if (formKey.currentState?.validate() == true) {
              context.read<RegisterBloc>().add(Register(
                    firstName: emailController.text,
                    lastName: passwordController.text,
                    email: firstNameController.text,
                    password: lastNameController.text,
                    confirmPassword: confirmPasswordController.text,
                  ));
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
