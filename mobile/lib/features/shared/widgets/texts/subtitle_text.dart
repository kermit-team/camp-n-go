import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool isUnderlined;

  const SubtitleText(
    this.text, {
    this.color,
    super.key,
    this.textAlign,
    this.isUnderlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.subtitleTextStyle(
        color: color,
        isUnderlined: isUnderlined,
      ),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
