import 'package:campngo/config/constants.dart';
import 'package:campngo/config/routes/app_routes.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_cubit.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Column(
        children: [
          const IconAppBar(),
          TitleText('${LocaleKeys.welcomeAgain.tr()}!'),
          SizedBox(height: Constants.spaceS),
          StandardText(LocaleKeys.enterCredentialsBelow.tr()),
          SizedBox(height: Constants.spaceL),
          Form(
            key: _formKey,
            child: Column(
              children: [
                GoldenTextField(
                  controller: emailController,
                  hintText: LocaleKeys.email.tr(),
                  validations: const [
                    RequiredValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceM),
                GoldenTextField(
                  controller: passwordController,
                  hintText: LocaleKeys.password.tr(),
                  isPassword: true,
                  validations: const [
                    RequiredValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceML),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: HyperlinkText(
                    text: LocaleKeys.forgotPassword.tr(),
                    isUnderlined: true,
                    onTap: () {
                      context.push("/forgotPassword");
                    },
                  ),
                ),
                SizedBox(height: Constants.spaceM),
                _getButtons(
                  context,
                  emailController,
                  passwordController,
                ),
                SizedBox(height: Constants.spaceS),
                Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StandardText("${LocaleKeys.dontHaveAccount.tr()}?"),
                        SizedBox(width: Constants.spaceXS),
                        HyperlinkText(
                          text: LocaleKeys.registerForFree.tr(),
                          onTap: () {
                            context.go("/register");
                          },
                        ),
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

  Widget _getButtons(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (authContext, authState) {
        if (authState.status == AuthStatus.authenticated) {
          context.go(AppRoutes.home.route);
        }
        if (authState.status == AuthStatus.failure) {
          final errorText = _getExceptionMessage(authState.exception!);
          if (errorText != '') {
            AppSnackBar.showErrorSnackBar(
              context: context,
              text: errorText,
            );
          }
        }
      },
      builder: (authContext, authState) {
        if (authState.status == AuthStatus.loading) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
        return CustomButton(
          text: LocaleKeys.login.tr(),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              context.read<AuthCubit>().login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
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
    if (exceptionWithPrefix == "Exception") {
      return '';
    }
    return exceptionWithPrefix.replaceFirst('Exception: ', '');
  }
}
