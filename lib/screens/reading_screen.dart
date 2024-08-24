import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen(
      {super.key,
      required this.chapterId,
      required this.getMangaChapterPages,
      required this.updateEntry, 
      required this.currentChapter, 
      required this.chaptersId,
      });

  final String chapterId;
  final int currentChapter;
  final List<String> chaptersId; 
  final Future<List<String>> Function(String) getMangaChapterPages;
  final void Function() updateEntry;

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final double barHeight = 50;

  int currentPage = 0;
  int totalPages = 0;
  late List<String> chapterPages;
  List<Uint8List?> chapterBytes = [null];
  final FocusNode _screenFocusNode = FocusNode();
  bool keyDelay = false;
  int currentPageOption = 0;
  int currentFittingOption = 0;
  int currentInverseModeOption = 0;
  int currentOrientationOption = 0;

  @override
  void initState() {
    super.initState();
    initPages(widget.chapterId);
    _screenFocusNode.requestFocus();
  }

  void initPages(String chapterId) async {
    chapterPages = await widget.getMangaChapterPages(chapterId);
    setState(() {
      totalPages = chapterPages.length;
      //kinda scuffed
      chapterBytes = List.filled(totalPages, null);
    });
    downloadChapterPages();
  }

  void downloadChapterPages() async {
    for (int i = 0; i < totalPages; i++) {
      var response = await http.get(Uri.parse(chapterPages[i]));
      Uint8List bytes = response.bodyBytes;
      setState(() {
        chapterBytes[i] = bytes;
      });
    }
  }

  void goBackPage() {
    setState(() {
      if (currentPageOption == 1) {
        if (currentPage > 1) {
          currentPage -= 2;
        }
      } else {
        if (currentPage > 0) {
          currentPage--;
        }
      }
    });
  }

  void goForwardPage() {
    setState(() {
      if (currentPageOption == 1) {
        if (currentPage < totalPages - 3) {
          currentPage += 2;
        } else if (currentPage < totalPages - 2) {
          currentPage++;
        }
      } else {
        currentPage++;
      }
    });
  }

  void onReceivedKeys(LogicalKeyboardKey logicalKey) {
    switch (logicalKey) {
      case LogicalKeyboardKey.space:
        goForwardPage();
        break;
      case LogicalKeyboardKey.arrowLeft:
        goBackPage();
        break;
      case LogicalKeyboardKey.arrowRight:
        goForwardPage();
        break;
      case LogicalKeyboardKey.arrowUp:
        goBackPage();
        break;
      case LogicalKeyboardKey.arrowDown:
        goForwardPage();
        break;
      case LogicalKeyboardKey.keyL:
        goForwardPage();
        break;
      case LogicalKeyboardKey.keyJ:
        goBackPage();
        break;
      case LogicalKeyboardKey.escape:
        if (calculatePercentage() >
                chapterCompletedOptions.values.toList()[
                    prefs.getInt("chapter_completed_percentage") ?? 3] &&
            (prefs.getBool("update_progress_automatically") ?? false)) {
          widget.updateEntry();
        }
        Navigator.pop(context);
        break;
      default:
    }
  }

  double calculatePercentage() {
    return currentPage / totalPages;
  }

  void setNewFittingPageOption(int newFittingOption) {
    setState(() {
      currentFittingOption = newFittingOption;
    });
  }

  void setNewInverseModeOption(int newIverseModeOption) {
    setState(() {
      currentInverseModeOption = newIverseModeOption;
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
        return scrollingList(width, height);
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            chapterBytes[currentPage] != null
                ? SizedBox(
                    height: height,
                    width: width,
                    child: currentFittingOption != 0
                        ? SingleChildScrollView(
                            child: Image.memory(
                              chapterBytes[currentPage]!,
                              color: currentInverseModeOption == 0
                                  ? Colors.black
                                  : Colors.white,
                              colorBlendMode: BlendMode.difference,
                              fit: currentFittingOption == 0
                                  ? BoxFit.fitHeight
                                  : BoxFit.fitWidth,
                            ),
                          )
                        : Image.memory(
                            chapterBytes[currentPage]!,
                            color: currentInverseModeOption == 0
                                ? Colors.black
                                : Colors.white,
                            colorBlendMode: BlendMode.difference,
                            fit: currentFittingOption == 0
                                ? BoxFit.fitHeight
                                : BoxFit.fitWidth,
                          ),
                  )
                : Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white, size: 30),
                  ),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (chapterBytes[currentPage] != null &&
                    chapterBytes[currentPage + 1] != null)
                ? SizedBox(
                    height: height,
                    width: width,
                    child: Center(
                      child: doublePages(leftToRight, width),
                    ),
                  )
                : Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.white, size: 30),
                  ),
          ],
        ),
      ),
    );
  }

  Widget doublePages(bool leftToRight, double width) {
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
        SizedBox(
          width: (width * 0.5) - 2.5,
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.memory(
              chapterBytes[leftToRight ? currentPage : currentPage + 1]!,
              color:
                  currentInverseModeOption == 0 ? Colors.black : Colors.white,
              colorBlendMode: BlendMode.difference,
              fit: currentFittingOption == 0
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: (width * 0.5) - 2.5,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.memory(
              chapterBytes[leftToRight ? currentPage + 1 : currentPage]!,
              color:
                  currentInverseModeOption == 0 ? Colors.black : Colors.white,
              colorBlendMode: BlendMode.difference,
              fit: currentFittingOption == 0
                  ? BoxFit.fitHeight
                  : BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );

    //every other page
    return currentFittingOption != 0
        ? SingleChildScrollView(child: doublePage)
        : doublePage;
  }

  Widget scrollingList(double width, double height) {
    return SingleChildScrollView(
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...chapterBytes.mapIndexed((index, element) {
              return (chapterBytes[index] != null)
                  ? Image.memory(
                      chapterBytes[index]!,
                      color: currentInverseModeOption == 0
                          ? Colors.black
                          : Colors.white,
                      colorBlendMode: BlendMode.difference,
                      fit: currentFittingOption == 0
                          ? BoxFit.fitHeight
                          : BoxFit.fitWidth,
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(vertical: height / 4),
                      child: Center(
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white, size: 30),
                      ),
                    );
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
      child: KeyboardListener(
        focusNode: _screenFocusNode,
        onKeyEvent: (keyEnvent) {
          // print("key received");
          if (keyDelay) {
            return;
          }
          keyDelay = true;
          Timer(
            const Duration(milliseconds: 200),
            () {
              keyDelay = false;
            },
          );
          onReceivedKeys(keyEnvent.logicalKey);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FocusScope(
                  canRequestFocus: false,
                  child: MangaOptionsBar(
                    width: totalWidth,
                    height: barHeight,
                    currentPage: currentPage,
                    totalPages: totalPages,
                    pageOption: currentPageOption,
                    currentChapter: widget.currentChapter,
                    chaptersId: widget.chaptersId,
                    setNewPageOption: setNewPageOption,
                    fittingOption: currentFittingOption,
                    setNewFittingOption: setNewFittingPageOption,
                    orientationOption: currentOrientationOption,
                    setNewOrientationOption: setNewOrientationOption,
                    inverseModeOption: currentInverseModeOption,
                    setNewInverseModeOption: setNewInverseModeOption,
                    initPages: initPages,
                    goBackPage: goBackPage,
                    goForwardPage: goForwardPage,
                  ),
                ),
                SizedBox(
                  width: totalWidth,
                  height: usableHeight,
                  child: listPages(
                      currentOrientationOption == 0, totalWidth, usableHeight),
                ),
              ],
            ),
            const WindowBarButtons(startIgnoreWidth: 1100),
          ],
        ),
      ),
    );
  }
}
