import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;

  const TitleText(this.text, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.titleTextStyle().copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}
