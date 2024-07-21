import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class StyledDropDown extends StatefulWidget {
  const StyledDropDown({
    super.key,
    required this.items,
    required this.horizontalPadding,
    required this.onTap,
    required this.width,
    this.height,
  });

  final List<Widget> items;
  final double horizontalPadding;
  final void Function(int) onTap;
  final double width;
  final double? height;

  @override
  State<StyledDropDown> createState() => _StyledDropDownState();
}

class _StyledDropDownState extends State<StyledDropDown> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: SizedBox(
        width: widget.width,
        height: widget.height ?? 48,
        child: DropdownButton(
          padding: const EdgeInsets.only(left: 10),
          style: const TextStyle(
            color: Colors.white,
          ),
          dropdownColor: const Color.fromARGB(255, 38, 37, 38),
          focusColor: Colors.transparent,
          underline: const SizedBox(),
          value: value,
          items: [
            ...widget.items.mapIndexed(
              (index, childWidget) {
                return DropdownMenuItem(
                  onTap: () {
                    setState(() {
                      value = index;
                    });
                    widget.onTap(index);
                  },
                  value: index,
                  child: childWidget,
                );
              },
            ),
          ],
          onChanged: (index) {},
        ),
      ),
    );
  }
}
