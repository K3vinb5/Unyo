import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({super.key, this.text, required this.onPressed, this.child});

  final String? text;
  final Widget? child;
  final void Function() onPressed;

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
      onPressed: onPressed,
      child: text != null ? Text(text!) : child ?? const SizedBox(),
    );
  }
}
