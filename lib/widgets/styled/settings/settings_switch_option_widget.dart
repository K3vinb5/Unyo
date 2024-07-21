import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';

class SettingsSwitchOptionWidget extends StatelessWidget {
  const SettingsSwitchOptionWidget(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.value});

  final String title;
  final void Function(bool) onPressed;
  final bool value;

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
                      Switch(
                        activeTrackColor: lightBorderColor,
                        value: value,
                        onChanged: onPressed,
                      ),
                      const SizedBox(
                        width: 150,
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
