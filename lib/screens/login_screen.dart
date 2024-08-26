import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelfio;
import 'package:flutter/material.dart';
import 'package:smooth_list_view/smooth_list_view.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/dialogs/dialogs.dart';
import 'package:unyo/models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/widgets.dart';
import 'package:unyo/util/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.setUserInfo});

  final void Function(int)
      setUserInfo;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String clientId = '17550';
  final String redirectUri = 'http://localhost:9999/auth';
  TextEditingController manualLoginController = TextEditingController();
  late HttpServer server;

  @override
  void initState() {
    super.initState();
    _startServer();
    prefs.getUsers(setState);
  }

  Future<void> _startServer() async {
    handler(shelf.Request request) async {
      // Extract access token from request URL
      if (!receivedValid) {
        receivedValid = true;
        String accessCode = request.requestedUri.queryParameters['code'] ?? "";
        //print('Access Code: $accessCode');
        List<String> codes = await getUserAccessToken(accessCode, 0);
        accessToken = codes[0];
        //print("AccessToken: $accessToken");
        widget.setUserInfo(0);
        goToMainScreen();
        server.close();
      } else {
        //TODO showDialog
      }
      // Return a response to close the connection
      return shelf.Response.ok(
          'Authorization successful. You can close this window.');
    }

    // Start the local web server
    server = await shelfio.serve(handler, 'localhost', 9999);
  }

  Future<void> login() async {
    final String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';

    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl));
    } else {
      throw 'Could not launch $authUrl';
    }
    // goToMainScreen();
  }

  void manualLoginLaunchUrl() async {
    String authUrl =
        'https://anilist.co/api/v2/oauth/authorize?client_id=18959&redirect_urihttps://anilist.co/api/v2/oauth/pin=&response_type=code';
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
    List<String> codes = [
      jsonResponse["access_token"],
      jsonResponse["refresh_token"]
    ];

    accessToken = codes[0];
    widget.setUserInfo(0);
    goToMainScreen();
  }

  void goToMainScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double totalHeight = MediaQuery.of(context).size.height;
    return Material(
      color: const Color.fromARGB(255, 44, 44, 44),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
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
                          login();
                        },
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
                                manualLoginController: manualLoginController,
                                getCodeFunction: manualLoginLaunchUrl,
                                loginFunction: () async {
                                  manualLogin(manualLoginController.text);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              "Login to Anilist(Manually) ",
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
                    text: "Create Local Account",
                  ),
                ],
              ),
              SizedBox(height: totalHeight * 0.1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        context.tr("logged_users"),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: totalHeight * 0.2,
                          width: 500,
                          child: SmoothListView(
                            scrollDirection: Axis.horizontal,
                            duration: const Duration(milliseconds: 200),
                            children: users != null
                                ? users!
                                    .map((user) => SizedBox(
                                        height: totalHeight * 0.15,
                                        width: totalHeight * 0.15,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: InkWell(
                                                onTap: () async {
                                                  await prefs.loginUser(
                                                      user.userName!);
                                                  if (user
                                                      is AnilistUserModel) {
                                                    userName = user.userName;
                                                    userId = user.userId;
                                                    accessToken = prefs.getString("accessToken"); 
                                                    widget.setUserInfo(0);
                                                  } else if (user
                                                      is LocalUserModel) {
                                                      userName = user.userName;
                                                    widget.setUserInfo(1);
                                                  }
                                                  goToMainScreen();
                                                },
                                                child: CircleAvatar(
                                                  radius: totalHeight * 0.075,
                                                  backgroundImage: NetworkImage(
                                                      user.avatarImage ??
                                                          "https://i.imgur.com/EKtChtm.png"),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              user.userName ?? "null",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )))
                                    .toList()
                                : [
                                    const Text(
                                      "empty",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const WindowBarButtons(startIgnoreWidth: 0),
        ],
      ),
    );
  }
}
