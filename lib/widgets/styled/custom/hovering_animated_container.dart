import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HoverAnimatedContainer extends StatefulWidget {
  final double? width;
  final double? hoverWidth;
  final double? height;
  final double? hoverHeight;
  final Curve? curve;
  final Decoration? decoration;
  final Decoration? hoverDecoration;
  final SystemMouseCursor? cursor;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? hoverMargin;
  final Duration? duration;
  final Alignment? alignment;

  const HoverAnimatedContainer(
      {super.key,
      this.width,
      this.hoverWidth,
      this.height,
      this.hoverHeight,
      this.curve,
      this.decoration,
      this.hoverDecoration,
      this.cursor,
      this.alignment,
      required this.child,
      this.margin,
      this.hoverMargin,
      this.duration});

  @override
  State<HoverAnimatedContainer> createState() => _HoverAnimatedContainerState();
}

class _HoverAnimatedContainerState extends State<HoverAnimatedContainer> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() {
        hovering = true;
      }),
      onExit: (event) => setState(() {
        hovering = false;
      }),
      cursor: widget.cursor ?? SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: widget.duration ?? const Duration(milliseconds: 200),
        curve: widget.curve ?? Curves.linear,
        width: hovering ? widget.hoverWidth : widget.width,
        height: hovering ? widget.hoverHeight : widget.height,
        decoration: hovering ? widget.hoverDecoration : widget.decoration,
        margin: hovering ? widget.hoverMargin : widget.margin,
        child: widget.child,
      ),
    );
  }
}
