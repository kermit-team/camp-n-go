import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StandardText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool isBold;
  final bool isUnderlined;
  final TextStyle? style;

  const StandardText(
    this.text, {
    this.color,
    super.key,
    this.textAlign,
    this.isBold = false,
    this.isUnderlined = false,
    this.style,
  });

  factory StandardText.bigger(
    String text, {
    Color? color,
    TextAlign? textAlign,
    bool isBold = false,
    bool isUnderlined = false,
  }) =>
      StandardText(
        text,
        color: color,
        textAlign: textAlign,
        isBold: isBold,
        isUnderlined: isUnderlined,
        style: AppTextStyles.customTextStyle(
          color: color,
          isBold: isBold,
          fontSize: Constants.textSizeMS,
          isUnderlined: isUnderlined,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          AppTextStyles.customTextStyle(
            color: color,
            isBold: isBold,
            isUnderlined: isUnderlined,
          ),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
