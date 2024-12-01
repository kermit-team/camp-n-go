import 'package:campngo/core/validation/app_regex.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class Validation<T> {
  const Validation();

  String? validate(BuildContext context, T? value);
}

class RequiredValidation<T> extends Validation<T> {
  const RequiredValidation();

  @override
  String? validate(BuildContext context, T? value) {
    if (value == null) {
      return 'This field is required';
    }

    if (value is String && (value as String).isEmpty) {
      return 'This field id required';
    }
    return null;
  }
}

class EmailValidation extends Validation<String> {
  const EmailValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (!AppRegex.emailRegex.hasMatch(value)) {
      return LocaleKeys.invalidEmail.tr();
    }

    return null;
  }
}

class PasswordValidation extends Validation<String> {
  const PasswordValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (!AppRegex.passwordRegex.hasMatch(value)) {
      return LocaleKeys.passwordRules.tr();
    }

    return null;
  }
}
