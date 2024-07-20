import 'package:flutter/material.dart';

class StyledScreenMenuWidget extends StatelessWidget {
  const StyledScreenMenuWidget(
      {super.key, required this.onBackPress, required this.onRefreshPress});

  final void Function() onBackPress;
  final void Function() onRefreshPress;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 4.0, bottom: 4.0),
            child: IconButton(
              onPressed: onBackPress,
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: IconButton(
              onPressed: onRefreshPress,
              icon: const Icon(Icons.refresh),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
