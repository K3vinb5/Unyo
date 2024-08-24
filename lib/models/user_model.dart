import 'package:unyo/models/models.dart';

abstract class UserModel {
  //user info
  Future<List<String>> getUserNameAndId(String accessToken);

  Future<String> getUserbannerImageUrl(String name);

  Future<String> getUserAvatarImageUrl(String name);
  //anime info
  Future<List<AnimeModel>> getUserAnimeLists(int userId, String listName);

  Future<Map<String, List<AnimeModel>>> getAllUserAnimeLists(int userId);

  Future<UserMediaModel> getUserAnimeInfo(int mediaId);
  //manga info
  Future<List<MangaModel>> getUserMangaLists(int userId, String listName);

  Future<Map<String, List<MangaModel>>> getAllUserMangaLists(int userId);

  Future<UserMediaModel> getUserMangaInfo(int mediaId);
  //anime setters
  void setUserAnimeInfo(int mediaId, Map<String, String> receivedQuery);

  void deleteUserAnime(int mediaId);
  //manga setters
  void setUserMangaInfo(int mediaId, Map<String, String> receivedQuery);

  void deleteUserManga(int mediaId);
}
