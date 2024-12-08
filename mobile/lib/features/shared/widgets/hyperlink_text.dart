import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HyperlinkText extends StatelessWidget {
  final String text;
  final bool isUnderlined;
  final TextAlign? textAlign;
  final VoidCallback onTap;

  const HyperlinkText({
    super.key,
    required this.text,
    this.isUnderlined = false,
    this.textAlign,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: goldenColor,
          fontSize: Constants.textSizeS,
          decoration:
              isUnderlined ? TextDecoration.underline : TextDecoration.none,
          decorationColor: goldenColor,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
