import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  final bool scrollable;

  const AppBody({
    super.key,
    required this.child,
    this.scrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ModalRoute.of(context)!.canPop
          ? IconButton(
              onPressed: context.pop,
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 9.w, // Use 9.w for left padding
              right: 9.w, // Use 9.w for right padding
            ),
            child: SafeArea(
              child: scrollable
                  ? SingleChildScrollView(
                      child: child,
                    )
                  : child,
            ),
          ),
        ],
      ),
    );
  }
}
