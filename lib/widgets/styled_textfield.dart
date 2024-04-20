import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  const StyledTextField(
      {super.key,
      required this.width,
      required this.controller,
      this.onChanged,
      required this.color,
      required this.hintColor,
      this.label,
      required this.hint});

  final double width;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final Color color;
  final Color hintColor;
  final String? label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: color),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: color),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: color),
          ),
          hintText: hint,
          labelText: label,
          hintStyle: TextStyle(
            color: hintColor,
          ),
        ),
        cursorColor: color,
        style: TextStyle(
          color: color,
        ),
      ),
    );
  }
}
