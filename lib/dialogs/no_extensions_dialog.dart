import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';

void showNoExtensionsDialog(
    BuildContext context) {
  logger.i("No extensions dialog opened");
  showDialog(
      context: context,
      builder: (context) {
        return NoExtensionsDialog(
          title: context.tr("no_extensions_title"),
          message: context.tr("no_extensions_message"),
        );
      });
}

class NoExtensionsDialog extends StatelessWidget {
  const NoExtensionsDialog(
      {super.key, required this.message, required this.title});

  final String message;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(message, style: const TextStyle(color: Colors.white)),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Color.fromARGB(255, 37, 37, 37),
                ),
                foregroundColor: MaterialStatePropertyAll(
                  Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
