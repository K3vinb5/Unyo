import 'package:flutter/material.dart';
import 'package:image_gradient/image_gradient.dart';
import 'package:localstorage/localstorage.dart';
import '../api/anilist_api.dart';
import 'package:flutter_nime/widgets/widgets.dart';
import 'package:flutter_nime/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.usertoken});

  final String? usertoken;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? bannerImageUrl;
  String? avatarImageUrl;
  String? userName;
  String? userToken;
  int? userId;
  TextEditingController controller = TextEditingController();

  List<AnimeModel>? watchingList;
  List<AnimeModel>? planningList;
  List<AnimeModel>? pausedList;
  final LocalStorage storage = new LocalStorage('flutter_nime');

  String? getName() {
    var returnValue = storage.getItem("name");
    return returnValue;
  }

  @override
  void initState() {
    super.initState();
    //userToken = widget.usertoken;
    if (getName() != null){
      setState(() {
        userName = getName();
      });
    }
  }

  void getUserInfo(String user) async {
    if (getName() == null){
      storage.setItem("name", user);
    }
    userName = user;
    var userInfo = await getUserId(user);
    userId = userInfo;
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
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35,
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
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        const Text("What is your Anilist name"),
                                                    actions: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                width: 300,
                                                                height: 50,
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      controller,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 50,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text("Cancel"),
                                                              ),
                                                              const SizedBox(width: 20,),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                  //getUserToken();
                                                                  getUserInfo(controller.text);
                                                                  //Navigator.pushNamed(context, "loginScreen");
                                                                },
                                                                child: const Text("Confirm"),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
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
                      ],
                    )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    border: Border.all(color: Colors.black87),
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("What is you Anilist name?"),
                                actions: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                            width: 300,
                                            height: 50,
                                            child: TextField(
                                              controller: controller,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 50,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          const SizedBox(width: 20,),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              //getUserToken();
                                              getUserInfo(controller.text);
                                              print("name ${getName()}");
                                            },
                                            child: const Text("Confirm"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
                              "Please Login to Anilist  ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.1),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            AnimeButton(
                              text: "Animes",
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, "animeScreen");
                              },
                            ),
                            AnimeButton(
                              text: "Mangas",
                              onTap: () {
                                Navigator.popAndPushNamed(
                                    context, "mangaScreen");
                              },
                            ),
                          ],
                        ),
                        watchingList != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: AnimeWidgetList(
                                  tag: "home-details",
                                  title: "Continue Watching",
                                  animeList: watchingList!,
                                  textColor: Colors.white,
                                  loadMore: false,
                                ),
                              )
                            : const SizedBox(),
                        planningList != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: AnimeWidgetList(
                                  tag: "home-details",
                                  title:
                                      "Why don't you see what you planned! :P",
                                  animeList: planningList!,
                                  textColor: Colors.white,
                                  loadMore: false,
                                ),
                              )
                            : const SizedBox(),
                        pausedList != null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10),
                                child: AnimeWidgetList(
                                  tag: "home-details",
                                  title: "Why don't you resume your animes!",
                                  animeList: pausedList!,
                                  textColor: Colors.white,
                                  loadMore: false,
                                ),
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
