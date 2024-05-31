import 'dart:typed_data';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:unyo/api/consumet_api.dart';
import 'package:unyo/widgets/widgets.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key, required this.chapterId});

  final String chapterId;

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

  @override
  void initState() {
    super.initState();
    initPages();
  }

  void initPages() async {
    chapterPages = await getMangaMangaHereChapterPages(widget.chapterId);
    setState(() {
      totalPages = chapterPages.length;
      //kinda scuffed
      chapterBytes = List.filled(totalPages, null);
    });
    downloadChapterPages();
  }

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

  void setNewPageOption(int newPageOption) {
    setState(() {
      currentPageOption = newPageOption;
    });
  }

  Widget listPages(bool leftToRight, width, height) {
    switch (currentPageOption) {
      case 0:
        return singlePageList(leftToRight, width, height);
      case 1:
        // Needs reworking
        return scrollingList();
      // case 2:
      //   break;
      default:
        return singlePageList(leftToRight, width, height);
    }
  }

  Widget singlePageList(bool leftToRight, double width, double height) {
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
              if (currentPage < totalPages) {
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
                    child: Image.memory(
                      chapterBytes[currentPage]!,
                      fit: BoxFit.fitHeight,
                    ))
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget doublePageList(bool leftToRight, double width, double height) {
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
              if (currentPage < totalPages) {
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
                    child: doublePages(leftToRight),
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
        fit: BoxFit.fitHeight,
      );
    }
    //every other page
    return Row(
      children: [
        Image.memory(
          chapterBytes[currentPage]!,
          fit: BoxFit.fitHeight,
        ),
        Image.memory(
          chapterBytes[currentPage + 1]!,
          fit: BoxFit.fitHeight,
        ),
      ],
    );
  }

  Widget scrollingList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...chapterBytes.mapIndexed((index, element) {
            return chapterBytes[index] != null
                ? Image.memory(chapterBytes[index]!)
                : const SizedBox.shrink();
          })
        ],
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
              ),
              SizedBox(
                width: totalWidth,
                height: usableHeight,
                child: listPages(false, totalWidth, usableHeight),
              ),
            ],
          ),
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(),
                ),
                const WindowButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
