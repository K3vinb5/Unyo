import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context,
    {String? exception, void Function()? onPressedAfterPop}) {
  showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(exception: exception);
      });
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, this.exception, this.onPressedAfterPop});

  final String? exception;
  final void Function()? onPressedAfterPop;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("An error occured D:",
          style: TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(exception ?? "", style: const TextStyle(color: Colors.white)),
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
                if (onPressedAfterPop != null) {
                  onPressedAfterPop!();
                }
              },
              child: const Text("Ok", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
