import 'package:campngo/core/validation/app_regex.dart';
import 'package:campngo/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

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

class PasswordMatchValidation extends Validation<String> {
  TextEditingController confirmPasswordController;

  PasswordMatchValidation(this.confirmPasswordController);

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (value != confirmPasswordController.text) {
      return LocaleKeys.passwordsMustBeIdentical.tr();
    }

    return null;
  }
}

class NameValidation extends Validation<String> {
  const NameValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (value.length > 128) {
      return LocaleKeys.inputTooLong.tr();
    }

    return null;
  }
}

class IdCardValidation extends Validation<String> {
  const IdCardValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (value.length > 32) {
      return LocaleKeys.inputTooLong.tr();
    }

    return null;
  }
}

class NumberValidation extends Validation<String> {
  const NumberValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null) return null;

    if (!AppRegex.numberRegex.hasMatch(value)) {
      return LocaleKeys.invalidNumber.tr();
    }

    return null;
  }
}

class PhoneNumberValidation extends Validation<PhoneNumber> {
  const PhoneNumberValidation();

  @override
  String? validate(BuildContext context, PhoneNumber? value) {
    if (value == null) return null;

    if (!AppRegex.numberRegex.hasMatch(value.number)) {
      return LocaleKeys.invalidNumber.tr();
    }

    return null;
  }
}
