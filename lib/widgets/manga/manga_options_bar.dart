import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class MangaOptionsBar extends StatefulWidget {
  const MangaOptionsBar({
    super.key,
    required this.width,
    required this.height,
    required this.currentPage,
    required this.totalPages,
    required this.pageOption,
    required this.setNewPageOption,
    required this.fittingOption,
    required this.setNewFittingOption,
    required this.orientationOption,
    required this.setNewOrientationOption,
    required this.updateUserMediaModel,
    required this.goForwardPage,
    required this.goBackPage,
    required this.inverseModeOption,
    required this.setNewInverseModeOption,
    required this.currentChapter,
    required this.chaptersId,
    required this.initPages,
  });

  final double width;
  final double height;
  final int currentChapter;
  final List<String> chaptersId;
  final int currentPage;
  final int totalPages;
  final int pageOption;
  final int fittingOption;
  final int orientationOption;
  final int inverseModeOption;

  final void Function(int) setNewPageOption;
  final void Function(int) setNewFittingOption;
  final void Function(int) setNewOrientationOption;
  final void Function(int) setNewInverseModeOption;
  final void Function(String) initPages;

  final void Function() updateUserMediaModel;
  final void Function() goForwardPage;
  final void Function() goBackPage;

  @override
  State<MangaOptionsBar> createState() => _MangaOptionsBarState();
}

class _MangaOptionsBarState extends State<MangaOptionsBar> {
  late int currentPage;
  late int totalPages;

  //TODO replace icons
  List<List<dynamic>>? pageButtonOptions;
  List<List<dynamic>>? orientationButtonOptions;
  List<List<dynamic>>? inverseButtonOptions;
  List<String>? fittingButtonOptions;
  late int currentPageOption;
  late int currentFittingOption;
  late int currentOrientationOption;
  late int currentInverseOption;
  late int currentChapter;
  late List<String> chaptersId;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      initOptionsLists();
    });
    currentPage = widget.currentPage;
    totalPages = widget.totalPages;
    currentPageOption = widget.pageOption;
    currentFittingOption = widget.fittingOption;
    currentOrientationOption = widget.orientationOption;
    currentInverseOption = widget.inverseModeOption;
    currentChapter = widget.currentChapter;
    chaptersId = widget.chaptersId;
    // initOptionsLists();
  }

  @override
  void didUpdateWidget(covariant MangaOptionsBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPage != widget.currentPage) {
      setState(() {
        currentPage = widget.currentPage;
      });
    } else if (oldWidget.totalPages != widget.totalPages) {
      setState(() {
        totalPages = widget.totalPages;
      });
    }
  }

  void initOptionsLists() {
    pageButtonOptions = [
      [context.tr("single_page"), Icons.library_books], // 0
      [context.tr("double_page"), Icons.menu_book_rounded], // 1
      [context.tr("long_strip"), Icons.receipt_long], // 2
    ];
    orientationButtonOptions = [
      [context.tr("left_to_right"), Icons.arrow_right_rounded],
      [context.tr("right_to_left"), Icons.arrow_left_rounded],
    ];
    inverseButtonOptions = [
      [context.tr("light_mode"), Icons.remove_red_eye_outlined],
      [context.tr("dark_mode"), Icons.remove_red_eye],
    ];

    fittingButtonOptions = [
      context.tr("fit_height"),
      context.tr("fit_width"),
    ];
  }

  void goToChapter(int newChapter) {
    if (newChapter < 0 || newChapter > widget.chaptersId.length) {
      return;
    }
    // no need for set state since initPages calls it
    currentChapter = newChapter;
    widget.initPages(widget.chaptersId[currentChapter - 1]);
  }

  @override
  Widget build(BuildContext context) {
    return fittingButtonOptions != null
        ? SizedBox(
            width: widget.width,
            height: widget.height,
            child: Column(
              children: [
                Row(
                  children: [
                    //Go Back
                    IconButton(
                      onPressed: () {
                        widget.updateUserMediaModel();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 220,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 42, 42, 42),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tooltip(
                            message: context.tr("previous_chapter"),
                            child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                //go previous chapter
                                int index = currentChapter - 1;
                                goToChapter(index);
                              },
                              icon: const Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          PopupMenuButton<String>(
                            tooltip: context.tr("show_chapters"),
                            color: const Color.fromARGB(255, 34, 33, 34),
                            itemBuilder: (BuildContext context) {
                              return widget.chaptersId
                                  .mapIndexed(
                                    (index, _) => PopupMenuItem<String>(
                                      value:
                                          "${context.tr("chapter")} ${index + 1}",
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          "${context.tr("chapter")} ${index + 1}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList();
                            },
                            onSelected: (value) {
                              goToChapter(int.parse(value.split(" ")[1]));
                            },
                            child: SizedBox(
                              child: Text(
                                "${context.tr("chapter")} $currentChapter / ${widget.chaptersId.length}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Tooltip(
                            message: context.tr("next_chapter"),
                            child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                //go next chapter
                                int index = currentChapter + 1;
                                goToChapter(index);
                              },
                              icon: const Icon(Icons.arrow_right,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Seperator
                    const SizedBox(
                      width: 10,
                    ),
                    // Page counter
                    Container(
                      width: 170,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 42, 42, 42),
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Tooltip(
                            message: currentOrientationOption != 0
                                ? context.tr("next_page")
                                : context.tr("previous_page"),
                            child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                if (currentOrientationOption != 0) {
                                  widget.goForwardPage();
                                } else {
                                  widget.goBackPage();
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_left,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "$currentPage / ${totalPages - 1}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Tooltip(
                            message: currentOrientationOption == 0
                                ? context.tr("next_page")
                                : context.tr("previous_page"),
                            child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                if (currentOrientationOption != 0) {
                                  widget.goBackPage();
                                } else {
                                  widget.goForwardPage();
                                }
                              },
                              icon: const Icon(Icons.arrow_right,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Seperator
                    const SizedBox(
                      width: 10,
                    ),
                    // PageButton
                    Row(
                      children: [
                        StyledButton(
                          onPressed: () {
                            setState(() {
                              currentPageOption++;
                              if (currentPageOption > 2) {
                                currentPageOption = 0;
                              }
                              widget.setNewPageOption(currentPageOption);
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                  "${pageButtonOptions![currentPageOption][0]}  "),
                              Icon(pageButtonOptions![currentPageOption][1]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        StyledButton(
                          onPressed: () {
                            setState(() {
                              currentFittingOption++;
                              if (currentFittingOption > 1) {
                                currentFittingOption = 0;
                              }
                              widget.setNewFittingOption(currentFittingOption);
                            });
                          },
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                  "${fittingButtonOptions![currentFittingOption]}  "),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        StyledButton(
                          onPressed: () {
                            setState(() {
                              currentOrientationOption++;
                              if (currentOrientationOption > 1) {
                                currentOrientationOption = 0;
                              }
                              widget.setNewOrientationOption(
                                  currentOrientationOption);
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                  "${orientationButtonOptions![currentOrientationOption][0]}  "),
                              Icon(orientationButtonOptions![
                                  currentOrientationOption][1]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        StyledButton(
                          onPressed: () {
                            setState(() {
                              currentInverseOption++;
                              if (currentInverseOption > 1) {
                                currentInverseOption = 0;
                              }
                              widget.setNewInverseModeOption(
                                  currentInverseOption);
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                  "${inverseButtonOptions![currentInverseOption][0]}  "),
                              Icon(inverseButtonOptions![currentInverseOption]
                                  [1]),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5,
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
