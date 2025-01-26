import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/features/shared/widgets/golden_text_field.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<void> showAddCarDialog({
  required BuildContext context,
  required List<Validation<String>>? validations,
  required Function(String registrationPlate) onSubmit,
}) {
  final TextEditingController controller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.addCar.tr()),
          content: Form(
            key: formKey,
            child: GoldenTextField(
              controller: controller,
              validations: validations ?? [],
              hintText: LocaleKeys.registrationPlate.tr(),
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
                  onSubmit(controller.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: Text(LocaleKeys.add.tr()),
            ),
          ],
        );
      });
}
