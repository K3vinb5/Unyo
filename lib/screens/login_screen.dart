import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/anilist_api.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.updateUserInfo});

  final void Function() updateUserInfo;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences prefs;
  final String clientId = '17550';
  final String redirectUri = 'http://localhost:9999/auth';
  TextEditingController manualLoginController = TextEditingController();


  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void setSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> login() async {
    final String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';

    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl));
    } else {
      throw 'Could not launch $authUrl';
    }
    goToMainScreen();
  }

  void manualLogin(String code) async {
    accessCode = code;
    print('Access Code: $accessCode');
    List<String> codes = await getUserAccessToken(accessCode!);
    accessToken = codes[0];
    refreshToken = codes[1];
    widget.updateUserInfo();
    await prefs.setString("accessCode", accessCode!);
    await prefs.setString("refreshToken", refreshToken!);
    await prefs.setString("accessToken", accessToken!);
    goToMainScreen();
  }

  void goToMainScreen(){
    print("Login Done");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 44, 44, 44),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login();
                      //getUserInfo();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          accessToken == null
                              ? "Please Login to Anilist  "
                              : "Please Wait...  ",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //login();
                      //getUserInfo();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                const Color.fromARGB(255, 44, 44, 44),
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
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.black12),
                                              ),
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                manualLogin(
                                                    manualLoginController.text);
                                                Navigator.of(context).pop();
                                              },
                                              style: const ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                        Colors.black12),
                                              ),
                                              child: const Text(
                                                "Confirm",
                                                style: TextStyle(
                                                    color: Colors.white),
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
                        },
                      );
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black12),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          "Login Manually",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.back_hand, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(),
                ),
                const WindowButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
