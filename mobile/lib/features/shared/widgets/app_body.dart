import 'package:campngo/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBody extends StatelessWidget {
  final Widget child;

  const AppBody({
    super.key,
    required this.child,
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
              left: MediaQuery.of(context).size.width * 0.09,
              right: MediaQuery.of(context).size.width * 0.09,
              top: Constants.spaceL,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
