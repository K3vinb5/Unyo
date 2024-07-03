import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.prefs});

  final SharedPreferences prefs;
  // final String optionName;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int themesCurrentOption = 0;
  int langCurrentOption = 0;
  List<String> langs = [
    "English",
    "Portuguese",
    "French",
    "Spanish",
    "Italian",
    "German",
    "Polish",
  ];

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    themesCurrentOption = widget.prefs.getInt("themes") ?? 0;
    langCurrentOption = langs.indexOf(widget.prefs.getString("lang") ?? "English");
    // print(themesCurrentOption);
  }

  void selectNewTheme(int index) {
    widget.prefs.setInt("themes", index);
    // print("seted $index");
  }

  void selectNewLanguage(int lang) {
    widget.prefs.setString("lang", langs[lang]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: SmoothListView(
        duration: const Duration(milliseconds: 200),
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
              SettingsOptionWidget(
                title: "Language",
                options: langs,
                selectedOption: langCurrentOption,
                selectNewOption: selectNewLanguage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
