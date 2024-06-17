abstract class MangaSource {
  Future<List<List<String>>> getMangaTitlesAndIds(String query);

  Future<List<String>> getMangaChapterIds(String mangaId);

  Future<List<String>> getMangaChapterPages(String chapterId);

  String getSourceName();
}
