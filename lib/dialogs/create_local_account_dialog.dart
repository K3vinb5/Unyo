import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:unyo/util/constants.dart';
import 'package:unyo/widgets/widgets.dart';

void showCreateLocalAccoutDialog(BuildContext context,
    void Function(int) setUserInfo, void Function() goToMainMenu) {
  showDialog(
      context: context,
      builder: (_) => CreateLocalAccountDialog(setUserInfo: setUserInfo, goToMainMenu: goToMainMenu));
}

class CreateLocalAccountDialog extends StatelessWidget {
  const CreateLocalAccountDialog({super.key, required this.setUserInfo, required this.goToMainMenu});
  final void Function(int)
      setUserInfo;
  final void Function() goToMainMenu;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 44, 44, 44),
      title: Text(
        context.tr("create_local_account_title"),
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StyledTextField(
              width: 300,
              controller: controller,
              color: Colors.white,
              hintColor: Colors.grey,
              hint: context.tr("insert_new_name"),
            ),
            StyledButton(
              onPressed: () async{
                if (controller.text.trim() != "") {
                  await prefs.loginUser(controller.text.trim());
                  userName = controller.text.trim();
                  prefs.setString("userName", userName!);
                  setUserInfo(1);
                  goToMainMenu();
                  if(!context.mounted) return;
                  Navigator.of(context).pop();
                }
              },
              text: context.tr("confirm"),
            ),
          ],
        ),
      ),
    );
  }
}
