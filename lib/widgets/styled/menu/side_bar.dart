import 'package:flutter/material.dart';
import 'package:unyo/screens/scaffold_screen.dart';
import 'package:unyo/util/constants.dart';
import 'package:unyo/util/utils.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.selectIndex});

  final void Function(int) selectIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Container(
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                  'assets/logo.png',
                ),
                colorFilter:
                    ColorFilter.mode(lightBorderColor, BlendMode.modulate),
              ),
            ),
          )),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home_rounded),
            selected: selectedIndex == 0,
            onTap: () {
              selectIndex(0);
              goTo(1);
              Navigator.of(context).pop();
            },
            // focusColor: lightBorderColor,
            textColor: Colors.white,
            selectedColor: lightBorderColor,
            iconColor: Colors.white,
          ),
          ListTile(
            title: const Text('Anime'),
            leading: const Icon(Icons.movie_rounded),
            selected: selectedIndex == 1,
            onTap: () {
              selectIndex(1);
              goTo(0);
              Navigator.of(context).pop();
            },
            textColor: Colors.white,
            selectedColor: lightBorderColor,
            iconColor: Colors.white,
          ),
          ListTile(
            title: const Text('Manga'),
            leading: const Icon(Icons.menu_book_rounded),
            selected: selectedIndex == 2,
            onTap: () {
              selectIndex(2);
              goTo(2);
              Navigator.of(context).pop();
            },
            textColor: Colors.white,
            selectedColor: lightBorderColor,
            iconColor: Colors.white,
          ),
          ListTile(
            title: const Text('Anime List'),
            leading: const Icon(Icons.movie_edit),
            selected: selectedIndex == 3,
            onTap: () {
              selectIndex(3);
              goTo(3);
              Navigator.of(context).pop();
            },
            textColor: Colors.white,
            selectedColor: lightBorderColor,
            iconColor: Colors.white,
          ),
          ListTile(
            title: const Text('Manga List'),
            leading: const Icon(Icons.edit_note),
            selected: selectedIndex == 4,
            onTap: () {
              selectIndex(4);
              goTo(4);
              Navigator.of(context).pop();
            },
            textColor: Colors.white,
            selectedColor: lightBorderColor,
            iconColor: Colors.white,
          ),
          ListTile(
            title: const Text('Calendar'),
            leading: const Icon(Icons.calendar_month_rounded),
            selected: selectedIndex == 5,
            onTap: () {
              selectIndex(5);
              goTo(5);
              Navigator.of(context).pop();
            },
            textColor: Colors.white,
            selectedColor: lightBorderColor,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
