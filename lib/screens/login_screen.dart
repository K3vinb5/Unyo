import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/widgets.dart';
import 'package:unyo/util/utils.dart';

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

  void setSharedPreferences() async {
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

  void manualLaunchUrl() async {
    String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=18959&redirect_urihttps://anilist.co/api/v2/oauth/pin=&response_type=code';
    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl));
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  void manualLogin(String code) async {
    if(code.isEmpty)return;
    var url = Uri.parse("https://anilist.co/api/v2/oauth/token");
    Map<String, dynamic> query = {
      "grant_type": "authorization_code",
      "client_id": 18959,
      "client_secret": "c098EXiKkLbWatBWbNcSJYPv2rnWcQooqfxvoEcR",
      "redirect_uri": "https://anilist.co/api/v2/oauth/pin",
      "code": code,
    };
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: json.encode(query),
    );
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse);
    List<String> codes = [
      jsonResponse["access_token"],
      jsonResponse["refresh_token"]
    ];

    accessToken = codes[0];
    refreshToken = codes[1];
    accessCode = code;
    widget.updateUserInfo();
    await prefs.setString("accessCode", accessCode!);
    await prefs.setString("refreshToken", refreshToken!);
    await prefs.setString("accessToken", accessToken!);
    goToMainScreen();
  }

  void goToMainScreen() {
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
                    child: const Row(
                      children: [
                        Text(
                          "Login to Anilist  ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
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
                                        onPressed: () {
                                          manualLaunchUrl();
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.black12),
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
