import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';

class IconAppBar extends StatelessWidget {
  const IconAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Constants.spaceM,
      ),
      child: Image.asset(
        'assets/images/logo.png',
        height: 150,
        width: double.maxFinite,
      ),
    );
  }
}
