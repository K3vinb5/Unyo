import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MediaStatusTextWidget extends StatelessWidget {
  const MediaStatusTextWidget({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Text(
      status == "RELEASING"
          ? " ${context.tr("releasing")}"
          : status == "NOT_YET_RELEASED"
              ? " ${context.tr("unreleased")}"
              : " ${context.tr("finished")}",
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
