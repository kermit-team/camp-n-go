import 'package:campngo/features/auth/presentation/widgets/custom_buttons.dart';
import 'package:campngo/features/auth/presentation/widgets/golden_text_field.dart';
import 'package:campngo/features/auth/presentation/widgets/hyperlink_text.dart';
import 'package:campngo/features/auth/presentation/widgets/icon_app_bar.dart';
import 'package:campngo/features/auth/presentation/widgets/standard_text.dart';
import 'package:campngo/features/auth/presentation/widgets/title_text.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const IconAppBar(),
              const TitleText('Witaj ponownie!'),
              const SizedBox(height: 10),
              const StandardText(
                "Wpisz dane dostępowe poniżej",
              ),
              const SizedBox(height: 40),
              GoldenTextField(
                controller: emailController,
                hintText: "email",
              ),
              const SizedBox(height: 20),
              GoldenTextField(
                controller: passwordController,
                hintText: "hasło",
                isPassword: true,
              ),
              const SizedBox(height: 30),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: HyperlinkText(
                  text: "Zapomniałem hasła",
                  isUnderlined: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Teraz leci info o zapomnieniu hasła do backendu i przejście na stronę z info"),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Zaloguj",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Leci zalogowanie się do aplikacji"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomButtonInverted(
                text: "GOOGLE Zaloguj się przez Google",
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const StandardText("Nie masz konta?"),
                  const SizedBox(width: 5),
                  HyperlinkText(text: "Zarejestruj się za darmo", onTap: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
