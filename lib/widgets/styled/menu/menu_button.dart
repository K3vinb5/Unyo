import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/styled/custom/hovering_animated_container.dart';

class MenuButton extends StatefulWidget {
  const MenuButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.onTap,
      required this.textOrIcon});

  final String text;
  final IconData icon;
  final void Function() onTap;
  final bool textOrIcon;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  late bool textOrIcon;

  @override
  void initState() {
    super.initState();
    textOrIcon = widget.textOrIcon;
  }

  @override
  void didUpdateWidget(covariant MenuButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textOrIcon != widget.textOrIcon) {
      setState(() {
        textOrIcon = widget.textOrIcon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: HoverAnimatedContainer(
        cursor: SystemMouseCursors.click,
        alignment: Alignment.center,
        height: 60,
        width: 60,
        // hoverWidth: 70,
        // hoverHeight: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: !textOrIcon
            ? HoverAnimatedContainer(
                child: Icon(
                  widget.icon,
                  color: textOrIcon ? lightBorderColor : Colors.white,
                ),
              )
            : Text(
                widget.text,
                style: TextStyle(
                  color: textOrIcon ? lightBorderColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
