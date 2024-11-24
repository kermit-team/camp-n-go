import 'package:campngo/config/constants.dart';
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
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        const TitleText("Stwórz konto"),
        const SizedBox(height: Constants.spaceS),
        const StandardText("Aby zaplanować swój wypoczynek"),
        const SizedBox(height: Constants.spaceL),
        GoldenTextField(
          controller: firstNameController,
          hintText: "Imię",
        ),
        const SizedBox(height: Constants.spaceM),
        GoldenTextField(
          controller: lastNameController,
          hintText: "Nazwisko",
        ),
        const SizedBox(height: Constants.spaceM),
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
        const SizedBox(height: Constants.spaceM),
        GoldenTextField(
          controller: confirmPasswordController,
          hintText: "Powtórz hasło",
          isPassword: true,
        ),
        const SizedBox(height: Constants.spaceML),
        _getButtons(
          context,
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
                const StandardText("Posiadasz już konto?"),
                const SizedBox(width: Constants.spaceXS),
                HyperlinkText(
                    text: "Zaloguj się",
                    onTap: () {
                      serviceLocator<GoRouter>().go("/login");
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

  _getButtons(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController confirmPasswordController,
  ) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CustomButton(
            text: "Stwórz konto",
            onPressed: () {
              context.read<RegisterBloc>().add(Register(
                    firstName: emailController.text,
                    lastName: passwordController.text,
                    email: firstNameController.text,
                    password: lastNameController.text,
                    confirmPassword: confirmPasswordController.text,
                  ));
            });
      },
    );
  }
}
