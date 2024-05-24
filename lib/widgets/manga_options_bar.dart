import 'package:flutter/material.dart';

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

  //TODO check icons
  List<List<dynamic>> pageButtonOptions = const [
    ["Double Page", Icons.library_books],
    ["Single Page", Icons.menu_book_rounded],
    ["Long Strip", Icons.receipt_long],
  ];
  late int currentPageOption;

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
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
          //Go Back
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          // Page counter
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_left)),
              const SizedBox(
                width: 10,
              ),
              Text("$currentPage / $totalPages"),
              const SizedBox(
                width: 10,
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_right)),
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
                child: Row(
                  children: [
                    Text("${pageButtonOptions[currentPageOption][0]}  "),
                    Icon(pageButtonOptions[currentPageOption][1]),
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
