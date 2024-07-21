import 'package:flutter/material.dart';

class ColumnOrRowWidget extends StatelessWidget {
  const ColumnOrRowWidget({super.key, required this.isRow, required this.children});

  final bool isRow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return !isRow ? Column(children: children,) : Row(children: children,);
  }
}
