import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StandardText extends StatelessWidget {
  final String text;
  final Color? color;

  const StandardText(this.text, {this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: mainTextStyle(color: color),
      textAlign: TextAlign.center,
    );
  }
}
