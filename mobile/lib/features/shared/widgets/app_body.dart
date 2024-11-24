import 'package:flutter/material.dart';

class AppBody extends StatelessWidget {
  final List<Widget> children;

  const AppBody({
    super.key,
    required this.children,
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
        child: Padding(
          padding: const EdgeInsets.only(
            left: 40.0,
            right: 40.0,
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
      ),
    );
  }
}
