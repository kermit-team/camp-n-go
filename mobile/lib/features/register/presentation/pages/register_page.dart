import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/register/presentation/bloc/register_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/register_event.dart';
import 'package:campngo/features/register/presentation/bloc/register_state.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/features/shared/widgets/custom_buttons.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/features/shared/widgets/icon_app_bar.dart';
import 'package:campngo/features/shared/widgets/texts/hyperlink_text.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:campngo/features/shared/widgets/texts/title_text.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _termsAgreement = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          const IconAppBar(),
          TitleText(LocaleKeys.createAccount.tr()),
          SizedBox(height: Constants.spaceS),
          StandardText(LocaleKeys.toPlanYourVacation.tr()),
          SizedBox(height: Constants.spaceL),
          Form(
            key: _formKey,
            child: Column(
              children: [
                GoldenTextField(
                  controller: firstNameController,
                  hintText: LocaleKeys.firstName.tr(),
                  validations: const [
                    RequiredValidation(),
                    NameValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceM),
                GoldenTextField(
                  controller: lastNameController,
                  hintText: LocaleKeys.lastName.tr(),
                  validations: const [
                    RequiredValidation(),
                    NameValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceM),
                GoldenTextField(
                  controller: emailController,
                  hintText: LocaleKeys.email.tr(),
                  validations: const [
                    RequiredValidation(),
                    EmailValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceM),
                GoldenTextField(
                  controller: passwordController,
                  hintText: LocaleKeys.password.tr(),
                  isPassword: true,
                  validations: const [
                    RequiredValidation(),
                    PasswordValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceM),
                GoldenTextField(
                  controller: confirmPasswordController,
                  hintText: LocaleKeys.repeatPassword.tr(),
                  isPassword: true,
                  validations: const [
                    RequiredValidation(),
                    PasswordValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceXS),
                ValueListenableBuilder<bool>(
                  valueListenable: _termsAgreement,
                  builder: (context, value, child) {
                    return FormField<bool>(
                      validator: (value) {
                        if (value != true) {
                          return LocaleKeys.checkboxMustBeChecked.tr();
                        }
                        return null; // Validation passed
                      },
                      builder: (formFieldState) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            errorText: formFieldState
                                .errorText, // Display error message like TextFormField
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: value,
                                onChanged: (changedValue) {
                                  formFieldState.didChange(changedValue);
                                  _termsAgreement.value = changedValue ?? false;
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              StandardText(
                                '${LocaleKeys.accept.tr()} ',
                              ),
                              HyperlinkText(
                                text: LocaleKeys.termsAndConditions.tr(),
                                onTap: () {
                                  openInAppBrowser(
                                    Uri.parse(
                                      Constants.termsAndConditionsUrl,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                _getButtons(
                  context,
                  _formKey,
                  firstNameController,
                  lastNameController,
                  emailController,
                  passwordController,
                  confirmPasswordController,
                ),
                SizedBox(height: Constants.spaceS),
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StandardText("${LocaleKeys.alreadyHaveAccount.tr()}?"),
                        SizedBox(width: Constants.spaceXS),
                        HyperlinkText(
                            text: LocaleKeys.login.tr(),
                            onTap: () {
                              context.go("/login");
                            }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Constants.spaceL,
          ),
        ],
      ),
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
          context.go("/confirmAccount");
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

  Future<void> openInAppBrowser(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      throw Exception('Could not launch $uri');
    }
  }
}
