import 'package:campngo/config/constants.dart';
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
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBody(
      children: [
        const IconAppBar(),
        const TitleText('Witaj ponownie!'),
        const SizedBox(height: Constants.spaceS),
        const StandardText(
          "Wpisz dane dostępowe poniżej",
        ),
        const SizedBox(height: Constants.spaceL),
        GoldenTextField(
          controller: emailController,
          hintText: "Email",
        ),
        const SizedBox(height: Constants.spaceM),
        GoldenTextField(
          controller: passwordController,
          hintText: "Hasło",
          isPassword: true,
        ),
        const SizedBox(height: Constants.spaceML),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: HyperlinkText(
            text: "Zapomniałem hasła",
            isUnderlined: true,
            onTap: () {
              context.read<AuthBloc>().add(
                    Login(
                      email: emailController.text,
                      password: passwordController.text,
                    ),
                  );
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
                const StandardText("Nie masz konta?"),
                const SizedBox(width: Constants.spaceXS),
                HyperlinkText(
                    text: "Zarejestruj się za darmo",
                    onTap: () {
                      serviceLocator<GoRouter>().go("/register");
                    }),
              ],
            ),
          ],
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
        }
      },
      builder: (authContext, authState) {
        return CustomButton(
          text: "Zaloguj",
          onPressed: () {
            context.read<AuthBloc>().add(
                  Login(
                    email: emailController.text,
                    password: passwordController.text,
                  ),
                );
          },
        );
      },
    );
  }
}
