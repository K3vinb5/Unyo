import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({super.key,
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
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.04,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.05,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: !textOrIcon
            ? Icon(widget.icon)
            : Text(
          widget.text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
