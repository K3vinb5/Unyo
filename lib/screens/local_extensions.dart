import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class LocalExtensionsScreen extends StatefulWidget {
  const LocalExtensionsScreen({super.key});

  @override
  State<LocalExtensionsScreen> createState() => _LocalExtensionsScreenState();
}

class _LocalExtensionsScreenState extends State<LocalExtensionsScreen> {
  late List<String> installedExtensions;
  late List<String> availableExtensions;

  @override
  void initState() {
    super.initState();
    updateInstalledExtensions();
  }

  Widget consoleWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
      ),
    );
  }

  List<Widget> sourcesWidgets() {
    return installedExtensions
        .map(
          (source) => Column(
            children: [
              const Divider(
                height: 0,
                thickness: 2,
                color: Colors.grey,
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                    width: 200,
                      child: Text(
                        "${source[0].toUpperCase()}${source.substring(1)} extension",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_rounded,
                      ),
                    color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  void updateInstalledExtensions() async {
    Directory supportDirectory = await getApplicationSupportDirectory();
    Directory extensionsDir = Directory("${supportDirectory.path}//extensions");
    installedExtensions = await extensionsDir
        .list()
        .map((fileSystemEntity) => fileSystemEntity.path
            .substring(fileSystemEntity.path.lastIndexOf("/") + 1)
            .replaceFirst(".jar", ""))
        .toList();
  }

  void updateAvailableExtensions() async {}

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    double adjustedHeigth = getAdjustedHeight(totalHeight, context);
    double adjustedWidth = getAdjustedWidth(totalWidth, context);
    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: Column(
        children: [
          Row(
            children: [
              StyledScreenMenuWidget(
                isRow: true,
                onBackPress: null,
                onMenuPress: buttonsLayout,
                onRefreshPress: () {
                  setState(() {});
                },
              ),
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
                      style: const TextStyle(color: Colors.white, fontSize: 23),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 24.0, top: 40),
                      child: Container(
                        width: adjustedWidth,
                        height: adjustedHeigth * 0.78,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
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
                    Text(
                      context.tr("extensions"),
                      style: const TextStyle(color: Colors.white, fontSize: 23),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, bottom: 24.0, top: 40),
                      child: SizedBox(
                        width: adjustedWidth,
                        height: adjustedHeigth * 0.78,
                        child: SmoothListView(
                          duration: const Duration(milliseconds: 200),
                          children: [
                            ...sourcesWidgets(),
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
