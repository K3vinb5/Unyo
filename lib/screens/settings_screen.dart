import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/sources/sources.dart';
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
  Map<String, String> langs = {
    "en": "English",
    "pt": "Portuguese",
    "fr": "French",
    "es": "Spanish",
    "it": "Italian",
    "de": "German",
    // "po" : "Polish",
    "ru": "Russian",
    // "zh-cn" : "Chinese (Traditional)",
    // "zh-hk" : "Chinese (Simplified)"
  };

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
              Text(
                context.tr("settings"),
                style: const TextStyle(
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
                    title: context.tr("update_progress_automatically"),
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
                    title: context.tr("buttons_layout_menu_layout"),
                    onPressed: (bool newValue) {
                      setState(() {
                        buttonsLayout = newValue;
                      });
                      isScreenRefreshed.clear();
                      prefs.setBool("buttons_layout", newValue);
                    },
                    value: (prefs.getBool("buttons_layout") ?? false),
                  ),
                  SettingsDropdownOptionWidget(
                    title: context.tr("select_language"),
                    width: 150,
                    value: prefs.getInt("lang") ?? 0,
                    onPressed: (int selected) {
                      prefs.setInt("lang", selected);
                      context.setLocale(Locale(langs.keys.toList()[selected]));
                      print(langs.keys.toList()[selected]);
                      print(context.locale.toString());
                      // isScreenRefreshed.clear();
                    },
                    items: langs.values
                        .map(
                          (lang) => Text(
                            lang,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
                  ),
                  SettingsSwitchOptionWidget(
                    title: context.tr("video_duration_remaining_time"),
                    onPressed: (bool newValue) {
                      setState(() {
                        prefs.setBool("display_video_duration", newValue);
                      });
                    },
                    value: (prefs.getBool("display_video_duration") ?? false),
                  ),
                  SettingsDropdownOptionWidget(
                    title: context.tr("select_theme"),
                    width: 150,
                    value: prefs.getInt("theme") ?? 0,
                    onPressed: (int selected) async {
                      prefs.setInt("theme", selected);
                      initThemes(selected, setState);
                      isScreenRefreshed.clear();
                    },
                    items: themes.entries
                        .map(
                          (entry) => Text(
                            entry.key,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                        .toList(),
                  ),
                  SettingsSwitchOptionWidget(
                    title: context.tr("remote_endpoint"),
                    onPressed: (bool newValue) async {
                      setState(() {
                        prefs.setBool("remote_endpoint", newValue);
                      });
                      if (newValue) {
                        processManager.startProcess();
                      } else {
                        processManager.stopProcess();

                        addEmbeddedAniyomiExtensions();
                      }
                    },
                    value: (prefs.getBool("remote_endpoint") ?? false),
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
