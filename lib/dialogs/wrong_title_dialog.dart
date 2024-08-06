import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class WrongTitleDialog extends StatelessWidget {
  const WrongTitleDialog(
      {super.key,
      required this.width,
      required this.height,
      required this.wrongTitleSearchController,
      required this.onSelected,
      required this.onPressed,
      required this.wrongTitleEntries,
      required this.manualSelection,
      });

  final double width;
  final double height;
  final TextEditingController wrongTitleSearchController;
  final void Function(dynamic)? onSelected;
  final void Function() onPressed;
  final List<DropdownMenuEntry<dynamic>> wrongTitleEntries;
  final int? manualSelection;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.5,
      height: height * 0.5,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          opacity: 0.1,
          image: NetworkImage("https://i.imgur.com/fUX8AXq.png"),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Text("select_new_title_text".tr(),
                  style: const TextStyle(color: Colors.white, fontSize: 22)),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownMenu(
                    width: width * 0.4,
                    textStyle: const TextStyle(color: Colors.white),
                    menuStyle: const MenuStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 44, 44, 44),
                      ),
                    ),
                    controller: wrongTitleSearchController,
                    onSelected: onSelected,
                    initialSelection: manualSelection ?? 0,
                    dropdownMenuEntries: wrongTitleEntries,
                    menuHeight: height * 0.3,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledButton(
                text: "confirm".tr(),
                onPressed: onPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
