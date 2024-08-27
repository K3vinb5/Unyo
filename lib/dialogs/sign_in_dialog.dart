import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/icons/anilist_icons.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/widgets/widgets.dart';

void showSignInDialog(
    {required BuildContext context,
    required double totalHeight,
    required double totalWidth,
    required void Function() login,
    required void Function() getCodeFunction,
    required void Function() goToMainScreen,
    required void Function(int) setUserInfo,
    required void Function(String) manualLogin}) {
  showDialog(
      context: context,
      builder: (_) => SignInDialog(
            totalHeight: totalHeight,
            login: login,
            getCodeFunction: getCodeFunction,
            manualLogin: manualLogin,
            goToMainScreen: goToMainScreen,
            setUserInfo: setUserInfo,
            totalWidth: totalWidth,
          ));
}

class SignInDialog extends StatelessWidget {
  const SignInDialog({
    super.key,
    required this.totalHeight,
    required this.login,
    required this.getCodeFunction,
    required this.manualLogin,
    required this.goToMainScreen,
    required this.setUserInfo,
    required this.totalWidth,
  });
  final double totalHeight;
  final double totalWidth;
  final void Function() login;
  final void Function() getCodeFunction;
  final void Function() goToMainScreen;
  final void Function(int) setUserInfo;
  final void Function(String) manualLogin;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      title: Text(context.tr("sign_int_title"),
          style: const TextStyle(color: Colors.white)),
      content: SizedBox(
        width: totalWidth * 0.5,
        height: totalHeight * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledButton(
              onPressed: () {
                login();
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(
                  width: 240,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login to Anilist  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Anilist.anilist),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return LoginManuallyDialog(
                      manualLoginController: controller,
                      getCodeFunction: getCodeFunction,
                      loginFunction: () async {
                        manualLogin(controller.text.trim());
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(
                  width: 240,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login to Anilist (Copying Code)  ",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Anilist.anilist),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StyledButton(
              onPressed: () {
                Navigator.of(context).pop();
                showCreateLocalAccoutDialog(
                  context,
                  setUserInfo,
                  goToMainScreen,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(
                  width: 240,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${context.tr("create_local_account")}  ",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Icon(Icons.computer_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
