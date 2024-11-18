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
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Column(
          children: [
            const Text('Witaj ponownie!'),
            const Text("Zaloguj się za pomocą Google lub wpisz dane poniżej"),
            TextField(
              controller: emailController,
            ),
            TextField(
              controller: passwordController,
            ),
          ],
        ),
      ),
    );
  }
}
