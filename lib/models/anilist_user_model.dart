import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unyo/models/models.dart';
import 'package:unyo/util/constants.dart';

class AnilistUserModel implements UserModel{
  final String anilistEndpoint = "https://graphql.anilist.co";
  final maxAttempts = 5;

  @override
  Future<List<String>> getUserNameAndId(String accessToken,
      {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;
    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query": "query {Viewer{name id}}",
    };
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      print(response.body);
      if (attempt < maxAttempts) {
        int newAttempt = attempt + 1;
        return getUserNameAndId(accessToken, newAttempt: newAttempt);
      }
    }
    print(response.body);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return [
      jsonResponse["data"]["Viewer"]["name"],
      jsonResponse["data"]["Viewer"]["id"].toString()
    ];
  }

  @override
  Future<String> getUserbannerImageUrl(String name, {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;

    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query (\$id: Int \$name: String){User(id: \$id, name: \$name){bannerImage}}",
      "variables": {
        "name": name,
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 200));
      print("User banner image: $attempt - failure");
      if (attempt < maxAttempts) {
        int newAttempt = attempt + 1;
        String returnString =
            await getUserbannerImageUrl(name, newAttempt: newAttempt);
        return returnString;
      }
      return "https://i.imgur.com/x6TGK1x.png";
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse["data"]["User"]["bannerImage"];
  }

  @override
  Future<String> getUserAvatarImageUrl(String name, {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;

    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query (\$id: Int \$name: String){User(id: \$id, name: \$name){avatar {medium}}}",
      "variables": {
        "name": name,
      }
    };

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 200));
      print("User avatar image: $attempt - failure");
      if (attempt < maxAttempts) {
        int newAttempt = attempt + 1;
        String returnString =
            await getUserAvatarImageUrl(name, newAttempt: newAttempt);
        return returnString;
      }
      return "https://i.imgur.com/EKtChtm.png";
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    try {
      String returnString = jsonResponse["data"]["User"]["avatar"]["medium"];
      return returnString;
    } catch (e) {
      return "https://i.imgur.com/EKtChtm.png";
    }
  }

  @override
  Future<List<AnimeModel>> getUserAnimeLists(int userId, String listName,
      {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;

    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type,sort:UPDATED_TIME_DESC){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id idMal title{userPreferred romaji english}coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day} endDate{year month day}}}",
      "variables": {
        "userId": userId,
        "type": "ANIME",
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 200));
      print("User anime list $listName : $attempt - failure");
      if (attempt < maxAttempts) {
        int newAttempt = attempt + 1;
        return await getUserAnimeLists(userId, listName,
            newAttempt: newAttempt);
      }
      return [];
    }
    List<AnimeModel> animeModelList = [];
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> animeLists =
        jsonResponse["data"]["MediaListCollection"]["lists"];
    for (int i = 0; i < animeLists.length; i++) {
      if (animeLists[i]["name"] == listName) {
        List<dynamic> wantedList = animeLists[i]["entries"];
        for (int i = 0; i < wantedList.length; i++) {
          Map<String, dynamic> json = wantedList[i]["media"];

          animeModelList.add(AnimeModel.fromJson(json));
        }
        break;
      }
    }
    return animeModelList;
  }

  @override
  Future<Map<String, List<AnimeModel>>> getAllUserAnimeLists(int userId,
      {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;

    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id idMal title{userPreferred romaji english }coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day} endDate{day month year}}}",
      "variables": {
        "userId": userId,
        "type": "ANIME",
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 200));
      print("All user anime lists: $attempt - failure");
      if (attempt < maxAttempts) {
        int newAttempt = attempt + 1;
        return await getAllUserAnimeLists(userId, newAttempt: newAttempt);
      }
      //NOTE empry Map
      return {};
    }
    Map<String, List<AnimeModel>> userAnimeListsMap = {};
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> userAnimeLists =
        jsonResponse["data"]["MediaListCollection"]["lists"];
    for (int i = 0; i < userAnimeLists.length; i++) {
      List<dynamic> currentList = userAnimeLists[i]["entries"];

      List<AnimeModel> animeModelList = [];

      for (int j = 0; j < currentList.length; j++) {
        Map<String, dynamic> json = currentList[j]["media"];

        animeModelList.add(AnimeModel.fromJson(json));
      }

      userAnimeListsMap.addAll({userAnimeLists[i]["name"]: animeModelList});
    }
    return userAnimeListsMap;
  }

  @override
  Future<UserMediaModel> getUserAnimeInfo(int mediaId,
      {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;

    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query{ Media(id: $mediaId){ mediaListEntry { score progress repeat priority status startedAt{day month year} completedAt{day month year} } } }",
    };
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      await Future.delayed(const Duration(milliseconds: 200));
      print("User anime info: $attempt - failure");
      if (attempt < maxAttempts) {
        int newAttempt = attempt + 1;
        return getUserAnimeInfo(mediaId, newAttempt: newAttempt);
      }
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse["data"]["Media"]["mediaListEntry"] == null) {
      return UserMediaModel(
        score: 0,
        progress: 0,
        repeat: 0,
        priority: 0,
        status: "",
        startDate: "~/~/~",
        endDate: "~/~/~",
      );
    }
    Map<String, dynamic> mediaListEntry =
        jsonResponse["data"]["Media"]["mediaListEntry"];
    return UserMediaModel(
      score: mediaListEntry["score"],
      progress: mediaListEntry["progress"],
      repeat: mediaListEntry["repeat"],
      priority: mediaListEntry["priority"],
      status: mediaListEntry["status"],
      startDate:
          "${mediaListEntry["startedAt"]["day"]}/${mediaListEntry["startedAt"]["month"]}/${mediaListEntry["startedAt"]["year"]}",
      endDate:
          "${mediaListEntry["completedAt"]["day"]}/${mediaListEntry["completedAt"]["month"]}/${mediaListEntry["completedAt"]["year"]}",
    );
  }

  @override
  Future<List<MangaModel>> getUserMangaLists(
      int userId, String listName, {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;
    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type,sort:UPDATED_TIME_DESC){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id title{userPreferred romaji english native}coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day}}}",
      "variables": {
        "userId": userId,
        "type": "MANGA",
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      print(response.body);
      if (attempt < 5) {
        print("userMangaLists : $attempt - failure");
        await Future.delayed(const Duration(milliseconds: 200));
        int newAttempt = attempt + 1;
        return await getUserMangaLists(userId, listName, newAttempt: newAttempt);
      }
      return [];
    }
    List<MangaModel> animeModelList = [];
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> animeLists =
        jsonResponse["data"]["MediaListCollection"]["lists"];
    for (int i = 0; i < animeLists.length; i++) {
      if (animeLists[i]["name"] == listName) {
        List<dynamic> wantedList = animeLists[i]["entries"];
        for (int i = 0; i < wantedList.length; i++) {
          animeModelList.add(
            MangaModel(
              id: wantedList[i]["media"]["id"],
              title: wantedList[i]["media"]["title"]["userPreferred"],
              coverImage: wantedList[i]["media"]["coverImage"]["large"],
              bannerImage: wantedList[i]["media"]["bannerImage"],
              startDate:
                  "${wantedList[i]["media"]["startDate"]["day"]}/${wantedList[i]["media"]["startDate"]["month"]}/${wantedList[i]["media"]["startDate"]["year"]}",
              endDate: "",
              //"${wantedList[i]["media"]["endDate"]["day"]}/${wantedList[i]["media"]["endDate"]["month"]}/${wantedList[i]["media"]["endDate"]["year"]}",
              type: wantedList[i]["media"]["type"],
              description: wantedList[i]["media"]["description"],
              status: wantedList[i]["media"]["status"],
              averageScore: wantedList[i]["media"]["averageScore"],
              chapters: wantedList[i]["media"]["chapters"],
              duration: wantedList[i]["media"]["episodes"],
              format: wantedList[i]["media"]["format"],
            ),
          );
        }
        break;
      }
    }
    return animeModelList;
  }

  @override
  Future<Map<String, List<MangaModel>>> getAllUserMangaLists(
      int userId, {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;
    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id title{userPreferred romaji english native}coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day}}}",
      "variables": {
        "userId": /*859862*/ userId,
        "type": "MANGA",
      }
    };
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      print(response.body);
      if (attempt < 5) {
        print("allUserMangaLists : $attempt - failure");
        await Future.delayed(const Duration(milliseconds: 200));
        int newAttempt = attempt + 1;
        return await getAllUserMangaLists(userId, newAttempt: newAttempt);
      }
      //NOTE empry Map
      return {};
    }
    Map<String, List<MangaModel>> userMangaListsMap = {};
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> userMangaLists =
        jsonResponse["data"]["MediaListCollection"]["lists"];
    for (int i = 0; i < userMangaLists.length; i++) {
      List<dynamic> currentList = userMangaLists[i]["entries"];

      List<MangaModel> mangaModelList = [];

      for (int j = 0; j < currentList.length; j++) {
        mangaModelList.add(
          MangaModel(
            id: currentList[j]["media"]["id"],
            title: currentList[j]["media"]["title"]["userPreferred"],
            coverImage: currentList[j]["media"]["coverImage"]["large"],
            bannerImage: currentList[j]["media"]["bannerImage"],
            startDate:
                "${currentList[j]["media"]["startDate"]["day"]}/${currentList[j]["media"]["startDate"]["month"]}/${currentList[j]["media"]["startDate"]["year"]}",
            endDate: "",
            //"${wantedList[i]["media"]["endDate"]["day"]}/${wantedList[i]["media"]["endDate"]["month"]}/${wantedList[i]["media"]["endDate"]["year"]}",
            type: currentList[j]["media"]["type"],
            description: currentList[j]["media"]["description"],
            status: currentList[j]["media"]["status"],
            averageScore: currentList[j]["media"]["averageScore"],
            chapters: currentList[j]["media"]["chapters"],
            duration: currentList[j]["media"]["episodes"],
            format: currentList[j]["media"]["format"],
          ),
        );
      }

      userMangaListsMap.addAll({userMangaLists[i]["name"]: mangaModelList});
    }
    print(userMangaListsMap);
    return userMangaListsMap;
  }

  @override
  Future<UserMediaModel> getUserMangaInfo(int mediaId, {int? newAttempt}) async {
    int attempt = newAttempt ?? 0;
    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "query{ Media(id: $mediaId){ mediaListEntry { score progress repeat priority status startedAt{day month year} completedAt{day month year} } } }",
    };
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query),
    );
    if (response.statusCode != 200) {
      if (attempt < 5) {
        print("userMangaInfo : $attempt - failure");
        await Future.delayed(const Duration(milliseconds: 200));
        int newAttempt = attempt + 1;
        return getUserMangaInfo(mediaId, newAttempt: newAttempt);
      }
    }
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse["data"]["Media"]["mediaListEntry"] == null) {
      return UserMediaModel(
        score: 0,
        progress: 0,
        repeat: 0,
        priority: 0,
        status: "",
        startDate: "~/~/~",
        endDate: "~/~/~",
      );
    }
    Map<String, dynamic> mediaListEntry =
        jsonResponse["data"]["Media"]["mediaListEntry"];
    return UserMediaModel(
      score: mediaListEntry["score"],
      progress: mediaListEntry["progress"],
      repeat: mediaListEntry["repeat"],
      priority: mediaListEntry["priority"],
      status: mediaListEntry["status"],
      startDate:
          "${mediaListEntry["startedAt"]["day"]}/${mediaListEntry["startedAt"]["month"]}/${mediaListEntry["startedAt"]["year"]}",
      endDate:
          "${mediaListEntry["completedAt"]["day"]}/${mediaListEntry["completedAt"]["month"]}/${mediaListEntry["completedAt"]["year"]}",
    );
  }

  @override
  void setUserAnimeInfo(int mediaId, Map<String, String> receivedQuery) async {
    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "mutation (\$mediaId: Int, \$status: MediaListStatus, \$score: Float, \$progress: Int, \$startedAt: FuzzyDateInput, \$completedAt: FuzzyDateInput) { SaveMediaListEntry(mediaId: \$mediaId, status: \$status, score: \$score, progress: \$progress, startedAt: \$startedAt, completedAt: \$completedAt) { mediaId status score progress startedAt { year month day } completedAt { year month day } } } ",
      "variables": {
        "mediaId": mediaId,
        "status": receivedQuery["status"],
        "score": double.parse(receivedQuery["score"]!),
        "progress": int.parse(receivedQuery["progress"]!),
        "startedAt": {
          "day": receivedQuery["startDateDay"],
          "month": receivedQuery["startDateMonth"],
          "year": receivedQuery["startDateYear"]
        },
        "completedAt": {
          "day": receivedQuery["endDateDay"],
          "month": receivedQuery["endDateMonth"],
          "year": receivedQuery["endDateYear"]
        },
      },
    };
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query),
    );
    print(response.body);
  }

  @override
  void deleteUserAnime(int mediaId) async {
    var url = Uri.parse(anilistEndpoint);

    Map<String, dynamic> query1 = {
      "query": "query(\$mediaId:Int){ MediaList(mediaId:\$mediaId){ id } }",
      "variables": {
        "mediaId": mediaId,
      },
    };
    var response1 = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query1),
    );

    int entryId = jsonDecode(response1.body)["data"]["MediaList"]["id"];

    Map<String, dynamic> query = {
      "query":
          "mutation (\$entryId: Int) {DeleteMediaListEntry(id: \$entryId){ deleted }}",
      "variables": {
        "entryId": entryId,
      },
    };
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query),
    );
    print(response.body);
  }

  @override
  void deleteUserManga(int mediaId) async {
    var url = Uri.parse(anilistEndpoint);

    Map<String, dynamic> query1 = {
      "query": "query(\$mediaId:Int){ MediaList(mediaId:\$mediaId){ id } }",
      "variables": {
        "mediaId": mediaId,
      },
    };
    var response1 = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query1),
    );

    int entryId = jsonDecode(response1.body)["data"]["MediaList"]["id"];

    Map<String, dynamic> query = {
      "query":
          "mutation (\$entryId: Int) {DeleteMediaListEntry(id: \$entryId){ deleted }}",
      "variables": {
        "entryId": entryId,
      },
    };
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query),
    );
    print(response.body);
  }

  @override
  void setUserMangaInfo(int mediaId, Map<String, String> receivedQuery) async {
    var url = Uri.parse(anilistEndpoint);
    Map<String, dynamic> query = {
      "query":
          "mutation (\$mediaId: Int, \$status: MediaListStatus, \$score: Float, \$progress: Int, \$startedAt: FuzzyDateInput, \$completedAt: FuzzyDateInput) { SaveMediaListEntry(mediaId: \$mediaId, status: \$status, score: \$score, progress: \$progress, startedAt: \$startedAt, completedAt: \$completedAt) { mediaId status score progress startedAt { year month day } completedAt { year month day } } } ",
      "variables": {
        "mediaId": mediaId,
        "status": receivedQuery["status"],
        "score": double.parse(receivedQuery["score"]!),
        "progress": int.parse(receivedQuery["progress"]!),
        "startedAt": {
          "day": receivedQuery["startDateDay"],
          "month": receivedQuery["startDateMonth"],
          "year": receivedQuery["startDateYear"]
        },
        "completedAt": {
          "day": receivedQuery["endDateDay"],
          "month": receivedQuery["endDateMonth"],
          "year": receivedQuery["endDateYear"]
        },
      },
    };
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: json.encode(query),
    );
    print(response.body);
  }
}
