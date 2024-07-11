import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen(
      {super.key, required this.chapterId, required this.getMangaChapterPages});

  final String chapterId;
  final Future<List<String>> Function(String) getMangaChapterPages;

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final double barHeight = 50;

  int currentPage = 0;
  int totalPages = 0;
  late List<String> chapterPages;
  List<Uint8List?> chapterBytes = [null];

  int currentPageOption = 0;
  int currentFittingOption = 0;
  int currentOrientationOption = 0;

  @override
  void initState() {
    super.initState();
    initPages();
  }

  void initPages() async {
    chapterPages = await widget.getMangaChapterPages(widget.chapterId);
    setState(() {
      totalPages = chapterPages.length;
      //kinda scuffed
      chapterBytes = List.filled(totalPages, null);
    });
    downloadChapterPages();
  }

  //Thos should not be moved to the consumet file since you want it to show pages as soon as it downloads them one at a time, instead of alll at once
  void downloadChapterPages() async {
    Map<String, String> headers = {"Referer": "http://www.mangahere.cc/"};
    for (int i = 0; i < totalPages; i++) {
      var response =
          await http.get(Uri.parse(chapterPages[i]), headers: headers);
      Uint8List bytes = response.bodyBytes;
      setState(() {
        chapterBytes[i] = bytes;
      });
    }
  }

  void goBackPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage -= 2;
      }
    });
  }

  void goForwardPage() {
    setState(() {
      if (currentPage < totalPages - 3) {
        currentPage += 2;
      } else if (currentPage < totalPages - 2) {
        currentPage++;
      }
    });
  }

  void setNewFittingPageOption(int newFittingOption) {
    setState(() {
      currentFittingOption = newFittingOption;
    });
  }

  void setNewPageOption(int newPageOption) {
    setState(() {
      currentPageOption = newPageOption;
    });
  }

  void setNewOrientationOption(int newOrientationOption) {
    setState(() {
      currentOrientationOption = newOrientationOption;
    });
  }

  ///Allows user to show the type of schema they want for displaying pages
  Widget listPages(bool leftToRight, width, height) {
    switch (currentPageOption) {
      case 0:
        return singlePageList(width, height);
      case 1:
        return doublePageList(leftToRight, width, height);
      case 2:
        // Needs reworking
        return scrollingList(width);
      default:
        return singlePageList(width, height);
    }
  }

  Widget singlePageList(double width, double height) {
    if (currentPage == totalPages - 1) {
      currentPage--;
    }
    return SizedBox(
      width: width,
      height: height,
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.globalToLocal(event.position);
          if (position.dx < MediaQuery.of(context).size.width / 2) {
            // Clicked on the left side
            setState(() {
              if (currentPage > 0) {
                currentPage--;
              }
            });
          } else {
            // Clicked on the right side
            setState(() {
              if (currentPage < totalPages - 1) {
                currentPage++;
              }
            });
          }
        },
        child: Column(
          children: [
            chapterBytes[currentPage] != null
                ? SizedBox(
                    height: height,
                    width: width,
                    child: currentFittingOption != 0
                        ? SingleChildScrollView(
                            child: Image.memory(
                              chapterBytes[currentPage]!,
                              fit: currentFittingOption == 0
                                  ? BoxFit.fitHeight
                                  : BoxFit.fitWidth,
                            ),
                          )
                        : Image.memory(
                            chapterBytes[currentPage]!,
                            fit: currentFittingOption == 0
                                ? BoxFit.fitHeight
                                : BoxFit.fitWidth,
                          ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget doublePageList(bool leftToRight, double width, double height) {
    return SizedBox(
      width: width,
      // height: height,
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final position = renderBox.globalToLocal(event.position);
          if (position.dx < MediaQuery.of(context).size.width / 2) {
            // Clicked on the left side
            if (currentOrientationOption != 0) {
              goForwardPage();
            } else {
              goBackPage();
            }
          } else {
            // Clicked on the right side
            if (currentOrientationOption != 0) {
              goBackPage();
            } else {
              goForwardPage();
            }
          }
        },
        child: Column(
          children: [
            chapterBytes[currentPage] != null
                ? SizedBox(
                    height: height,
                    width: width,
                    child: Center(
                      child: doublePages(leftToRight),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget doublePages(bool leftToRight) {
    if (currentPage == chapterBytes.length) {
      //last chapter page
      return Image.memory(
        chapterBytes[currentPage]!,
        fit: currentFittingOption == 0 ? BoxFit.fitHeight : BoxFit.fitWidth,
      );
    }

    Widget doublePage = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.memory(
          chapterBytes[leftToRight ? currentPage : currentPage + 1]!,
          fit: currentFittingOption == 0 ? BoxFit.fitHeight : BoxFit.fitWidth,
        ),
        const SizedBox(
          width: 5,
        ),
        Image.memory(
          chapterBytes[leftToRight ? currentPage + 1 : currentPage]!,
          fit: currentFittingOption == 0 ? BoxFit.fitHeight : BoxFit.fitWidth,
        ),
      ],
    );

    //every other page
    return currentFittingOption != 0
        ? SingleChildScrollView(child: doublePage)
        : doublePage;
  }

  Widget scrollingList(double width) {
    return SingleChildScrollView(
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            ...chapterBytes.mapIndexed((index, element) {
              return chapterBytes[index] != null
                  ? Image.memory(
                      chapterBytes[index]!,
                      fit: currentFittingOption == 0
                          ? BoxFit.fitHeight
                          : BoxFit.fitWidth,
                    )
                  : const SizedBox.shrink();
            })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double usableHeight = totalHeight - 50;

    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MangaOptionsBar(
                width: totalWidth,
                height: barHeight,
                currentPage: currentPage,
                totalPages: totalPages,
                pageOption: currentPageOption,
                setNewPageOption: setNewPageOption,
                fittingOption: currentFittingOption,
                setNewFittingOption: setNewFittingPageOption,
                orientationOption: currentOrientationOption,
                setNewOrientationOption: setNewOrientationOption,
                goBackPage: goBackPage,
                goForwardPage: goForwardPage,
              ),
              SizedBox(
                width: totalWidth,
                height: usableHeight,
                child: listPages(currentOrientationOption == 0, totalWidth, usableHeight),
              ),
            ],
          ),
          const WindowBarButtons(startIgnoreWidth: 650),
        ],
      ),
    );
  }
}
