import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IconAppBar extends StatelessWidget {
  const IconAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: Constants.spaceL,
      ),
      child: Image.asset(
        'assets/images/logo.png',
        color: Theme.of(context).colorScheme.onSurface,
        height: 10.h,
        width: double.maxFinite,
      ),
    );
  }
}
