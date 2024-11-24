import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:campngo/features/auth/presentation/widgets/golden_text_field.dart';
import 'package:campngo/features/auth/presentation/widgets/icon_app_bar.dart';
import 'package:campngo/features/auth/presentation/widgets/standard_text.dart';
import 'package:campngo/features/auth/presentation/widgets/title_text.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_bloc.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_event.dart';
import 'package:campngo/features/register/presentation/bloc/forgot_password_state.dart';
import 'package:campngo/features/shared/widgets/app_body.dart';
import 'package:campngo/features/shared/widgets/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      showBackIcon: true,
      children: [
        const SizedBox(height: Constants.spaceL),
        const IconAppBar(),
        const TitleText("Zapomniałeś hasła?"),
        const SizedBox(height: Constants.spaceS),
        const StandardText("Wyślemy Ci instrukcję hasła"),
        const SizedBox(height: Constants.spaceL),
        Form(
          child: Column(
            children: [
              GoldenTextField(
                controller: emailController,
                hintText: "Email",
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
          AppSnackBar.showSnackBar(
            context: context,
            text: forgotPasswordState.exception!.toString(),
          );
        } else if (forgotPasswordState is ForgotPasswordSuccess) {
          AppSnackBar.showSnackBar(
            context: context,
            text: "Wysłano maila do resetu hasła",
          );
        }
      },
      builder: (forgotPasswordContext, forgotPasswordState) {
        if (forgotPasswordState is ForgotPasswordLoading) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
        return CustomButton(
          text: "Zresetuj hasło",
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
}
