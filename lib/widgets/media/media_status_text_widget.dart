import 'package:flutter/material.dart';

class MediaStatusTextWidget extends StatelessWidget {
  const MediaStatusTextWidget({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Text(
      status == "RELEASING"
          ? " Releasing"
          : status == "NOT_YET_RELEASED"
              ? " Unreleased"
              : " Finished",
      style: TextStyle(
        color: status == "RELEASING"
            ? Colors.green
            : status == "NOT_YET_RELEASED"
                ? Colors.orange
                : Colors.grey,
      ),
    );
  }
}
