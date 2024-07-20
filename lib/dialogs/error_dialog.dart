import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String? s){
  showDialog(context: context, builder: (context){
    return ErrorDialog(exception: s);
  });
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, this.exception});

  final String? exception;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("An error occured D:\n${exception ?? ""}",
          style: const TextStyle(color: Colors.white)),
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
