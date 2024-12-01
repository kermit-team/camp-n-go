import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/presentation/widgets/edit_property_dialog.dart';
import 'package:campngo/features/shared/widgets/hyperlink_text.dart';
import 'package:campngo/features/shared/widgets/standard_text.dart';
import 'package:flutter/material.dart';

class DisplayTextField extends StatelessWidget {
  final String label;
  final String text;
  final String hyperlinkText;
  final List<Validation<String>>? validations;
  final void Function(String) onHyperlinkPressed;

  const DisplayTextField({
    super.key,
    required this.label,
    required this.text,
    this.hyperlinkText = 'Edit',
    this.validations,
    required this.onHyperlinkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.hintTextStyle()),
        const SizedBox(height: Constants.spaceS),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          padding: const EdgeInsets.only(bottom: Constants.spaceS),
          child: StandardText(
            text,
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: Constants.spaceS),
        Row(
          children: [
            const Spacer(),
            HyperlinkText(
              text: hyperlinkText,
              onTap: () {
                showEditPropertyDialog(
                  context: context,
                  label: label,
                  validations: validations,
                  onSave: (newValue) {
                    onHyperlinkPressed(newValue);
                  },
                );
              },
              textAlign: TextAlign.end,
            ),
            const SizedBox(width: Constants.spaceS),
          ],
        ),
      ],
    );
  }
}
