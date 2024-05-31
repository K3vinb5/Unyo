import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MangaOptionsBar extends StatefulWidget {
  const MangaOptionsBar({
    super.key,
    required this.width,
    required this.height,
    required this.currentPage,
    required this.totalPages,
    required this.pageOption,
    required this.setNewPageOption,
  });

  final double width;
  final double height;

  final int currentPage;
  final int totalPages;
  final int pageOption;

  final void Function(int) setNewPageOption;

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
  late int currentPageOption;
  //TODO finish implementing
  List<String> fittingButtonOptions = const [
    "Fit Height",
    "Fit Width",
  ];
  int currentFittingOption = 0;

  @override
  void initState() {
    super.initState();
    currentPage = widget.currentPage;
    totalPages = widget.totalPages;
    currentPageOption = widget.pageOption;
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPageOption++;
                        if (currentPageOption > 2) {
                          currentPageOption = 0;
                        }
                        widget.setNewPageOption(currentPageOption);
                      });
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 37, 37, 37),
                      ),
                      foregroundColor: MaterialStatePropertyAll(
                        Colors.white,
                      ),
                    ),
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentFittingOption++;
                        if (currentFittingOption > 1) {
                          currentFittingOption = 0;
                        }
                        // widget.setNewPageOption(currentPageOption);
                      });
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 37, 37, 37),
                      ),
                      foregroundColor: MaterialStatePropertyAll(
                        Colors.white,
                      ),
                    ),
                    child: Row(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        Text("${fittingButtonOptions[currentFittingOption]}  "),
                      ],
                    ),
                  ),
                ],
              ),
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
