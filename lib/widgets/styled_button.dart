import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({super.key, required this.text, required this.onPressed});

  final String text;
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
      child: Text(text),
    );
  }
}
