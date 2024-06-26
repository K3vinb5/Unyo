import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:collection/collection.dart';

class FloattingMenu extends StatefulWidget {
  const FloattingMenu({super.key ,required this.setScreen, required this.height});

  final void Function(BuildContext, int) setScreen;
  final double height;
  @override
  State<FloattingMenu> createState() => _FloattingMenuState();
}

class _FloattingMenuState extends State<FloattingMenu> {
  List<bool> menuItems = [false, true, false];
  List<String> menuItemsName = ["Anime", "Home", "Manga"];
  List<IconData> menuItemsIcons = [
    Icons.movie_filter,
    Icons.home,
    Icons.menu_book_rounded
  ];

  void updateMenuItems(int selectedIndex) {
    for (int i = 0; i < menuItems.length; i++) {
      menuItems[i] = false;
    }
    menuItems[selectedIndex] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.0, top: widget.height),
      child: Container(
        width: 280,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...menuItems.mapIndexed(
              (index, element) => MenuButton(
                text: menuItemsName[index],
                icon: menuItemsIcons[index],
                onTap: () {
                  setState(() {
                    updateMenuItems(index);
                    widget.setScreen(context, index);
                  });
                },
                textOrIcon: element,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
