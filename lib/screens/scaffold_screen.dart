import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unyo/widgets/widgets.dart';

late StatefulNavigationShell publicNavigationShell;

late void Function(int) goTo;
late void Function(bool) floatingMenu;

class ScaffoldScreen extends StatefulWidget {
  const ScaffoldScreen({super.key, required this.navigationShell});
  
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldScreen> createState() => _ScaffoldScreenState();
}

class _ScaffoldScreenState extends State<ScaffoldScreen> {

  bool menu = false;

  @override
  void initState() {
    super.initState();
    publicNavigationShell = widget.navigationShell;

    goTo = (index) {
      publicNavigationShell.goBranch(index);
    };
    floatingMenu = (input) => menu = input;
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.navigationShell,
          if (menu) FloattingMenu(setScreen: setScreen),
        ],
      ),
    );
  }
}
