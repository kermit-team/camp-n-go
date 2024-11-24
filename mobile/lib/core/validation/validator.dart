import 'dart:developer';

import 'package:campngo/core/validation/validations.dart';
import 'package:flutter/cupertino.dart';

class Validator {
  Validator._();

  static FormFieldValidator<T> apply<T>({
    required BuildContext context,
    required List<Validation<T>> validations,
  }) {
    return (T? value) {
      for (final validation in validations) {
        final error = validation.validate(context, value);
        if (error != null) {
          log(error);
          return error;
        }
      }
      return null;
    };
  }
}
