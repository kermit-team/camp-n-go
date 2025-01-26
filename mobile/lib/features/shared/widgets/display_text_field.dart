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
  final void Function(String)? onPhoneNumberSavePressed;
  final bool isPassword;
  final bool canBeModified;
  final bool hintFloatingEnable;

  const DisplayTextField({
    super.key,
    required this.label,
    required this.text,
    this.hyperlinkText = 'Edit',
    this.validations,
    this.onDialogSavePressed,
    this.onPasswordDialogSavePressed,
    this.onPhoneNumberSavePressed,
    this.isPassword = false,
    this.canBeModified = true,
    this.hintFloatingEnable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoldenTextField(
          label: label,
          controller: TextEditingController(text: text),
          hintFloatingEnable: hintFloatingEnable,
          enabled: false,
          isPassword: isPassword,
        ),
        SizedBox(height: Constants.spaceS),
        canBeModified
            ? Row(
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
                          hintFloatingEnable: hintFloatingEnable,
                          validations: validations,
                          onSave: (newValue) {
                            onDialogSavePressed?.call(newValue);
                          },
                        );
                      } else if (onPasswordDialogSavePressed != null) {
                        showEditPasswordDialog(
                          context: context,
                          onSave: (oldPassword, newPassword) {
                            onPasswordDialogSavePressed?.call(
                              oldPassword,
                              newPassword,
                            );
                          },
                        );
                      } else if (onPhoneNumberSavePressed != null) {
                        showPhoneNumberDialog(
                          context: context,
                          initialValue: text,
                          label: label,
                          validations: [
                            const RequiredValidation(),
                            const PhoneNumberValidation(),
                          ],
                          onSave: (phoneNumber) {
                            onPhoneNumberSavePressed?.call(phoneNumber ?? '');
                          },
                        );
                      }
                    },
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(width: Constants.spaceS),
                ],
              )
            : HyperlinkText(
                text: '',
                onTap: () {},
              ),
      ],
    );
  }
}
