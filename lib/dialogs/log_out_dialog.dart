import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';
import 'package:unyo/widgets/widgets.dart';

void showLogOutDialog(
    BuildContext context,
    void Function(void Function()) setState,
    void Function() attemptLogin,
    double adjustedHeight,
    double adjustedWidth) {
  showDialog(
      context: context,
      builder: (context) => LogOutDialog(
            attemptLogin: attemptLogin,
            adjustedWidth: adjustedWidth,
            adjustedHeight: adjustedHeight,
            setState: setState,
          ));
}

class LogOutDialog extends StatelessWidget {
  const LogOutDialog(
      {super.key,
      required this.attemptLogin,
      required this.adjustedWidth,
      required this.adjustedHeight,
      required this.setState});

  final void Function() attemptLogin;
  final double adjustedWidth;
  final double adjustedHeight;
  final void Function(void Function()) setState;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr("logout_title"),
          style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      content: SizedBox(
        width: adjustedWidth * 0.15,
        height: adjustedHeight * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr("logout_text"),
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: context.tr("cancel"),
                ),
                const SizedBox(
                  width: 20,
                ),
                StyledButton(
                  onPressed: () {
                    prefs.logOut();
                    setState(() {
                      bannerImageUrl = null;
                      avatarImageUrl = null;
                      watchingList = null;
                      readingList = null;
                      userName = null;
                      userId = null;
                      accessToken = null;
                    });
                    attemptLogin();
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
