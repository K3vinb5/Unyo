import 'package:unyo/domain/entities/media/manga.dart';
import 'package:unyo/domain/entities/media/manga_details.dart';
import 'package:unyo/domain/entities/user/user.dart';

abstract class MangaRepository {
  Future<(bool, List<Manga>)> getTrendingMangas(int page, User loggedUser, {bool ignoreCache = false});
  Future<(bool, List<Manga>)> getPopularMangas(int page, User loggedUser, {bool ignoreCache = false});
  Future<(bool, List<Manga>)> getRecentlyCompletedMangas(int page, User loggedUser, {bool ignoreCache = false});
  Future<(bool, List<Manga>)> getUpcomingMangas(int page, User loggedUser, {bool ignoreCache = false});
  Future<(bool, MangaDetails)> getMangaDetails(Manga selectedManga, User loggedUser);
  Future<Map<String, (bool, List<String>)>> getUserMangaAdvancedSearchFilters();
  Future<List<Manga>> performMangaAdvancedSearch(
    String query,
    List<String> selectedGenres,
    String? selectedFormat,
    String? selectedCountry,
    String? selectedAiringStatus,
    String sort,
    int page,
    User loggedUser
  );
  Future<List<String>> getMediaCoverImages(User loggedUser, {bool ignoreCache = false});
}