import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelfio;
import 'dart:io';
import 'package:image_gradient/image_gradient.dart';
import '../api/anilist_api.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import 'package:flutter_nime/models/models.dart';
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

  Future<void> _startServer() async {
    handler(shelf.Request request) async {
      // Extract access token from request URL
      if (!receivedValid) {
        receivedValid = true;
        var uri = request.requestedUri;
        accessCode = request.requestedUri.queryParameters['code'];
        receivedValid = true;
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
    String newbannerUrl = await getUserbannerImageUrl(userName!);
    String newavatarUrl = await getUserAvatarImageUrl(userName!);
    List<AnimeModel> newWatchingAnimeList =
    await getUserAnimeLists(userId!, "Watching");
    List<AnimeModel> newPlanningAnimeList =
    await getUserAnimeLists(userId!, "Planning");
    List<AnimeModel> newPausedAnimeList =
    await getUserAnimeLists(userId!, "Paused");
    setState(() {
      bannerImageUrl = newbannerUrl;
      avatarImageUrl = newavatarUrl;
      watchingList = newWatchingAnimeList;
      planningList = newPlanningAnimeList;
      pausedList = newPausedAnimeList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.35,
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
                              IconButton(
                                onPressed: () {
                                  prefs.clear();
                                  setState(() {
                                    bannerImageUrl = null;
                                    avatarImageUrl = null;
                                    watchingList = null;
                                    planningList = null;
                                    pausedList = null;
                                    userName = null;
                                    userId = null;
                                    accessToken = null;
                                    refreshToken = null;
                                  });
                                  setSharedPreferences();
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
                ],
              )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(color: const Color.fromARGB(255, 34, 33, 34),),
                  ),
                ),
              ),
            ],
          ),
          userName == null
              ? Row(
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
                  )),
            ],
          )
              : Padding(
            padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .width * 0.1),
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
                          Navigator.pushNamed(
                              context, "animeScreen");
                        },
                      ),
                      AnimeButton(
                        text: "Mangas",
                        onTap: () {
                          Navigator.pushNamed(
                              context, "mangaScreen");
                        },
                      ),
                    ],
                  )
                      : const Text(
                    "Login found! Loading, please wait...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  watchingList != null
                      ? AnimeWidgetList(
                        tag: "home-details-list1",
                        title: "Continue Watching",
                        animeList: watchingList!,
                        textColor: Colors.white,
                        loadMore: false,
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
                      )
                      : const SizedBox(),
                  pausedList != null
                      ? AnimeWidgetList(
                        tag: "home-details-list3",
                        title: "Why don't you resume your animes!",
                        animeList: pausedList!,
                        textColor: Colors.white,
                        loadMore: false,
                      )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
