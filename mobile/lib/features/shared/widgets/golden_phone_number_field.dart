import 'package:campngo/config/constants.dart';
import 'package:campngo/config/theme/app_theme.dart';
import 'package:campngo/core/validation/validations.dart';
import 'package:campngo/core/validation/validator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class GoldenPhoneNumberField extends StatefulWidget {
  final String? hintText;
  final List<Validation<PhoneNumber>>? validations;
  final bool enabled;
  final bool autofocus;
  final String? label;
  final String? initialValue;

  const GoldenPhoneNumberField({
    super.key,
    this.hintText,
    this.validations,
    this.enabled = true,
    this.autofocus = false,
    this.label,
    this.initialValue,
  });

  @override
  State<GoldenPhoneNumberField> createState() => GoldenPhoneNumberFieldState();
}

class GoldenPhoneNumberFieldState extends State<GoldenPhoneNumberField> {
  PhoneNumber? _phoneNumber;
  String? _initialCountryCode;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.trim().isNotEmpty) {
      _phoneNumber = PhoneNumber.fromCompleteNumber(
        completeNumber: widget.initialValue!,
      );
      _initialCountryCode = _phoneNumber?.countryISOCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      cursorColor: goldenColor,
      style: AppTextStyles.mainTextStyle()
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      dropdownTextStyle: AppTextStyles.mainTextStyle()
          .copyWith(color: Theme.of(context).colorScheme.onSurface),
      showDropdownIcon: false,
      textAlign: TextAlign.left,
      textAlignVertical: TextAlignVertical.center,
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
      onChanged: (phone) {
        setState(() {
          _phoneNumber = phone;
        });
      },
      initialCountryCode: _initialCountryCode ?? 'PL',
    );
  }

  PhoneNumber? get phoneNumber => _phoneNumber;
}
