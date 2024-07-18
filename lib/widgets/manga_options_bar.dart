import 'package:flutter/material.dart';
import 'package:unyo/widgets/styled_button.dart';
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
    required this.goForwardPage,
    required this.goBackPage,
  });

  final double width;
  final double height;

  final int currentPage;
  final int totalPages;
  final int pageOption;
  final int fittingOption;
  final int orientationOption;

  final void Function(int) setNewPageOption;
  final void Function(int) setNewFittingOption;
  final void Function(int) setNewOrientationOption;

  final void Function() goForwardPage;
  final void Function() goBackPage;

  @override
  State<MangaOptionsBar> createState() => _MangaOptionsBarState();
}

class _MangaOptionsBarState extends State<MangaOptionsBar> {
  late int currentPage;
  late int totalPages;

  //TODO replace icons
  List<List<dynamic>> pageButtonOptions = const [
    ["Single Page", Icons.menu_book_rounded], // 0
    ["Double Page", Icons.library_books], // 1
    ["Long Strip", Icons.receipt_long], // 2
  ];
  List<List<dynamic>> orientationButtonOptions = const [
    ["Left to Right", Icons.arrow_right_rounded],
    ["Right to Left", Icons.arrow_left_rounded],
  ];
  List<String> fittingButtonOptions = const [
    "Fit Height",
    "Fit Width",
  ];
  late int currentPageOption;
  late int currentFittingOption;
  late int currentOrientationOption;

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentPage;
    totalPages = widget.totalPages;
    currentPageOption = widget.pageOption;
    currentFittingOption = widget.fittingOption;
    currentOrientationOption = widget.orientationOption;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Row(
            children: [
              //Go Back
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              // Page counter
              Row(
                children: [
                  IconButton(
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
                  IconButton(
                    onPressed: () {
                      if (currentOrientationOption != 0) {
                        widget.goBackPage();
                      } else {
                        widget.goForwardPage();
                      }
                    },
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                  ),
                ],
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
                        Text("${pageButtonOptions[currentPageOption][0]}  "),
                        Icon(pageButtonOptions[currentPageOption][1]),
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
                        Text("${fittingButtonOptions[currentFittingOption]}  "),
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
                        widget
                            .setNewOrientationOption(currentOrientationOption);
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                            "${orientationButtonOptions[currentOrientationOption][0]}  "),
                        Icon(orientationButtonOptions[currentOrientationOption]
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
    );
  }
}
