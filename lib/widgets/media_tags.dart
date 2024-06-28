import 'package:flutter/material.dart';

class MediaTags extends StatelessWidget {
  const MediaTags({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 150,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}
