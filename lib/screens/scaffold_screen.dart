import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

late StatefulNavigationShell publicNavigationShell;

late void Function(int) goTo;
late void Function(bool) floatingMenu;
bool menu = false;
//sidebar
int selectedIndex = 0;
int navIndex = 1;

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
      changeScreen(navIndex, index);
      refreshScreen(index);
      navIndex = index;
    };

    floatingMenu = (input) => menu = input;
  }

  void refreshScreen(int to) {
    switch (to) {
      case 0:
        if (!isScreenRefreshed.contains(to)) {
          refreshAnimeScreenState(() {});
          isScreenRefreshed.add(to);
        }
        break;
      case 1:
        break;
      case 2:
        if (!isScreenRefreshed.contains(to)) {
          refreshMangaScreenState(() {});
          isScreenRefreshed.add(to);
        }
        break;
      case 3:
        if (!isScreenRefreshed.contains(to)) {
          refreshAnimeUserListScreenState(() {});
          isScreenRefreshed.add(to);
        }
        break;
      case 4:
        if (!isScreenRefreshed.contains(to)) {
          refreshMangaUserListScreenState(() {});
          isScreenRefreshed.add(to);
        }
        break;
      case 5:
        break;
      default:
    }
  }

  void changeScreen(int from, int to) {
    switch (to) {
      case 0:
        resumeAnimePageTimer();
        if (from == 2) {
          pauseAnimePageTimer();
        }
        break;
      case 1:
        if (updateHomeScreenLists != null) {
          updateHomeScreenLists!();
        }
        if (from == 0) {
          pauseAnimePageTimer();
        } else if (from == 2) {
          pauseMangaPageTimer();
        }
        break;
      case 2:
        resumeMangaPageTimer();
        if (from == 0) {
          pauseAnimePageTimer();
        }
        break;
      case 3:
        if (from == 0) {
          pauseAnimePageTimer();
        } else if (from == 2) {
          pauseMangaPageTimer();
        }
        break;
      case 4:
        if (from == 0) {
          pauseAnimePageTimer();
        } else if (from == 2) {
          pauseMangaPageTimer();
        }
        break;
      case 5:
        if (from == 0) {
          pauseAnimePageTimer();
        } else if (from == 2) {
          pauseMangaPageTimer();
        }
        break;
      default:
    }
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

  void selectIndex(int newIndex) {
    selectedIndex = newIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(
        selectIndex: selectIndex,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.navigationShell,
          if (menu)
            FloattingMenu(
              setScreen: setScreen,
              height: 50,
            ),
        ],
      ),
    );
  }
}
