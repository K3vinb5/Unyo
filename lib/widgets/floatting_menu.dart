import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:collection/collection.dart';

class FloattingMenu extends StatefulWidget {
  const FloattingMenu({super.key, required this.setScreen});

  final void Function(int, BuildContext) setScreen;

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
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 238, 238),
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
                    widget.setScreen(index, context);
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
