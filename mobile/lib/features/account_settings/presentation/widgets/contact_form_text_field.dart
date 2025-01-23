import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/core/validation/validator.dart';
import 'package:flutter/material.dart';

class ContactFormTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final List<Validation<String>>? validations;
  final bool enabled;
  final bool autofocus;
  final int? minLines;
  final int? maxLines;

  const ContactFormTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.validations,
    this.enabled = true,
    this.autofocus = false,
    this.minLines = 3,
    this.maxLines = 10,
  });

  @override
  State<ContactFormTextField> createState() => _ContactFormTextFieldState();
}

class _ContactFormTextFieldState extends State<ContactFormTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      autofocus: widget.autofocus,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      cursorColor: goldenColor,
      style: AppTextStyles.mainTextStyle()
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.hintTextStyle().copyWith(),
        label: widget.label != null
            ? Text(
                widget.label!,
              )
            : null,
        labelStyle: AppTextStyles.hintTextStyle()
            .copyWith(fontSize: Constants.textSizeMS),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorMaxLines: 2,
      ),
      validator: Validator.apply(
        context: context,
        validations: widget.validations ?? [],
      ),
    );
  }
}
