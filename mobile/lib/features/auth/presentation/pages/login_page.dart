import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_event.dart';
import 'package:campngo/features/auth/presentation/bloc/auth_state.dart';
import 'package:campngo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:campngo/features/auth/presentation/widgets/golden_text_field.dart';
import 'package:campngo/features/auth/presentation/widgets/hyperlink_text.dart';
import 'package:campngo/features/auth/presentation/widgets/icon_app_bar.dart';
import 'package:campngo/features/auth/presentation/widgets/standard_text.dart';
import 'package:campngo/features/auth/presentation/widgets/title_text.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:campngo/injection_container.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBody(
      children: [
        const SizedBox(height: Constants.spaceL),
        const IconAppBar(),
        TitleText('${LocaleKeys.welcomeAgain.tr()}!'),
        const SizedBox(height: Constants.spaceS),
        StandardText(LocaleKeys.enterCredentialsBelow.tr()),
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
              const SizedBox(height: Constants.spaceML),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: HyperlinkText(
                  text: LocaleKeys.forgotPassword.tr(),
                  isUnderlined: true,
                  onTap: () {
                    serviceLocator<GoRouter>().push("/forgotPassword");
                  },
                ),
              ),
              const SizedBox(height: Constants.spaceM),
              _getButtons(
                context,
                emailController,
                passwordController,
              ),
              const SizedBox(height: Constants.spaceS),
              Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StandardText("${LocaleKeys.dontHaveAccount.tr()}?"),
                      const SizedBox(width: Constants.spaceXS),
                      HyperlinkText(
                        text: LocaleKeys.registerForFree.tr(),
                        onTap: () {
                          serviceLocator<GoRouter>().go("/register");
                        },
                      ),
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

  Widget _getButtons(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (authContext, authState) {
        if (authState is AuthFailure) {
          AppSnackBar.showSnackBar(
            context: context,
            text: authState.exception!.toString(),
          );
        } else if (authState is AuthEmailEmpty) {
          AppSnackBar.showSnackBar(
              context: context, text: "Email nie może być pusty");
        } else if (authState is AuthPasswordEmpty) {
          AppSnackBar.showSnackBar(
              context: context, text: "Hasło nie może być puste");
        }
      },
      builder: (authContext, authState) {
        if (authState is AuthLoading) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
        return CustomButton(
          text: LocaleKeys.login.tr(),
          onPressed: () {
            if (_formKey.currentState?.validate() == true) {
              context.read<AuthBloc>().add(
                    Login(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
            }
          },
        );
      },
    );
  }
}
