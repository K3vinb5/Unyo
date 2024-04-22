import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelfio;
import 'dart:io';
import 'package:image_gradient/image_gradient.dart';
import 'package:unyo/screens/scaffold_screen.dart';
import '../api/anilist_api.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/models/models.dart';
import 'package:url_launcher/url_launcher.dart';

String? accessToken;
String? refreshToken;
String? accessCode;
bool receivedValid = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? bannerImageUrl;
  String? avatarImageUrl;
  String? userName;
  int? userId;
  late SharedPreferences prefs;
  late HttpServer server;
  List<AnimeModel>? watchingList;
  List<AnimeModel>? planningList;
  List<AnimeModel>? pausedList;
  final String clientId = '17550';
  final String redirectUri = 'http://localhost:9999/auth';
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  TextEditingController manualLoginController = TextEditingController();

  Future<void> _startServer() async {
    handler(shelf.Request request) async {
      // Extract access token from request URL
      if (!receivedValid) {
        receivedValid = true;
        accessCode = request.requestedUri.queryParameters['code'];
        //print('Access Code: $accessCode');
        List<String> codes = await getUserAccessToken(accessCode!);
        accessToken = codes[0];
        refreshToken = codes[1];
        //print("AccessToken: $accessToken");
        getUserInfo();
        await prefs.setString("accessCode", accessCode!);
        await prefs.setString("refreshToken", refreshToken!);
        await prefs.setString("accessToken", accessToken!);
      } else {
        //TODO showDialog
      }
      // Return a response to close the connection
      return shelf.Response.ok(
          'Authorization successful. You can close this window.');
    }

    // Start the local web server
    server = await shelfio.serve(handler, 'localhost', 9999);
    print('Local server running on port ${server.port}');
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("accessToken") == null) {
      _startServer();
    } else {
      accessToken = prefs.getString("accessToken");
      userName = prefs.getString("userName");
      userId = prefs.getInt("userId");
      getUserInfo();
    }
  }

  Future<void> login() async {
    if (accessToken == null) {
      final String authUrl =
          'https://anilist.co/api/v2/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code';

      if (await canLaunchUrl(Uri.parse(authUrl))) {
        await launchUrl(Uri.parse(authUrl));
      } else {
        throw 'Could not launch $authUrl';
      }
    }
  }

  void manualLogin(String code) async {
    accessCode = code;
    print('Access Code: $accessCode');
    List<String> codes = await getUserAccessToken(accessCode!);
    accessToken = codes[0];
    refreshToken = codes[1];
    //print("AccessToken: $accessToken");
    getUserInfo();
    await prefs.setString("accessCode", accessCode!);
    await prefs.setString("refreshToken", refreshToken!);
    await prefs.setString("accessToken", accessToken!);
  }

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
  }

  void getUserInfo() async {
    if (userName == null || userId == null) {
      List<String> userNameAndId = await getUserNameAndId(accessToken!);
      userName = userNameAndId[0];
      userId = int.parse(userNameAndId[1]);
      await prefs.setString("userName", userName!);
      await prefs.setInt("userId", userId!);
    }
    String newbannerUrl = "https://i.imgur.com/x6TGK1x.png";
    try {
      newbannerUrl = await getUserbannerImageUrl(userName!, 0);
    } catch (error) {
      //If newBannerURL never returns a string use default avatar
      print("could not fetch image");
    }
    String newavatarUrl = await getUserAvatarImageUrl(userName!, 0);
    List<AnimeModel> newWatchingAnimeList =
        await getUserAnimeLists(userId!, "Watching", 0);
    List<AnimeModel> newPlanningAnimeList =
        await getUserAnimeLists(userId!, "Planning", 0);
    List<AnimeModel> newPausedAnimeList =
        await getUserAnimeLists(userId!, "Paused", 0);
    setState(() {
      bannerImageUrl = newbannerUrl;
      avatarImageUrl = newavatarUrl;
      watchingList = newWatchingAnimeList;
      planningList = newPlanningAnimeList;
      pausedList = newPausedAnimeList;
    });
  }

  void updateUserLists() async {
    List<AnimeModel> newWatchingAnimeList =
        await getUserAnimeLists(userId!, "Watching", 0);
    List<AnimeModel> newPlanningAnimeList =
        await getUserAnimeLists(userId!, "Planning", 0);
    List<AnimeModel> newPausedAnimeList =
        await getUserAnimeLists(userId!, "Paused", 0);
    setState(() {
      watchingList = newWatchingAnimeList;
      planningList = newPlanningAnimeList;
      pausedList = newPausedAnimeList;
    });
  }

  double getAdjustedHeight(double value) {
    if (MediaQuery.of(context).size.aspectRatio > 1.77777777778) {
      return value;
    } else {
      return value *
          ((MediaQuery.of(context).size.aspectRatio) / (1.77777777778));
    }
  }

  double getAdjustedWidth(double value) {
    if (MediaQuery.of(context).size.aspectRatio < 1.77777777778) {
      return value;
    } else {
      return value *
          ((1.77777777778) / (MediaQuery.of(context).size.aspectRatio));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          adjustedWidth = getAdjustedWidth(MediaQuery.of(context).size.width);
          adjustedHeight =
              getAdjustedHeight(MediaQuery.of(context).size.height);
          totalHeight = MediaQuery.of(context).size.height;
          totalWidth = MediaQuery.of(context).size.width;
          //print("$adjustedWidth / $adjustedHeight");
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  bannerImageUrl != null
                      ? Stack(
                          children: [
                            ImageGradient.linear(
                              image: Image.network(
                                bannerImageUrl!,
                                width: totalWidth,
                                height: totalHeight * 0.35,
                                fit: BoxFit.fill,
                              ),
                              colors: const [Colors.white, Colors.black87],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            avatarImageUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Image.network(
                                          avatarImageUrl!,
                                          scale: 1,
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          userName!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text("Log out",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Do you wanna log out?",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                44, 44, 44),
                                                        content: SizedBox(
                                                          width: adjustedWidth *
                                                              0.15,
                                                          height:
                                                              adjustedHeight *
                                                                  0.15,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Text(
                                                                "Are you sure you want to log out?",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style:
                                                                        const ButtonStyle(
                                                                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(
                                                                          255,
                                                                          37,
                                                                          37,
                                                                          37)),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  ElevatedButton(
                                                                    style:
                                                                        const ButtonStyle(
                                                                      backgroundColor: MaterialStatePropertyAll(Color.fromARGB(
                                                                          255,
                                                                          37,
                                                                          37,
                                                                          37)),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      prefs
                                                                          .clear();
                                                                      setState(
                                                                          () {
                                                                        bannerImageUrl =
                                                                            null;
                                                                        avatarImageUrl =
                                                                            null;
                                                                        watchingList =
                                                                            null;
                                                                        planningList =
                                                                            null;
                                                                        pausedList =
                                                                            null;
                                                                        userName =
                                                                            null;
                                                                        userId =
                                                                            null;
                                                                        accessToken =
                                                                            null;
                                                                        refreshToken =
                                                                            null;
                                                                      });
                                                                      setSharedPreferences();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      "Confirm",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
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
                        )
                      : const SizedBox(),
                  Expanded(
                    child: Container(
                      width: totalWidth,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        border: Border.all(
                          color: const Color.fromARGB(255, 34, 33, 34),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              userName == null
                  ? Stack(
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
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.black12),
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
                                                  style:
                                                      TextStyle(color: Colors.white)),
                                            ],
                                          ),
                                          content: SizedBox(
                                            width: adjustedWidth * 0.5,
                                            height: adjustedHeight * 0.3,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
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
                                                                  manualLoginController
                                                                      .text);
                                                              Navigator.of(context)
                                                                  .pop();
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
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.black12),
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
                  )
                  : Padding(
                      padding: EdgeInsets.only(top: totalHeight * 0.2),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            watchingList != null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      AnimeButton(
                                        text: "Animes",
                                        onTap: () {
                                          /*Navigator.pushNamed(
                                  context, "animeScreen")
                                  .then((_) {
                                updateUserLists();
                              });*/
                                          goTo(0);
                                        },
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                      ),
                                      AnimeButton(
                                        text: "Mangas",
                                        onTap: () {},
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Login found! Loading, please wait...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            watchingList != null
                                ? AnimeWidgetList(
                                    tag: "home-details-list1",
                                    title: "Continue Watching",
                                    animeList: watchingList!,
                                    textColor: Colors.white,
                                    loadMore: false,
                                    updateHomeScreenLists: updateUserLists,
                                    width: adjustedWidth,
                                    height: adjustedHeight,
                                  )
                                : const SizedBox(),
                            planningList != null
                                ? AnimeWidgetList(
                                    tag: "home-details-list2",
                                    title:
                                        "Why don't you see what you planned! :P",
                                    animeList: planningList!,
                                    textColor: Colors.white,
                                    loadMore: false,
                                    updateHomeScreenLists: updateUserLists,
                                    width: adjustedWidth,
                                    height: adjustedHeight,
                                  )
                                : const SizedBox(),
                            pausedList != null
                                ? AnimeWidgetList(
                                    tag: "home-details-list3",
                                    title: "Why don't you resume your animes!",
                                    animeList: pausedList!,
                                    textColor: Colors.white,
                                    loadMore: false,
                                    updateHomeScreenLists: updateUserLists,
                                    width: adjustedWidth,
                                    height: adjustedHeight,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
