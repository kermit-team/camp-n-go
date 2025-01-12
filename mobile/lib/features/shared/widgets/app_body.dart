import 'package:campngo/config/constants.dart';
import 'package:campngo/features/shared/widgets/app_drawer.dart';
import 'package:campngo/features/shared/widgets/texts/standard_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final bool showDrawer;
  final String? titleText;

  const AppBody({
    super.key,
    required this.child,
    this.scrollable = true,
    this.showDrawer = true,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        title: titleText != null
            ? StandardText(
                titleText!,
                textAlign: TextAlign.center,
              )
            : null,
        titleSpacing: Constants.spaceXL,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      endDrawer: showDrawer ? const AppDrawer() : null,
      endDrawerEnableOpenDragGesture: false,
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
