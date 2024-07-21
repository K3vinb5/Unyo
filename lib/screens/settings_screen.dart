import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int themesCurrentOption = 0;
  int langCurrentOption = 0;
  List<String> langs = [
    "English",
    "Portuguese",
    // "French",
    // "Spanish",
    // "Italian",
    // "German",
    // "Polish",
  ];

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    themesCurrentOption = prefs.getInt("themes") ?? 0;
    langCurrentOption = langs.indexOf(prefs.getString("lang") ?? "English");
  }

  void selectNewTheme(int index) {
    prefs.setInt("themes", index);
  }

  void selectNewLanguage(int lang) {
    prefs.setString("lang", langs[lang]);
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
                  const WindowBarButtons(startIgnoreWidth: 50),
                ],
              ),
              const Text(
                "Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SettingsSwitchOptionWidget(
                    title: "Update progress automatically",
                    onPressed: (bool newValue) {
                      setState(() {
                        prefs.setBool(
                            "update_progress_automatically", newValue);
                      });
                    },
                    value: (prefs.getBool("update_progress_automatically") ??
                        false),
                  ),
                  SettingsSwitchOptionWidget(
                    title: "Buttons Layout / Menu Layout",
                    onPressed: (bool newValue) {
                      setState(() {
                        buttonsLayout = newValue;
                      });

                      prefs.setBool("buttons_layout", newValue);
                    },
                    value: (prefs.getBool("buttons_layout") ?? false),
                  ),
                  SettingsDropdownOptionWidget(
                    title: "Select Language",
                    width: 150,
                    onPressed: (int something) {},
                    items: langs
                        .map(
                          (lang) => Text(
                            lang,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
                  ),
                  SettingsSwitchOptionWidget(
                    title: "Display video duration / Display remaining time",
                    onPressed: (bool newValue) {
                      setState(() {
                        prefs.setBool("display_video_duration", newValue);
                      });
                    },
                    value: (prefs.getBool("display_video_duration") ?? false),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
