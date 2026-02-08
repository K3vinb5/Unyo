import 'dart:async';

import 'package:flutter/material.dart';

class UnyoTextfield extends StatefulWidget {
  final double? width;
  final IconData? icon;
  final String? hint;
  final String? label;
  final int debounceMilliseconds;
  final void Function(String)? onChange;

  const UnyoTextfield({super.key, this.width, this.icon, this.hint, required this.label, required this.debounceMilliseconds, required this.onChange});

  @override
  State<UnyoTextfield> createState() => _UnyoTextfieldState();
}

class _UnyoTextfieldState extends State<UnyoTextfield> {
  late final TextEditingController searchController;
  Timer onChangeDebounce = Timer(const Duration(milliseconds: 0), () {});
  String currentText = '';

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    onChangeDebounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => SizedBox(
            width: widget.width ?? constraints.maxWidth,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(widget.icon ?? Icons.search, color: ColorScheme.of(context).tertiary.withValues(alpha: 0.7)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: ColorScheme.of(context).tertiary.withValues(alpha: 0.8), width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(color: ColorScheme.of(context).primary, width: 3),
                ),
                hintText: widget.hint,
                label:
                    widget.label != null
                        ? Text(widget.label!, style: TextStyle(color: Colors.white.withValues(alpha: 0.8)))
                        : null,
              ),
              onChanged: (newText) {
                if (newText != currentText && widget.onChange != null) {
                  setState(() {
                    currentText = newText;
                    onChangeDebounce.cancel();
                    onChangeDebounce = Timer(Duration(milliseconds: widget.debounceMilliseconds), () {
                      widget.onChange!(newText);
                    });
                  });
                }
              },
            ),
          ),
    );
  }
}
