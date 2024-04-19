import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unyo/widgets/widgets.dart';

late StatefulNavigationShell publicNavigationShell;

late void Function(int) goTo;

class ScaffoldScreen extends StatefulWidget {
  const ScaffoldScreen({super.key, required this.navigationShell});
  
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldScreen> createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen> {
  
  @override
  void initState() {
    super.initState();
    publicNavigationShell = widget.navigationShell;

    goTo = (index) {
      publicNavigationShell.goBranch(index);
    };
  }

  void setScreen(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    widget.navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /*Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.navigationShell,
          FloattingMenu(setScreen: setScreen),
        ],
      ),*/
      widget.navigationShell,
    );
  }
}
