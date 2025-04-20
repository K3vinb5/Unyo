import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';

void showSimpleDialog(BuildContext context, String title, String message) {
  logger.i("Opened simple dialog: $title - $message");
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: title,
          message: message,
        );
      });
}

class SimpleDialog extends StatelessWidget {
  const SimpleDialog({super.key, required this.message, required this.title});

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
