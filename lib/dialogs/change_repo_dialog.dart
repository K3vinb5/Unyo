import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:logger/logger.dart';

void showChangeRepoDialog(
    BuildContext context, TextEditingController controller) {
  logger.i("Opened changeRepo dialog");
  showDialog(
      context: context,
      builder: (context) {
        return ChangeRepoDialog(
          controller: controller,
        );
      });
}

class ChangeRepoDialog extends StatelessWidget {
  const ChangeRepoDialog({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr("change_repo"),
          style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(context.tr("change_repo_message"),
                style: const TextStyle(color: Colors.white)),
            StyledTextField(
              width: 500,
              controller: controller,
              color: Colors.white,
              hintColor: Colors.grey,
              hint: prefs.getString("extensions_json_url") ??
                  "https://raw.githubusercontent.com/K3vinb5/Unyo-Extensions/main/index.json",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StyledButton(
                  onPressed: () {
                    logger.i("Restored extensions repository to default");
                    prefs.setString("extensions_json_url",
                        "https://raw.githubusercontent.com/K3vinb5/Unyo-Extensions/main/index.json");
                    Navigator.of(context).pop();
                  },
                  text: context.tr("restore_default"),
                ),
                const SizedBox(
                  width: 5,
                ),
                StyledButton(
                  onPressed: () {
                    logger.i("Changed extensions repository");
                    if (controller.text.trim() != "") {
                      prefs.setString(
                          "extensions_json_url", controller.text.trim());
                    }
                    Navigator.of(context).pop();
                  },
                  text: context.tr("confirm"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
