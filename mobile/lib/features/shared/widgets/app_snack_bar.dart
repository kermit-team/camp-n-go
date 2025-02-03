import 'package:flutter/material.dart';

class AppSnackBar {
  static showSnackBar({
    required BuildContext context,
    required String text,
    Color? color,
  }) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              maxLines: 3,
            ),
            backgroundColor: color ??
                Theme.of(context).colorScheme.tertiary.withOpacity(0.9),
          ),
        );
      },
    );
  }

  static showErrorSnackBar({
    required BuildContext context,
    required String text,
    Color? color,
  }) {
    showSnackBar(
      context: context,
      text: text,
      color: color ?? Theme.of(context).colorScheme.error.withOpacity(0.9),
    );
  }
}
