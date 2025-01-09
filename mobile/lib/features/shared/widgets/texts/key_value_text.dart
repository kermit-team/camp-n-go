import 'package:campngo/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class KeyValueText extends StatelessWidget {
  final String keyText;
  final String valueText;
  final Color? color;
  final TextAlign? textAlign;

  const KeyValueText({
    super.key,
    required this.keyText,
    required this.valueText,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$keyText: ',
            style: AppTextStyles.customTextStyle(),
          ),
          TextSpan(
            text: valueText,
            style: AppTextStyles.customTextStyle(isBold: true),
          ),
        ],
      ),
    );
  }
}
