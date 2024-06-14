import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelfio;
import 'dart:io';
import 'package:image_gradient/image_gradient.dart';
import 'package:unyo/screens/screens.dart';
import 'package:unyo/api/anilist_api_anime.dart';
import 'package:unyo/api/anilist_api_manga.dart';
import 'package:unyo/widgets/widgets.dart';
import 'package:unyo/models/models.dart';

String? accessToken;
String? refreshToken;
String? accessCode;
bool receivedValid = false;

void Function()? updateHomeScreenLists;

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
  List<MangaModel>? readingList;
  double adjustedWidth = 0;
  double adjustedHeight = 0;
  double totalWidth = 0;
  double totalHeight = 0;

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
    // print('Local server running on port ${server.port}');
  }

  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("accessToken") == null) {
      _startServer();
      goToLogin();
    } else {
      accessToken = prefs.getString("accessToken");
      userName = prefs.getString("userName");
      userId = prefs.getInt("userId");
      getUserInfo();
    }
  }

  void goToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          updateUserInfo: getUserInfo,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setSharedPreferences();
    updateHomeScreenLists = updateUserLists;
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
    List<MangaModel> newReadingMangaList =
        await getUserMangaLists(userId!, "Reading", 0);
    setState(() {
      bannerImageUrl = newbannerUrl;
      avatarImageUrl = newavatarUrl;
      watchingList = newWatchingAnimeList;
      readingList = newReadingMangaList;
    });
  }

  void updateUserLists() async {
    List<AnimeModel> newWatchingAnimeList =
        await getUserAnimeLists(userId!, "Watching", 0);
    List<MangaModel> newReadingMangaList =
        await getUserMangaLists(userId!, "Reading", 0);
    setState(() {
      watchingList = newWatchingAnimeList;
      readingList = newReadingMangaList;
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
                                        SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(
                                            avatarImageUrl!,
                                            fit: BoxFit.fill,
                                          ),
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
                                                                        //TODO updateLists on logout, maybe extract method
                                                                        bannerImageUrl =
                                                                            null;
                                                                        avatarImageUrl =
                                                                            null;
                                                                        watchingList =
                                                                            null;
                                                                        readingList =
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
                                                                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage(updateUserInfo: getUserInfo),));
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
              watchingList == null
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        FlutterSplashScreen.fadeIn(
                          backgroundColor:
                              const Color.fromARGB(255, 44, 44, 44),
                          animationCurve: Curves.decelerate,
                          duration: const Duration(milliseconds: 5000),
                          animationDuration: const Duration(milliseconds: 5000),
                          childWidget: Center(
                            child: Image.asset(
                              "assets/logo.png",
                              scale: 0.85,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: WindowTitleBarBox(
                            child: Row(
                              children: [
                                Expanded(
                                  child: MoveWindow(),
                                ),
                                const WindowButtons(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.only(top: totalHeight * 0.25),
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
                                          goTo(0);
                                        },
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                        horizontalAllignment: true,
                                      ),
                                      AnimeButton(
                                        text: "Mangas",
                                        onTap: () {
                                          goTo(2);
                                        },
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                        horizontalAllignment: true,
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Login found! Loading, please wait...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                            //NOTE pageStart
                            // FloattingMenu(
                            // height: totalHeight * 0.1,
                            // ),
                            const SizedBox(
                              height: 30,
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
                                    verticalPadding: 30,
                                  )
                                : const SizedBox(),
                            readingList != null
                                ? MangaWidgetList(
                                    tag: "home-details-list2",
                                    title: "Continue Reading",
                                    mangaList: readingList!,
                                    textColor: Colors.white,
                                    loadMore: false,
                                    updateHomeScreenLists: updateUserLists,
                                    width: adjustedWidth,
                                    height: adjustedHeight,
                                    verticalPadding: 30,
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AnimeButton(
                                        text: "Anime List",
                                        onTap: () {
                                          goTo(3);
                                        },
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                        horizontalAllignment: false,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      AnimeButton(
                                        text: "Manga List",
                                        onTap: () {
                                          goTo(4);
                                        },
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                        horizontalAllignment: false,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      AnimeButton(
                                        text: "Calendar",
                                        onTap: () {},
                                        width: adjustedWidth,
                                        height: adjustedHeight,
                                        horizontalAllignment: false,
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      // AnimeButton(
                                      //     text: "User Stats",
                                      //     onTap: () {},
                                      //     width: adjustedWidth,
                                      //     height: adjustedHeight),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 55,
                            ),
                            //NOTE pageEnd
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
