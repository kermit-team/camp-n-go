import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StandardText extends StatelessWidget {
  final String text;

  const StandardText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: subtitleTextStyle(),
      textAlign: TextAlign.start,
    );
  }
}
