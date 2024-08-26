import 'package:unyo/models/models.dart';

abstract class UserModel {
  String? avatarImage;
  String? bannerImage;
  String? userName;
  int? userId;
 
  //user info
  Future<List<String>> getUserNameAndId();

  Future<String> getUserbannerImageUrl();

  Future<String> getUserAvatarImageUrl();
  //anime info
  Future<List<AnimeModel>> getUserAnimeLists(String listName);

  Future<Map<String, List<AnimeModel>>> getAllUserAnimeLists();

  Future<UserMediaModel?> getUserAnimeInfo(int mediaId);
  //manga info
  Future<List<MangaModel>> getUserMangaLists(String listName);

  Future<Map<String, List<MangaModel>>> getAllUserMangaLists();

  Future<UserMediaModel?> getUserMangaInfo(int mediaId);
  //anime setters
  void setUserAnimeInfo(int mediaId, Map<String, String> receivedQuery,
      {AnimeModel? animeModel});

  void deleteUserAnime(int mediaId);
  //manga setters
  void setUserMangaInfo(int mediaId, Map<String, String> receivedQuery,
      {MangaModel? mangaModel});

  void deleteUserManga(int mediaId);
}
