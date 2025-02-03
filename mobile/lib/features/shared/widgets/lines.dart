import 'package:flutter/material.dart';

abstract class Lines {
  static Container lineGoldNormal = Container(
    height: 2,
    width: double.maxFinite,
    color: const Color(0XFFAE9560),
  );
  static Container lineGoldThin = Container(
    height: 1,
    width: double.maxFinite,
    color: const Color(0XFFAE9560),
  );
  static Container lineGoldBold = Container(
    height: 4,
    width: double.maxFinite,
    color: const Color(0XFFAE9560),
  );
  static Divider goldenDivider = const Divider(
    color: Color(0XFFAE9560),
  );
}
