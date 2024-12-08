import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StandardText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool isBold;

  const StandardText(
    this.text, {
    this.color,
    super.key,
    this.textAlign,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.customTextStyle(
        color: color,
        isBold: isBold,
      ),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
