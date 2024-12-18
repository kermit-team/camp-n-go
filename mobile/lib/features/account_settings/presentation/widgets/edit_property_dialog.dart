import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showEditPropertyDialog({
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
        content: Form(
          key: formKey,
          child: GoldenTextField(
            controller: controller,
            hintText: label,
            validations: validations ?? [],
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
