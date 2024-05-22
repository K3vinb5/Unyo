import 'package:flutter/material.dart';

class MangaOptionsBar extends StatefulWidget {
  const MangaOptionsBar({super.key, required this.width, required this.height});

  final double width;
  final double height;

  @override
  State<MangaOptionsBar> createState() => _MangaOptionsBarState();
}

class _MangaOptionsBarState extends State<MangaOptionsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(color: Colors.grey),
      child: Row(
        children: [
                     
        ],
      ),
    );
  }
}
