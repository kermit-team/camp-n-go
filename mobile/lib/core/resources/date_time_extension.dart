import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String toDateString() {
    final formatter =
        DateFormat('yyyy-MM-dd'); // You can change the format here
    return formatter.format(this);
  }
}
