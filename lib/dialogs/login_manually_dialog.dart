import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/widgets/widgets.dart';

class LoginManuallyDialog extends StatelessWidget {
  const LoginManuallyDialog(
      {super.key,
      required this.manualLoginController,
      required this.getCodeFunction,
      required this.loginFunction
      });

  final TextEditingController manualLoginController;
  final void Function() getCodeFunction;
  final void Function() loginFunction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Paste the Authentication Code",
              style: TextStyle(color: Colors.white)),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                StyledTextField(
                  width: 350,
                  controller: manualLoginController,
                  color: Colors.white,
                  hintColor: Colors.grey,
                  hint: "Paste your code here",
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: getCodeFunction,
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black12),
                  ),
                  child: const Text(
                    "Get your Code!",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black12),
                        ),
                        child: Text(
                          "cancel".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: loginFunction,
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black12),
                        ),
                        child: Text(
                          "confirm".tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
