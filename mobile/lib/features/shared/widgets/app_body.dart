import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  // final bool showBackIcon;

  const AppBody({
    super.key,
    required this.child,
    // this.showBackIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Constants.spaceL,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.09,
            ),
            child: SafeArea(child: child),
          ),
        ],
      ),
    );
  }
}
