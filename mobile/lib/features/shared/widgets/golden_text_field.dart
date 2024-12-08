import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/core/validation/validator.dart';
import 'package:flutter/material.dart';

class GoldenTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String? hintText;
  final List<Validation<String>>? validations;
  final bool enabled;
  final String? label;

  const GoldenTextField({
    super.key,
    required this.controller,
    this.isPassword = false,
    this.hintText,
    this.validations,
    this.enabled = true,
    this.label,
  });

  @override
  State<GoldenTextField> createState() => _GoldenTextFieldState();
}

class _GoldenTextFieldState extends State<GoldenTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
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
        suffixIcon: widget.isPassword && widget.enabled
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: goldenColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        errorMaxLines: 2,
      ),
      validator: Validator.apply(
        context: context,
        validations: widget.validations ?? [],
      ),
    );
  }
}
