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
                color: Theme.of(context).colorScheme.onError,
              ),
              maxLines: 3,
            ),
            backgroundColor: color ?? Theme.of(context).colorScheme.error,
          ),
        );
      },
    );
  }
}
