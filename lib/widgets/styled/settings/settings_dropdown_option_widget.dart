import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class SettingsDropdownOptionWidget extends StatelessWidget {
  const SettingsDropdownOptionWidget({
    super.key,
    required this.title,
    required this.onPressed,
    required this.items, 
    required this.width,
  });

  final String title;
  final double width;
  final void Function(int) onPressed;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 39, 38, 39),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 150,
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      StyledDropDown(
                        height: 45,
                        items: items,
                        horizontalPadding: 0,
                        onTap: onPressed,
                        width: width,
                      ),
                      SizedBox(
                        width: 150 - (width / 3),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
