import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/account_settings/presentation/widgets/edit_property_dialog.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/features/shared/widgets/texts/hyperlink_text.dart';
import 'package:flutter/material.dart';

class DisplayTextField extends StatelessWidget {
  final String label;
  final String text;
  final String hyperlinkText;
  final List<Validation<String>>? validations;
  final void Function(String)? onDialogSavePressed;
  final void Function(String, String)? onPasswordDialogSavePressed;
  final bool isPassword;

  const DisplayTextField({
    super.key,
    required this.label,
    required this.text,
    this.hyperlinkText = 'Edit',
    this.validations,
    this.onDialogSavePressed,
    this.onPasswordDialogSavePressed,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldenTextField(
          label: label,
          controller: TextEditingController(text: text),
          enabled: false,
          isPassword: isPassword,
        ),
        const SizedBox(height: Constants.spaceS),
        Row(
          children: [
            const Spacer(),
            HyperlinkText(
              text: hyperlinkText,
              onTap: () {
                if (onDialogSavePressed != null) {
                  showEditPropertyDialog(
                    context: context,
                    label: label,
                    initialValue: text,
                    validations: validations,
                    onSave: (newValue) {
                      onDialogSavePressed != null
                          ? onDialogSavePressed!(newValue)
                          : () {};
                    },
                  );
                } else if (onPasswordDialogSavePressed != null) {
                  showEditPasswordDialog(
                    context: context,
                    onSave: (oldPassword, newPassword) {
                      onPasswordDialogSavePressed != null
                          ? onPasswordDialogSavePressed!(
                              oldPassword,
                              newPassword,
                            )
                          : () {};
                    },
                  );
                }
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
