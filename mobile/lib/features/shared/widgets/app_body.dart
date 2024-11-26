import 'package:campngo/config/constants.dart';
import 'package:campngo/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBody extends StatelessWidget {
  final List<Widget> children;
  final bool showBackIcon;

  const AppBody({
    super.key,
    required this.children,
    this.showBackIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: Constants.spaceL,
      //   backgroundColor: Colors.transparent,
      //   surfaceTintColor: Colors.transparent,
      //   elevation: 0,
      // ),
      // extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children,
                    ),
                  ),
                ],
              ),
            ),
            showBackIcon
                ? Positioned(
                    top: Constants.spaceM,
                    left: Constants.spaceM,
                    child: IconButton(
                      onPressed: () {
                        serviceLocator<GoRouter>().pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  )
                : const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
