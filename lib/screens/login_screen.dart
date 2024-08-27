import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelfio;
import 'package:flutter/material.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/widgets.dart';
import 'package:unyo/util/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.setUserInfo});

  final void Function(int) setUserInfo;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String clientId = '17550';
  final String redirectUri = 'http://localhost:9999/auth';
  final String manualLoginclientId = '18959';
  final String manualLoginRedirectUri = 'https://anilist.co/api/v2/oauth/pin';
  TextEditingController manualLoginController = TextEditingController();
  late HttpServer server;
  bool registerNew = false;

  @override
  void initState() {
    super.initState();
    prefs.getUsers(setState);
  }

  Future<void> _startServer() async {
    handler(shelf.Request request) async {
      // Extract access token from request URL
      String? accessCode = request.requestedUri.queryParameters['code'];
      if (accessCode == null) {
        return shelf.Response.badRequest(
            body:
                "Something went wrong, please verify your internet connection and try again");
      }
      //print('Access Code: $accessCode');
      List<String> codes = await getUserAccessToken(accessCode, 0);
      accessToken = codes[0];
      //print("AccessToken: $accessToken");
      widget.setUserInfo(0);
      goToMainScreen();
      server.close();
      // Return a response to close the connection
      return shelf.Response.ok(
          'Authorization successful. You can close this window.');
    }

    // Start the local web server
    server = await shelfio.serve(handler, 'localhost', 9999);
  }

  Future<void> login() async {
    await _startServer();
    final String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';

    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl));
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  void manualLoginLaunchUrl() async {
    String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$manualLoginRedirectUri&redirect_uri=$manualLoginRedirectUri&response_type=code';
    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl));
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  void manualLogin(String code) async {
    if (code.isEmpty) return;
    var url = Uri.parse("https://anilist.co/api/v2/oauth/token");
    Map<String, dynamic> query = {
      "grant_type": "authorization_code",
      "client_id": manualLoginclientId,
      "client_secret": "c098EXiKkLbWatBWbNcSJYPv2rnWcQooqfxvoEcR",
      "redirect_uri": manualLoginRedirectUri,
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

    accessToken = jsonResponse["access_token"];
    widget.setUserInfo(0);
    goToMainScreen();
  }

  void goToMainScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    double totalWidth = MediaQuery.of(context).size.width;
    return Material(
      color: const Color.fromARGB(255, 44, 44, 44),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (users == null || users!.isEmpty || registerNew)
                      ? Column(
                          children: [
                            SizedBox(
                              height: totalHeight * 0.1,
                            ),
                            Image.asset(
                              "assets/logo.png",
                              scale: 0.75,
                            ),
                            SizedBox(
                              height: totalHeight * 0.1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: totalHeight * 0.1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StyledButton(
                                      onPressed: () {
                                        setState(() {
                                          registerNew = false;
                                        });
                                      },
                                      text: context.tr("create_local_account"),
                                    ),
                                    StyledButton(
                                      onPressed: () {
                                        login();
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "Login to Anilist ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    StyledButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return LoginManuallyDialog(
                                              manualLoginController:
                                                  manualLoginController,
                                              getCodeFunction:
                                                  manualLoginLaunchUrl,
                                              loginFunction: () async {
                                                manualLogin(
                                                    manualLoginController.text);
                                                Navigator.of(context).pop();
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "Login to Anilist (Manually) ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.back_hand,
                                              color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                StyledButton(
                                  onPressed: () {
                                    showCreateLocalAccoutDialog(
                                      context,
                                      widget.setUserInfo,
                                      goToMainScreen,
                                    );
                                  },
                                  text: context.tr("create_local_account"),
                                ),
                              ],
                            ),
                          ],
                        )
                      : SizedBox(
                          height: totalHeight,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    context.tr("select_user"),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: totalHeight * 0.07,
                                  ),
                                  Align(
                                    child: SizedBox(
                                      width: totalWidth,
                                      child: Center(
                                        child: SingleChildScrollView(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50),
                                          scrollDirection: Axis.horizontal,
                                          child: users != null
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    ...users!.map((user) =>
                                                        LoggedUserWidget(
                                                          totalHeight:
                                                              totalHeight,
                                                          user: user,
                                                          setUserInfo: widget
                                                              .setUserInfo,
                                                          goToMainScreen:
                                                              goToMainScreen,
                                                        )),
                                                    LoggedUserWidget(
                                                        totalHeight:
                                                            totalHeight,
                                                        createAccount: () {
                                                          setState(() {
                                                            registerNew = true;
                                                          });
                                                        },
                                                        setUserInfo:
                                                            widget.setUserInfo,
                                                        goToMainScreen:
                                                            goToMainScreen)
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      "Unyo, by K3vinb5 ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.asset(
                                      "assets/logo.png",
                                      scale: 2.5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ],
          ),
          const WindowBarButtons(startIgnoreWidth: 0),
        ],
      ),
    );
  }
}
