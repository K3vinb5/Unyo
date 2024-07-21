import 'package:flutter/material.dart';

class StyledButton extends StatefulWidget {
  const StyledButton({super.key, this.text, required this.onPressed, this.child});

  final String? text;
  final Widget? child;
  final void Function() onPressed;

  @override
  State<StyledButton> createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Color.fromARGB(255, 37, 37, 37),
        ),
        foregroundColor: MaterialStatePropertyAll(
          Colors.white,
        ),
      ),
      onPressed: widget.onPressed,
      child: widget.text != null ? Text(widget.text!) : widget.child ?? const SizedBox(),
    );
  }
}
