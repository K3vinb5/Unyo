import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:unyo/main.dart';

class SettingsOptionWidget extends StatefulWidget {
  const SettingsOptionWidget({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.selectNewOption,
  });

  final int selectedOption;
  final String title;
  final List<String> options;
  final void Function(int) selectNewOption;

  @override
  State<SettingsOptionWidget> createState() => _SettingsOptionWidgetState();
}

class _SettingsOptionWidgetState extends State<SettingsOptionWidget> {
  late List<bool> optionsSelected;

  @override
  void initState() {
    super.initState();
    optionsSelected = List.filled(widget.options.length, false);
    initPrefOptions();
  }

  @override
  void didUpdateWidget(covariant SettingsOptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      print("The selected option Changed to : $selectOption");
      initPrefOptions();
    }
  }

  void selectOption(int optionIndex) {
    for (int i = 0; i < optionsSelected.length; i++) {
      optionsSelected[i] = false;
    }
    optionsSelected[optionIndex] = true;
  }

  void initPrefOptions() async {
    setState(() {
      optionsSelected[widget.selectedOption] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeigh = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
            ),
            child: Column(
              children: [
                ...widget.options.mapIndexed(
                  (index, option) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: totalWidth * 0.2,
                          child: Text(
                            option,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Checkbox(
                          value: optionsSelected[index],
                          fillColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.selected)) {
                              return lightBorderColor;
                            } else {
                              return const Color.fromARGB(255, 36, 35, 36);
                            }
                          }),
                          onChanged: (ignore) {
                            setState(() {
                              selectOption(index);
                              widget.selectNewOption(index);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15,),
          const Divider(
            color: Colors.grey,
            thickness: 2,
            indent: 8,
            endIndent: 8,
          ),
        ],
      ),
    );
  }
}
