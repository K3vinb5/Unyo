import 'package:flutter/material.dart';

class MediaStatusIconWidget extends StatelessWidget {
  const MediaStatusIconWidget({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Icon(
      status == "RELEASING"
          ? Icons.circle
          : status == "NOT_YET_RELEASED"
              ? Icons.circle
              : Icons.check,
      color: status == "RELEASING"
          ? Colors.green
          : status == "NOT_YET_RELEASED"
              ? Colors.orange
              : Colors.grey,
    );
  }
}
