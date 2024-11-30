import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: titleTextStyle(),
      textAlign: TextAlign.center,
    );
  }
}
