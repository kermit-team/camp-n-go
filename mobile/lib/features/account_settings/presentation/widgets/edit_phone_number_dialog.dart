import 'package:campngo/config/constants.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showEditPhoneNumberDialog({
  required BuildContext context,
  required String label,
  String? initialValue,
  List<Validation<String>>? validations,
  required Function(String) onSave,
}) async {
  final TextEditingController controller =
      TextEditingController(text: initialValue);
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${LocaleKeys.edit.tr()} $label'),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: GoldenTextField(
              controller: controller,
              hintText: label,
              autofocus: true,
              validations: validations ?? [],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                onSave(controller.text);
                Navigator.of(context).pop();
              }
            },
            child: Text(LocaleKeys.save.tr()),
          ),
        ],
      );
    },
  );
}

Future<void> showEditPasswordDialog({
  required BuildContext context,
  required Function(String, String) onSave,
}) async {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(LocaleKeys.changePassword.tr()),
        content: SizedBox(
          width: double.maxFinite,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GoldenTextField(
                  controller: oldPasswordController,
                  hintText: LocaleKeys.oldPassword.tr(),
                  isPassword: true,
                  validations: const [
                    RequiredValidation(),
                  ],
                ),
                SizedBox(height: Constants.spaceS),
                GoldenTextField(
                  controller: newPasswordController,
                  hintText: LocaleKeys.newPassword.tr(),
                  isPassword: true,
                  validations: [
                    const RequiredValidation(),
                    const PasswordValidation(),
                    PasswordMatchValidation(confirmNewPasswordController),
                  ],
                ),
                SizedBox(height: Constants.spaceS),
                GoldenTextField(
                  controller: confirmNewPasswordController,
                  hintText: LocaleKeys.repeatNewPassword.tr(),
                  isPassword: true,
                  validations: [
                    const RequiredValidation(),
                    const PasswordValidation(),
                    PasswordMatchValidation(newPasswordController),
                  ],
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(LocaleKeys.cancel.tr()),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                onSave(
                  oldPasswordController.text,
                  newPasswordController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(LocaleKeys.save.tr()),
          ),
        ],
      );
    },
  );
}
