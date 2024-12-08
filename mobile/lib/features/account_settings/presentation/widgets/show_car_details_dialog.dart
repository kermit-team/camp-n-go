import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showCarDetailsDialog({
  required BuildContext context,
  required String registrationPlate,
  List<Validation<String>>? validations,
  required Function() onDelete,
}) async {
  final TextEditingController controller = TextEditingController(
    text: registrationPlate,
  );
  final formKey = GlobalKey<FormState>();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(LocaleKeys.carDetails.tr()),
        content: Form(
          key: formKey,
          child: GoldenTextField(
            controller: controller,
            validations: validations ?? [],
            enabled: false,
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
                onDelete();
                Navigator.of(context).pop();
              }
            },
            child: Text(LocaleKeys.delete.tr()),
          ),
        ],
      );
    },
  );
}
