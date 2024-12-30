import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

extension DateTimeExtension on DateTime {
  String toDateString() {
    final formatter =
        DateFormat('yyyy-MM-dd'); // You can change the format here
    return formatter.format(this);
  }

  String toDisplayString(BuildContext context) {
    final locale = context.locale;
    final formatter = DateFormat('dd MMM yyyy', locale.toString());
    return formatter.format(this);
  }
}
