import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

void Function(void Function())? refreshLocalExtensionsScreenState;

class LocalExtensionsScreen extends StatefulWidget {
  const LocalExtensionsScreen({super.key});

  @override
  State<LocalExtensionsScreen> createState() => _LocalExtensionsScreenState();
}

class _LocalExtensionsScreenState extends State<LocalExtensionsScreen> {
  List<String>? installedAnimeExtensions;
  List<String>? installedMangaExtensions;
  Map<String, dynamic>? availableAnimeExtensions;
  Map<String, dynamic>? availableMangaExtensions;
  Map<String, dynamic>? animeExtensionsLang;
  Map<String, dynamic>? mangaExtensionsLang;
  TextEditingController controller = TextEditingController();
  bool selectedExtensions = false;

  @override
  void initState() {
    super.initState();
    updateAnimeInstalledExtensions();
    updateAnimeAvailableExtensions();
    updateMangaInstalledExtensions();
    updateMangaAvailableExtensions();
    refreshLocalExtensionsScreenState = setState;
  }

  List<String>? getInstalledExtensions() {
    if (selectedExtensions) {
      return installedMangaExtensions;
    } else {
      return installedAnimeExtensions;
    }
  }

  Map<String, dynamic>? getAvailableExtensions() {
    if (selectedExtensions) {
      return availableMangaExtensions;
    } else {
      return availableAnimeExtensions;
    }
  }

  Map<String, dynamic>? getExtensionsLang() {
    if (selectedExtensions) {
      return mangaExtensionsLang;
    } else {
      return animeExtensionsLang;
    }
  }

  Widget consoleWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: processManager.outputHistory.isNotEmpty
          ? Column(
              children: [
                ...processManager.outputHistory.map(
                  (e) => SelectableText(
                    e.values.toList()[0],
                    style: TextStyle(
                      color: e.keys.toList()[0] ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Text(
                  context.tr("extensions_not_enabled_message"),
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                  ),
                ),
              ],
            ),
    );
  }

  List<Widget> sourcesWidgets(
      List<String>? installedExtensions,
      Map<String, dynamic>? extensionsLang,
      Map<String, dynamic>? availableExtensions) {
    return installedExtensions != null &&
            extensionsLang != null &&
            availableExtensions != null
        ? availableExtensions.keys
            .map(
              (source) => Column(
                children: [
                  const Divider(
                    height: 0,
                    thickness: 2,
                    color: Color.fromARGB(255, 43, 44, 43),
                    endIndent: 20,
                    indent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            "${source[0].toUpperCase()}${source.substring(1)} ( ${extensionsLang[source]} )",
                            style: TextStyle(color: veryLightBorderColor),
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: !installedExtensions.contains(source)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Tooltip(
                                      message: context.tr("download"),
                                      child: IconButton(
                                        onPressed: () async {
                                          if (!selectedExtensions) {
                                            addAnimeExtension(source);
                                          } else {
                                            addMangaExtension(source);
                                          }
                                          processManager.restartProcess();
                                        },
                                        icon: const Icon(
                                          Icons.download_rounded,
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      context.tr("installed"),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Tooltip(
                                      message: context.tr("delete"),
                                      child: IconButton(
                                        onPressed: () async {
                                          if (!selectedExtensions) {
                                            removeAnimeExtension(source);
                                          } else {
                                            removeMangaExtension(source);
                                          }
                                          processManager.restartProcess();
                                        },
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                        ),
                                        color: const Color.fromARGB(
                                            255, 64, 63, 64),
                                      ),
                                    )
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .toList()
        : [];
  }

  void updateAnimeInstalledExtensions() async {
    Directory supportDirectoryPath = await getApplicationSupportDirectory();
    final animeExtensionsDir =
        Directory(p.join(supportDirectoryPath.path, "extensions", "anime"));
    List<String> updatedinstalledExtensions = await animeExtensionsDir
        .list()
        .map((fileSystemEntity) => fileSystemEntity.path
            .substring(fileSystemEntity.path.lastIndexOf(Platform.isWindows ? "\\" : "/") + 1)
            .replaceFirst(".jar", ""))
        .toList();
    print(updatedinstalledExtensions);
    setState(() {
      installedAnimeExtensions = updatedinstalledExtensions;
    });
  }

  void updateMangaInstalledExtensions() async {
    Directory supportDirectoryPath = await getApplicationSupportDirectory();
    final mangaExtensionsDir =
        Directory(p.join(supportDirectoryPath.path, "extensions", "manga"));
    List<String> updatedinstalledExtensions = await mangaExtensionsDir
        .list()
        .map((fileSystemEntity) => fileSystemEntity.path
            .substring(fileSystemEntity.path.lastIndexOf(Platform.isWindows ? "\\" :"/") + 1)
            .replaceFirst(".jar", ""))
        .toList();
    setState(() {
      installedMangaExtensions = updatedinstalledExtensions;
    });
  }

  void updateAnimeAvailableExtensions() async {
    var url = Uri.parse(prefs.getString("extensions_json_url") ??
        "https://raw.githubusercontent.com/K3vinb5/Unyo-Extensions/main/index.json");
    var response = await http.get(url);
    Map<String, dynamic> newAnimeAvailableExtensions =
        json.decode(response.body)["animeAvailableExtensions"];
    Map<String, dynamic> newAnimeExtensionsLang =
        json.decode(response.body)["animeExtensionsLang"];
    setState(() {
      availableAnimeExtensions = newAnimeAvailableExtensions;
      animeExtensionsLang = newAnimeExtensionsLang;
    });
  }

  void updateMangaAvailableExtensions() async {
    var url = Uri.parse(prefs.getString("extensions_json_url") ??
        "https://raw.githubusercontent.com/K3vinb5/Unyo-Extensions/main/index.json");
    var response = await http.get(url);
    Map<String, dynamic> newMangaAvailableExtensions =
        json.decode(response.body)["mangaAvailableExtensions"];
    Map<String, dynamic> newMangaExtensionsLang =
        json.decode(response.body)["mangaExtensionsLang"];
    setState(() {
      availableMangaExtensions = newMangaAvailableExtensions;
      mangaExtensionsLang = newMangaExtensionsLang;
    });
  }

  void removeAnimeExtension(String source) async {
    Directory supportDirectory = await getApplicationSupportDirectory();
    File jarFile = File(
        p.join(supportDirectory.path, "extensions", "anime", "$source.jar"));
    await jarFile.delete();
    updateAnimeInstalledExtensions();
  }

  void removeMangaExtension(String source) async {
    Directory supportDirectory = await getApplicationSupportDirectory();
    File jarFile = File(
        p.join(supportDirectory.path, "extensions", "manga", "$source.jar"));
    await jarFile.delete();
    updateMangaInstalledExtensions();
  }

  void addAnimeExtension(String source) async {
    var url = Uri.parse(availableAnimeExtensions![source]);
    var response = await http.get(url);
    Directory supportDirectory = await getApplicationSupportDirectory();
    File jarFile = File(
        p.join(supportDirectory.path, "extensions", "anime", "$source.jar"));
    await jarFile.writeAsBytes(response.bodyBytes);
    updateAnimeInstalledExtensions();
  }

  void addMangaExtension(String source) async {
    var url = Uri.parse(availableMangaExtensions![source]);
    var response = await http.get(url);
    Directory supportDirectory = await getApplicationSupportDirectory();
    File jarFile = File(
        p.join(supportDirectory.path, "extensions", "manga", "$source.jar"));
    await jarFile.writeAsBytes(response.bodyBytes);
    updateMangaInstalledExtensions();
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    // double adjustedHeigth = getAdjustedHeight(totalHeight, context);
    double adjustedWidth = getAdjustedWidth(totalWidth, context);
    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              StyledScreenMenuWidget(
                isRow: true,
                onBackPress: () {
                  goTo(1);
                },
                onMenuPress: buttonsLayout,
                onRefreshPress: () {
                  setState(() {});
                },
              ),
              const WindowBarButtons(startIgnoreWidth: 100),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.tr("console"),
                      style:
                          TextStyle(color: veryLightBorderColor, fontSize: 23),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 32.0,
                          right: 16.0,
                          bottom: 24.0,
                          top: totalHeight * 0.05),
                      child: Container(
                        width: adjustedWidth,
                        height: totalHeight * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: veryLightBorderColor,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView(
                          children: [
                            consoleWidget(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: !selectedExtensions
                                        ? lightBorderColor.withOpacity(0.65)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        setState(() {
                                          selectedExtensions = false;
                                        });
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        context.tr("anime"),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: selectedExtensions
                                        ? lightBorderColor.withOpacity(0.65)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 300),
                                          () {
                                        setState(() {
                                          selectedExtensions = true;
                                        });
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        context.tr("manga"),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              context.tr("extensions"),
                              style: TextStyle(
                                  color: veryLightBorderColor, fontSize: 23),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 48.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  StyledButton(
                                    text: context.tr("change_repo"),
                                    onPressed: () {
                                      showChangeRepoDialog(context, controller);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  StyledButton(
                                    text: context.tr("need_help"),
                                    onPressed: () {
                                      showSimpleDialog(
                                        context,
                                        context.tr("need_help_title"),
                                        context.tr("need_help_message"),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          bottom: 24.0,
                          top: totalHeight * 0.05),
                      child: SizedBox(
                        width: adjustedWidth,
                        height: totalHeight * 0.8,
                        child: SmoothListView(
                          duration: const Duration(milliseconds: 200),
                          children: [
                            ...sourcesWidgets(
                              getInstalledExtensions(),
                              getExtensionsLang(),
                              getAvailableExtensions(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
