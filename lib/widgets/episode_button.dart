import 'package:flutter/material.dart';

class EpisodeButton extends StatelessWidget {
  const EpisodeButton({super.key, required this.number, required this.onTap});

  final num number;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text("Episode${number}"),
          ),
        ),
      ),
    );
  }
}
