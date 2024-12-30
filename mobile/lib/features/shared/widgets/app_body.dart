import 'package:campngo/features/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppBody extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final bool showDrawer;

  const AppBody({
    super.key,
    required this.child,
    this.scrollable = true,
    this.showDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: ModalRoute.of(context)!.canPop
      //     ? IconButton(
      //         onPressed: context.pop,
      //         icon: Icon(
      //           Icons.arrow_back_outlined,
      //           color: Theme.of(context).colorScheme.onSurface,
      //         ),
      //       )
      //     : null,
      // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      appBar: AppBar(
        forceMaterialTransparency: true,
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(1),
        //   child: Container(
        //     color: Theme.of(context).colorScheme.primary,
        //     height: 1,
        //   ),
        // ),
      ),
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
