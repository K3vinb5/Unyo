import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';

void showConnectionSuccessfulDialog(BuildContext context) {
  logger.i("Opened connection successful dialog");
  showDialog(
    context: context,
    builder: (context) {
      return const ConnectionSuccessfulDialog();
    },
  );
}

class ConnectionSuccessfulDialog extends StatelessWidget {
  const ConnectionSuccessfulDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Connection Successful",
          style: TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
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
