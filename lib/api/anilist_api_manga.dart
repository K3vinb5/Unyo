import 'dart:convert';
import 'package:unyo/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/util/constants.dart';

const String anilistEndPointGetToken =
    "https://anilist.co/api/v2/oauth/authorize?client_id=17550&response_type=token";

Future<List<MangaModel>> getMangaModelListTrending(
    int page, int n, int attempt) async {
  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat] \$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id idMal title{userPreferred english romaji}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)chapters duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": page,
      "type": "MANGA",
      "sort": ["TRENDING_DESC", "POPULARITY_DESC"]
    }
  };
  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode == 500) {
    if (attempt < 5) {
      print("mangaModelListTrending : $attempt - failure");
      await Future.delayed(const Duration(milliseconds: 200));
      int newAttempt = attempt + 1;
      return await getMangaModelListTrending(page, n, newAttempt);
    }
    return [];
  } else {
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<MangaModel> list = [];
    for (int i = 0; i < n; i++) {
      Map<String, dynamic> json = media[i];
      // list.add(MangaModel(
      //   id: json["id"],
      //   title: json["title"]["userPreferred"],
      //   coverImage: json["coverImage"]["large"],
      //   bannerImage: json["bannerImage"],
      //   startDate:
      //       "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
      //   endDate:
      //       "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
      //   type: json["type"],
      //   description: json["description"],
      //   status: json["status"],
      //   averageScore: json["averageScore"],
      //   chapters: json["chapters"],
      //   duration: json["duration"],
      //   format: json["format"],
      // ));
      list.add(MangaModel.fromJson(json));
    }
    // print(list);
    return list;
  }
}

Future<List<MangaModel>> getMangaModelListYearlyPopular(
    int page, int year, int attempt, int n) async {
  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int \$id:Int \$type:MediaType \$isAdult:Boolean = false \$search:String \$format:[MediaFormat]\$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source search:\$search onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id idMal title{userPreferred english romaji}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)episodes duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": page,
      "type": "MANGA",
      "year": "${year.toString()}%",
    }
  };

  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode == 500) {
    if (attempt < 5) {
      print("mangaModelListYearlyPopular : $attempt - failure");
      await Future.delayed(const Duration(milliseconds: 200));
      int newAttempt = attempt + 1;
      return await getMangaModelListRecentlyReleased(page, year, newAttempt);
    }
    return [];
  } else {
    print(response.body);
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<MangaModel> list = [];
    for (int i = 0; i < media.length; i++) {
      Map<String, dynamic> json = media[i];
      list.add(MangaModel.fromJson(json));
      // list.add(MangaModel(
      //   id: json["id"],
      //   title: json["title"]["userPreferred"],
      //   coverImage: json["coverImage"]["large"],
      //   bannerImage: json["bannerImage"],
      //   startDate:
      //       "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
      //   endDate:
      //       "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
      //   type: json["type"],
      //   description: json["description"],
      //   status: json["status"],
      //   averageScore: json["averageScore"],
      //   chapters: json["chapters"],
      //   duration: json["duration"],
      //   format: json["format"],
      // ));
    }
    return list;
  }
}

//TODO fix for mangas
Future<List<MangaModel>> getMangaModelListRecentlyReleased(
    int page, int n, int attempt) async {
  Map<String, dynamic> query = {
    "query":
        "query{ Page(page: $page, perPage: $n) { airingSchedules (sort: TIME_DESC, notYetAired: false) {episode media { id idMal title { userPreferred english romaji} coverImage { large } bannerImage format startDate { year month day } endDate { year month day } type description status averageScore episodes duration}}}}"
  };

  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode == 500) {
    if (attempt < 5) {
      print("mangaModelListRecentlyReleased : $attempt - failure");
      await Future.delayed(const Duration(milliseconds: 200));
      int newAttempt = attempt + 1;
      return await getMangaModelListRecentlyReleased(page, n, newAttempt);
    }
    return [];
  } else {
    List<dynamic> media =
        jsonDecode(response.body)["data"]["Page"]["airingSchedules"];
    List<MangaModel> list = [];
    for (int i = 0; i < media.length; i++) {
      var json = media[i]["media"];
      list.add(MangaModel.fromJson(json));
      // list.add(MangaModel(
      //   id: json["id"],
      //   title: json["title"]["userPreferred"],
      //   coverImage: json["coverImage"]["large"],
      //   bannerImage: json["bannerImage"],
      //   startDate:
      //       "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
      //   endDate:
      //       "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
      //   type: json["type"],
      //   status: json["status"],
      //   averageScore: json["averageScore"],
      //   chapters: json["chapters"],
      //   currentEpisode: media[i]["episode"],
      //   duration: json["duration"],
      //   description: json["description"],
      //   format: json["format"],
      // ));
    }
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length - 1; j++) {
        if (list[i].id == list[j].id) {
          list.removeAt(j);
        }
      }
    }
    return list;
  }
}

// Future<List<MangaModel>> getUserMangaLists(
//     int userId, String listName, int attempt) async {
//   var url = Uri.parse(anilistEndpoint);
//   Map<String, dynamic> query = {
//     "query":
//         "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type,sort:UPDATED_TIME_DESC){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id title{userPreferred romaji english native}coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day}}}",
//     "variables": {
//       "userId": userId,
//       "type": "MANGA",
//     }
//   };
//   var response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(query),
//   );
//   if (response.statusCode != 200) {
//     print(response.body);
//     if (attempt < 5) {
//       print("userMangaLists : $attempt - failure");
//       await Future.delayed(const Duration(milliseconds: 200));
//       int newAttempt = attempt + 1;
//       return await getUserMangaLists(userId, listName, newAttempt);
//     }
//     return [];
//   }
//   List<MangaModel> animeModelList = [];
//   Map<String, dynamic> jsonResponse = json.decode(response.body);
//   List<dynamic> animeLists =
//       jsonResponse["data"]["MediaListCollection"]["lists"];
//   for (int i = 0; i < animeLists.length; i++) {
//     if (animeLists[i]["name"] == listName) {
//       List<dynamic> wantedList = animeLists[i]["entries"];
//       for (int i = 0; i < wantedList.length; i++) {
//         animeModelList.add(
//           MangaModel(
//             id: wantedList[i]["media"]["id"],
//             title: wantedList[i]["media"]["title"]["userPreferred"],
//             coverImage: wantedList[i]["media"]["coverImage"]["large"],
//             bannerImage: wantedList[i]["media"]["bannerImage"],
//             startDate:
//                 "${wantedList[i]["media"]["startDate"]["day"]}/${wantedList[i]["media"]["startDate"]["month"]}/${wantedList[i]["media"]["startDate"]["year"]}",
//             endDate: "",
//             //"${wantedList[i]["media"]["endDate"]["day"]}/${wantedList[i]["media"]["endDate"]["month"]}/${wantedList[i]["media"]["endDate"]["year"]}",
//             type: wantedList[i]["media"]["type"],
//             description: wantedList[i]["media"]["description"],
//             status: wantedList[i]["media"]["status"],
//             averageScore: wantedList[i]["media"]["averageScore"],
//             chapters: wantedList[i]["media"]["chapters"],
//             duration: wantedList[i]["media"]["episodes"],
//             format: wantedList[i]["media"]["format"],
//           ),
//         );
//       }
//       break;
//     }
//   }
//   return animeModelList;
// }

// Future<Map<String, List<MangaModel>>> getAllUserMangaLists(
//     int userId, int attempt) async {
//   var url = Uri.parse(anilistEndpoint);
//   Map<String, dynamic> query = {
//     "query":
//         "query(\$userId:Int,\$userName:String,\$type:MediaType){MediaListCollection(userId:\$userId,userName:\$userName,type:\$type){lists{name isCustomList isCompletedList:isSplitCompletedList entries{...mediaListEntry}}user{id name avatar{large}mediaListOptions{scoreFormat rowOrder animeList{sectionOrder customLists splitCompletedSectionByFormat theme}mangaList{sectionOrder customLists splitCompletedSectionByFormat theme}}}}}fragment mediaListEntry on MediaList{id mediaId status score progress progressVolumes repeat priority private hiddenFromStatusLists customLists advancedScores notes updatedAt startedAt{year month day}completedAt{year month day}media{id title{userPreferred romaji english native}coverImage{extraLarge large}type format status(version:2)episodes volumes chapters averageScore  description popularity isAdult countryOfOrigin genres bannerImage startDate{year month day}}}",
//     "variables": {
//       "userId": /*859862*/ userId,
//       "type": "MANGA",
//     }
//   };
//   var response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(query),
//   );
//   if (response.statusCode != 200) {
//     print(response.body);
//     if (attempt < 5) {
//       print("allUserMangaLists : $attempt - failure");
//       await Future.delayed(const Duration(milliseconds: 200));
//       int newAttempt = attempt + 1;
//       return await getAllUserMangaLists(userId, newAttempt);
//     }
//     //NOTE empry Map
//     return {};
//   }
//   Map<String, List<MangaModel>> userMangaListsMap = {};
//   Map<String, dynamic> jsonResponse = json.decode(response.body);
//   List<dynamic> userMangaLists =
//       jsonResponse["data"]["MediaListCollection"]["lists"];
//   for (int i = 0; i < userMangaLists.length; i++) {
//     List<dynamic> currentList = userMangaLists[i]["entries"];
//
//     List<MangaModel> mangaModelList = [];
//
//     for (int j = 0; j < currentList.length; j++) {
//       mangaModelList.add(
//         MangaModel(
//           id: currentList[j]["media"]["id"],
//           title: currentList[j]["media"]["title"]["userPreferred"],
//           coverImage: currentList[j]["media"]["coverImage"]["large"],
//           bannerImage: currentList[j]["media"]["bannerImage"],
//           startDate:
//               "${currentList[j]["media"]["startDate"]["day"]}/${currentList[j]["media"]["startDate"]["month"]}/${currentList[j]["media"]["startDate"]["year"]}",
//           endDate: "",
//           //"${wantedList[i]["media"]["endDate"]["day"]}/${wantedList[i]["media"]["endDate"]["month"]}/${wantedList[i]["media"]["endDate"]["year"]}",
//           type: currentList[j]["media"]["type"],
//           description: currentList[j]["media"]["description"],
//           status: currentList[j]["media"]["status"],
//           averageScore: currentList[j]["media"]["averageScore"],
//           chapters: currentList[j]["media"]["chapters"],
//           duration: currentList[j]["media"]["episodes"],
//           format: currentList[j]["media"]["format"],
//         ),
//       );
//     }
//
//     userMangaListsMap.addAll({userMangaLists[i]["name"]: mangaModelList});
//   }
//   print(userMangaListsMap);
//   return userMangaListsMap;
// }

// Future<UserMediaModel> getUserMangaInfo(int mediaId, int attempt) async {
//   var url = Uri.parse(anilistEndpoint);
//   Map<String, dynamic> query = {
//     "query":
//         "query{ Media(id: $mediaId){ mediaListEntry { score progress repeat priority status startedAt{day month year} completedAt{day month year} } } }",
//   };
//   var response = await http.post(
//     url,
//     headers: {
//       "Authorization": "Bearer $accessToken",
//       "Content-Type": "application/json",
//     },
//     body: json.encode(query),
//   );
//   if (response.statusCode != 200) {
//     if (attempt < 5) {
//       print("userMangaInfo : $attempt - failure");
//       await Future.delayed(const Duration(milliseconds: 200));
//       int newAttempt = attempt + 1;
//       return getUserMangaInfo(mediaId, newAttempt);
//     }
//   }
//   Map<String, dynamic> jsonResponse = json.decode(response.body);
//   if (jsonResponse["data"]["Media"]["mediaListEntry"] == null) {
//     return UserMediaModel(
//       score: 0,
//       progress: 0,
//       repeat: 0,
//       priority: 0,
//       status: "",
//       startDate: "~/~/~",
//       endDate: "~/~/~",
//     );
//   }
//   Map<String, dynamic> mediaListEntry =
//       jsonResponse["data"]["Media"]["mediaListEntry"];
//   return UserMediaModel(
//     score: mediaListEntry["score"],
//     progress: mediaListEntry["progress"],
//     repeat: mediaListEntry["repeat"],
//     priority: mediaListEntry["priority"],
//     status: mediaListEntry["status"],
//     startDate:
//         "${mediaListEntry["startedAt"]["day"]}/${mediaListEntry["startedAt"]["month"]}/${mediaListEntry["startedAt"]["year"]}",
//     endDate:
//         "${mediaListEntry["completedAt"]["day"]}/${mediaListEntry["completedAt"]["month"]}/${mediaListEntry["completedAt"]["year"]}",
//   );
// }

// void deleteUserManga(int mediaId) async {
//   var url = Uri.parse(anilistEndpoint);
//
//   Map<String, dynamic> query1 = {
//     "query": "query(\$mediaId:Int){ MediaList(mediaId:\$mediaId){ id } }",
//     "variables": {
//       "mediaId": mediaId,
//     },
//   };
//   var response1 = await http.post(
//     url,
//     headers: {
//       "Authorization": "Bearer $accessToken",
//       "Content-Type": "application/json",
//     },
//     body: json.encode(query1),
//   );
//
//   int entryId = jsonDecode(response1.body)["data"]["MediaList"]["id"];
//
//   Map<String, dynamic> query = {
//     "query":
//         "mutation (\$entryId: Int) {DeleteMediaListEntry(id: \$entryId){ deleted }}",
//     "variables": {
//       "entryId": entryId,
//     },
//   };
//   var response = await http.post(
//     url,
//     headers: {
//       "Authorization": "Bearer $accessToken",
//       "Content-Type": "application/json",
//     },
//     body: json.encode(query),
//   );
//   print(response.body);
// }
//
// void setUserMangaInfo(int mediaId, Map<String, String> receivedQuery) async {
//   var url = Uri.parse(anilistEndpoint);
//   Map<String, dynamic> query = {
//     "query":
//         "mutation (\$mediaId: Int, \$status: MediaListStatus, \$score: Float, \$progress: Int, \$startedAt: FuzzyDateInput, \$completedAt: FuzzyDateInput) { SaveMediaListEntry(mediaId: \$mediaId, status: \$status, score: \$score, progress: \$progress, startedAt: \$startedAt, completedAt: \$completedAt) { mediaId status score progress startedAt { year month day } completedAt { year month day } } } ",
//     "variables": {
//       "mediaId": mediaId,
//       "status": receivedQuery["status"],
//       "score": double.parse(receivedQuery["score"]!),
//       "progress": int.parse(receivedQuery["progress"]!),
//       "startedAt": {
//         "day": receivedQuery["startDateDay"],
//         "month": receivedQuery["startDateMonth"],
//         "year": receivedQuery["startDateYear"]
//       },
//       "completedAt": {
//         "day": receivedQuery["endDateDay"],
//         "month": receivedQuery["endDateMonth"],
//         "year": receivedQuery["endDateYear"]
//       },
//     },
//   };
//   var response = await http.post(
//     url,
//     headers: {
//       "Authorization": "Bearer $accessToken",
//       "Content-Type": "application/json",
//     },
//     body: json.encode(query),
//   );
//   print(response.body);
// }

Future<List<MangaModel>> getMangaModelListSearch(
  String search,
  String sort,
  String format,
  String status,
  String country,
  String genre,
  int n)
  async {
  String finalSearch = search.isNotEmpty ? "search:\"$search\"" : "";
  
  String? countryFilter;
  if (country != "Select Country") {
    switch (country) {
      case 'Japan':
        countryFilter = 'JP';
        break;
      case 'Taiwan':
        countryFilter = 'TW';
        break;
      case 'South Korea':
        countryFilter = 'KR';
        break;
      case 'China':
        countryFilter = 'CN';
        break;
      default:
        countryFilter = country.toUpperCase();
    }
  }

  Map<String, dynamic> query = {
    "query":
        "query(\$page:Int = 1 \$id:Int \$type:MediaType \$isAdult:Boolean = false \$format:[MediaFormat] \$status:MediaStatus \$countryOfOrigin:CountryCode \$source:MediaSource \$season:MediaSeason \$seasonYear:Int \$year:String \$onList:Boolean \$yearLesser:FuzzyDateInt \$yearGreater:FuzzyDateInt \$episodeLesser:Int \$episodeGreater:Int \$durationLesser:Int \$durationGreater:Int \$chapterLesser:Int \$chapterGreater:Int \$volumeLesser:Int \$volumeGreater:Int \$licensedBy:[Int]\$isLicensed:Boolean \$genres:[String]\$excludedGenres:[String]\$tags:[String]\$excludedTags:[String]\$minimumTagRank:Int \$sort:[MediaSort]=[POPULARITY_DESC,SCORE_DESC]){Page(page:\$page,perPage:$n){pageInfo{total perPage currentPage lastPage hasNextPage}media(id:\$id type:\$type season:\$season format_in:\$format status:\$status countryOfOrigin:\$countryOfOrigin source:\$source $finalSearch onList:\$onList seasonYear:\$seasonYear startDate_like:\$year startDate_lesser:\$yearLesser startDate_greater:\$yearGreater episodes_lesser:\$episodeLesser episodes_greater:\$episodeGreater duration_lesser:\$durationLesser duration_greater:\$durationGreater chapters_lesser:\$chapterLesser chapters_greater:\$chapterGreater volumes_lesser:\$volumeLesser volumes_greater:\$volumeGreater licensedById_in:\$licensedBy isLicensed:\$isLicensed genre_in:\$genres genre_not_in:\$excludedGenres tag_in:\$tags tag_not_in:\$excludedTags minimumTagRank:\$minimumTagRank sort:\$sort isAdult:\$isAdult){id idMal title{userPreferred english romaji}coverImage{extraLarge large color}startDate{year month day}endDate{year month day}bannerImage season seasonYear description type format status(version:2)episodes duration chapters volumes genres isAdult averageScore popularity nextAiringEpisode{airingAt timeUntilAiring episode}mediaListEntry{id status}studios(isMain:true){edges{isMain node{id name}}}}}}",
    "variables": {
      "page": 1,
      "type": "MANGA",
      if (sort == "Select Sorting")
        "sort": "SEARCH_MATCH"
      else if (sort == "A-Z") 
        "sort": "TITLE_ENGLISH"
      else if (sort == "Z-A")
        "sort": "TITLE_ENGLISH_DESC"
      else
        "sort": sort.toUpperCase(),
      if (format != "Select Format") "format": [format.toUpperCase().replaceAll(' ', '_')],
      if (genre != "Select Genre") "genres": [genre],
      if (status != "Select Status") "status": status.toUpperCase().replaceAll(' ', '_'),
      if (countryFilter != null)  "countryOfOrigin": countryFilter,
    }
  };

  var url = Uri.parse(anilistEndpoint);
  var response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(query),
  );
  if (response.statusCode != 200) {
    print("ERROR:\n${response.statusCode}\n${response.body}");
    return [];
  } else {
    List<dynamic> media = jsonDecode(response.body)["data"]["Page"]["media"];
    List<MangaModel> list = [];
    for (int i = 0; i < media.length; i++) {
      Map<String, dynamic> json = media[i];
      list.add(MangaModel.fromJson(json));
      // list.add(MangaModel(
      //   id: json["id"],
      //   title: json["title"]["userPreferred"],
      //   coverImage: json["coverImage"]["large"],
      //   bannerImage: json["bannerImage"],
      //   startDate:
      //       "${json["startDate"]["day"]}/${json["startDate"]["month"]}/${json["startDate"]["year"]}",
      //   endDate:
      //       "${json["endDate"]["day"]}/${json["endDate"]["month"]}/${json["endDate"]["year"]}",
      //   type: json["type"],
      //   description: json["description"],
      //   status: json["status"],
      //   averageScore: json["averageScore"],
      //   chapters: json["chapters"],
      //   duration: json["duration"],
      //   format: json["format"],
      // ));
    }
    print(list.length);
    if ((sort != "Select Sorting")) {
      return list.reversed.toList();
    }
    return list;
  }
}
