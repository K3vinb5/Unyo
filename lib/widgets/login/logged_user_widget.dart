import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/models/models.dart';
import 'package:unyo/util/constants.dart';

import '../styled/custom/hovering_animated_container.dart';

class LoggedUserWidget extends StatelessWidget {
  const LoggedUserWidget({
    super.key,
    required this.totalHeight,
    this.user,
    this.createAccount,
    required this.setUserInfo,
    required this.goToMainScreen,
  });
  final double totalHeight;
  final UserModel? user;
  final void Function()? createAccount;
  final void Function(int) setUserInfo;
  final void Function() goToMainScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: HoverAnimatedContainer(
            duration: const Duration(milliseconds: 100),
            cursor: SystemMouseCursors.click,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(140),
                border: Border.all(color: Colors.white, width: 3)),
            hoverDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                border: Border.all(color: Colors.white, width: 8)),
            child: InkWell(
              borderRadius: BorderRadius.circular(140),
              onTap: () async {
                if (user != null) {
                  await prefs.loginUser(user!.userName!);
                  if (user is AnilistUserModel) {
                    userName = user!.userName;
                    userId = user!.userId;
                    accessToken = prefs.getString("accessToken");
                    setUserInfo(0);
                  } else if (user is LocalUserModel) {
                    userName = user!.userName;
                    setUserInfo(1);
                  }
                  goToMainScreen();
                } else if (createAccount != null){
                  createAccount!(); 
                }
              },
              child: CircleAvatar(
                radius: totalHeight * 0.12,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  (user != null)
                      ? user!.avatarImage ?? "https://i.imgur.com/EKtChtm.png"
                      : "https://i.ibb.co/Kj8CQZH/cross.png",
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              user != null
                  ? "${user!.userName}     "
                  : "${context.tr("add_account")}     ",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
