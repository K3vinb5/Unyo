import 'package:unyo/models/models.dart';
import 'package:unyo/util/constants.dart';

class LocalUserModel implements UserModel {
  @override
  String? avatarImage;
  @override
  String? bannerImage;
  @override
  int? userId;
  @override
  String? userName;

  LocalUserModel(
      {this.avatarImage, this.bannerImage, this.userName, this.userId});

  @override
  void deleteUserAnime(int mediaId) {
    prefs.box.put(mediaId, null);
  }

  @override
  void deleteUserManga(int mediaId) {
    prefs.box.put(mediaId, null);
  }

  @override
  Future<Map<String, List<AnimeModel>>> getAllUserAnimeLists() async {
    return (prefs.box.get("allUserAnimeLists") as Map<dynamic, dynamic>?)?.map(
            (key, value) =>
                MapEntry(key as String, (value as List).cast<AnimeModel>())) ??
        {};
  }

  @override
  Future<Map<String, List<MangaModel>>> getAllUserMangaLists() async {
    return (prefs.box.get("allUserMangaLists") as Map<dynamic, dynamic>?)?.map(
            (key, value) =>
                MapEntry(key as String, (value as List).cast<MangaModel>())) ??
        {};
  }

  @override
  Future<UserMediaModel?> getUserAnimeInfo(int mediaId) async {
    return prefs.box.get("userAnimeInfo-$mediaId") as UserMediaModel? ??
        UserMediaModel(
            score: 0,
            progress: 0,
            repeat: null,
            priority: null,
            status: "NOT SET",
            startDate: null,
            endDate: null);
  }

  @override
  Future<List<AnimeModel>> getUserAnimeLists(String listName) async {
    return (prefs.box.get("allUserAnimeLists")?[listName] as List<dynamic>?)
            ?.map((e) => e as AnimeModel)
            .toList() ??
        [];
  }

  @override
  Future<String> getUserAvatarImageUrl() async {
    // return prefs.box.get("avatarImageUrl") as String;
    avatarImage ??= "https://i.imgur.com/EKtChtm.png";
    return "https://i.imgur.com/EKtChtm.png";
  }

  @override
  Future<UserMediaModel?> getUserMangaInfo(int mediaId) async {
    return prefs.box.get("userMangaInfo-$mediaId") as UserMediaModel? ??
        UserMediaModel(
            score: 0,
            progress: 0,
            repeat: null,
            priority: null,
            status: "NOT SET",
            startDate: null,
            endDate: null);

  }

  @override
  Future<List<MangaModel>> getUserMangaLists(String listName) async {
    return (prefs.box.get("allUserMangaLists")?[listName] as List<dynamic>?)
            ?.map((e) => e as MangaModel)
            .toList() ??
        [];
  }

  @override
  Future<List<String>> getUserNameAndId() async {
    if (userName != null && userId != null) {
      return [userName!, userId!.toString()];
    }
    userName = prefs.box.get("userName") as String?;
    userId = prefs.box.get("userId") as int?;
    return [prefs.box.get("userName") as String, ""];
  }

  @override
  Future<String> getUserbannerImageUrl() async {
    // return prefs.box.get("userBannerImage") as String;
    bannerImage ??= "https://i.imgur.com/x6TGK1x.png";
    return "https://i.imgur.com/x6TGK1x.png";
  }

  @override
  void setUserAnimeInfo(int mediaId, Map<String, String> receivedQuery,
      {AnimeModel? animeModel}) {
    UserMediaModel userMediaModel = UserMediaModel(
      score: double.parse(receivedQuery["score"]!),
      progress: int.parse(receivedQuery["progress"]!),
      repeat: null,
      priority: null,
      status: receivedQuery["status"],
      startDate:
          "${receivedQuery["startDateDay"]}/${receivedQuery["startDateMonth"]}/${receivedQuery["startDateYear"]}",
      endDate:
          "${receivedQuery["endDateDay"]}/${receivedQuery["endDateMonth"]}/${receivedQuery["endDateYear"]}",
    );
    prefs.box.put("userAnimeInfo-$mediaId", userMediaModel);
    Map<String, List<AnimeModel>>? userAnimeLists = (prefs.box
                .get("allUserAnimeLists") as Map<dynamic, dynamic>?)
            ?.map((key, value) =>
                MapEntry(key as String, (value as List).cast<AnimeModel>())) ??
        {};

    for (var animeModelList in userAnimeLists.values) {
      animeModelList.remove(animeModel);
    }

    switch (receivedQuery["status"]) {
      case "CURRENT":
        // if (userAnimeLists["Watching"] == null){
        // userAnimeLists["Watching"] = [];
        // }
        userAnimeLists["Watching"] ??= [];
        userAnimeLists["Watching"]!.add(animeModel!);
        break;
      case "COMPLETED":
        userAnimeLists["Completed"] ??= [];
        userAnimeLists["Completed"]!.add(animeModel!);
        break;
      case "PLANNING":
        userAnimeLists["Planning"] ??= [];
        userAnimeLists["Planning"]!.add(animeModel!);
        break;
      case "PAUSED":
        userAnimeLists["Paused"] ??= [];
        userAnimeLists["Paused"]!.add(animeModel!);
        break;
      case "DROPPED":
        userAnimeLists["Dropped"] ??= [];
        userAnimeLists["Dropped"]!.add(animeModel!);
        break;
      default:
    }

    prefs.box.put("allUserAnimeLists", userAnimeLists);
  }

  @override
  void setUserMangaInfo(int mediaId, Map<String, String> receivedQuery,
      {MangaModel? mangaModel}) {
    UserMediaModel userMediaModel = UserMediaModel(
      score: double.parse(receivedQuery["score"]!),
      progress: int.parse(receivedQuery["progress"]!),
      repeat: null,
      priority: null,
      status: receivedQuery["status"],
      startDate:
          "${receivedQuery["startDateDay"]}/${receivedQuery["startDateMonth"]}/${receivedQuery["startDateYear"]}",
      endDate:
          "${receivedQuery["endDateDay"]}/${receivedQuery["endDateMonth"]}/${receivedQuery["endDateYear"]}",
    );
    prefs.box.put("userMangaInfo-$mediaId", userMediaModel);
    Map<String, List<MangaModel>>? userMangaLists = (prefs.box
                .get("allUserMangaLists") as Map<dynamic, dynamic>?)
            ?.map((key, value) =>
                MapEntry(key as String, (value as List).cast<MangaModel>())) ??
        {};

    for (var mangaModelList in userMangaLists.values) {
      mangaModelList.remove(mangaModel!);
    }

    switch (receivedQuery["status"]) {
      case "CURRENT":
        // if (userMangaLists["Watching"] == null){
        // userMangaLists["Watching"] = [];
        // }
        print("added");
        userMangaLists["Reading"] ??= [];
        userMangaLists["Reading"]!.add(mangaModel!);
        print(userMangaLists["Reading"]);
        break;
      case "COMPLETED":
        userMangaLists["Completed"] ??= [];
        userMangaLists["Completed"]!.add(mangaModel!);
        break;
      case "PLANNING":
        userMangaLists["Planning"] ??= [];
        userMangaLists["Planning"]!.add(mangaModel!);
        break;
      case "PAUSED":
        userMangaLists["Paused"] ??= [];
        userMangaLists["Paused"]!.add(mangaModel!);
        break;
      case "DROPPED":
        userMangaLists["Dropped"] ??= [];
        userMangaLists["Dropped"]!.add(mangaModel!);
        break;
      default:
    }

    prefs.box.put("allUserMangaLists", userMangaLists);
  }
}
