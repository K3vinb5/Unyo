import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unyo/screens/scaffold_screen.dart';
import 'package:unyo/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  // final String optionName;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences? prefs;
  int themesCurrentOption = 0;

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    themesCurrentOption = prefs?.getInt("themes") ?? 0;
    print(themesCurrentOption);
  }

  void selectNewTheme(int index) {
    prefs?.setInt("themes", index);
    print("seted $index");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              IconButton(
                onPressed: () {
                  goTo(1);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              WindowTitleBarBox(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 50,
                    ),
                    Expanded(
                      child: MoveWindow(),
                    ),
                    const WindowButtons(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
          SettingsOptionWidget(
            selectedOption: themesCurrentOption,
            selectNewOption: selectNewTheme,
            title: "Themes",
            options: const [
              "Auto (from banner)",
              "Red Accent",
              "Yellow Accent",
              "Blue Accent",
              "Purple Accent",
              "Pink Accent",
              "Grey Accent",
              "Green Accent"
            ],
          ),
        ],
      ),
    );
  }
}
