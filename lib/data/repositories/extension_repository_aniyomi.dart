import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:unyo_lib/aniyomi_bridge.dart';
import 'package:unyo_lib/jmodels/jpage.dart';
import 'package:unyo_lib/jmodels/jsanime.dart';
import 'package:unyo_lib/jmodels/jschapter.dart';
import 'package:unyo_lib/jmodels/jsepisode.dart';
import 'package:unyo_lib/jmodels/jsmanga.dart';
import 'package:unyo_lib/jmodels/jvideo.dart';
import 'package:logger/logger.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/enums/extension_type.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/core/services/api/dto/extensions/aniyomi_repo_json_entity.dart';
import 'package:unyo/core/services/api/dto/extensions/tachiyomi_repo_json_entity.dart';
import 'package:unyo/core/services/api/http/api_response.dart';
import 'package:unyo/core/services/api/http/http_service.dart';
import 'package:unyo/data/models/anilist_user_model.dart';
import 'package:unyo/data/models/local_user_model.dart';
import 'package:unyo/data/repositories/user_repository_anilist.dart';
import 'package:unyo/domain/entities/extension.dart';
import 'package:unyo/domain/entities/settings.dart';
import 'package:unyo/domain/entities/user.dart';
import 'package:unyo/domain/repositories/extension_repository.dart';

class ExtensionRepositoryAniyomi implements ExtensionRepository {
  // Services
  final Logger _logger = sl<Logger>();
  final HttpService _httpService = sl<HttpService>();
  final AniyomiBridge _aniyomiBridge = sl<AniyomiBridge>();
  // Boxes
  late Box<Extension> _aniyomiExtensionsBox;
  // Repositories
  final UserRepositoryAnilist _userRepositoryAnilist;
  // Notifiers
  final UserNotifier _loggedUserNotifier;
  late StreamSubscription<User> _loggedUserSubscription;

  ExtensionRepositoryAniyomi(this._userRepositoryAnilist, this._loggedUserNotifier) {
    _init();
  }

  Future<void> _init() async {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) async {
        _loadInstalledAnimeExtensions(loggedUser);
        _loadInstalledMangaExtensions(loggedUser);
        _closeLoggedUserSubscription();
    });
  }

  @override
  Future<Set<Extension>> getAvailableAnimeExtensions(User user) async {
    _logger.d("Fetching available anime extensions for AniyomiBridge.");
    final String aniyomiExtensionsRepositoryUrl = user.settings.aniyomiExtensionsRepositoryUrl;
    ApiResponse<List<AniyomiRepoJsonEntity>> repositoryResponse = await _httpService.get(
      aniyomiExtensionsRepositoryUrl,
      fromJson: _parseAniyomiRepoJsonList,
    );
    return repositoryResponse.data
        .map(
          (aniyomiRepoJsonEntity) => ExtensionModel(
            name: aniyomiRepoJsonEntity.name.replaceFirst("Aniyomi: ", ""),
            pkg: aniyomiRepoJsonEntity.pkg,
            apk:
                "${aniyomiExtensionsRepositoryUrl.replaceFirst("index.min.json", "apk/")}${aniyomiRepoJsonEntity.apk}",
            icon:
                "${aniyomiExtensionsRepositoryUrl.replaceFirst("index.min.json", "icon/")}${aniyomiRepoJsonEntity.pkg}.png",
            lang: aniyomiRepoJsonEntity.lang,
            version: aniyomiRepoJsonEntity.version,
            nsfw: aniyomiRepoJsonEntity.nsfw.toInt(),
            type: ExtensionType.ANIYOMI,
          ),
        )
        .toSet()
        .difference(await getInstalledAnimeExtensions(user));
  }

  @override
  Future<Set<Extension>> getAvailableMangaExtensions(User user) async {
    _logger.i("Fetching available manga extensions for AniyomiBridge.");
    final String tachiyomiExtensionsRepositoryUrl = user.settings.tachiyomiExtensionsRepositoryUrl;
    ApiResponse<List<TachiyomiRepoJsonEntity>> repositoryResponse = await _httpService.get(
      tachiyomiExtensionsRepositoryUrl,
      fromJson: _parseTachiyomiRepoJsonList,
    );
    return repositoryResponse.data
        .map(
          (tachiyomiRepoJsonEntity) => ExtensionModel(
            name: tachiyomiRepoJsonEntity.name.replaceFirst("Tachiyomi: ", ""),
            pkg: tachiyomiRepoJsonEntity.pkg,
            apk:
                "${tachiyomiExtensionsRepositoryUrl.replaceFirst("index.min.json", "apk/")}${tachiyomiRepoJsonEntity.apk}",
            icon:
                "${tachiyomiExtensionsRepositoryUrl.replaceFirst("index.min.json", "icon/")}${tachiyomiRepoJsonEntity.pkg}.png",
            lang: tachiyomiRepoJsonEntity.lang,
            version: tachiyomiRepoJsonEntity.version,
            nsfw: tachiyomiRepoJsonEntity.nsfw.toInt(),
            type: ExtensionType.TACHIYOMI,
          ),
        )
        .toSet()
        .difference(await getInstalledMangaExtensions(user));
  }

  @override
  Future<Set<Extension>> getInstalledAnimeExtensions(User user) async {
    _aniyomiExtensionsBox = await Hive.openBox<Extension>('aniyomiExtensions');
    return _aniyomiExtensionsBox.values.where((extension) => extension.type == ExtensionType.ANIYOMI).toSet();
  }

  @override
  Future<Set<Extension>> getInstalledMangaExtensions(User user) async {
    _aniyomiExtensionsBox = await Hive.openBox<Extension>('aniyomiExtensions');
    return _aniyomiExtensionsBox.values
        .where((extension) => extension.type == ExtensionType.TACHIYOMI)
        .toSet();
  }

  @override
  Future<void> updateAnimeRepositoryUrl(String newUrl, User user) async {
    switch (user) {
      case AnilistUserModel():
        SettingsModel userSettings = user.settings as SettingsModel;
        await _userRepositoryAnilist.updateUserInfo(
          user.copyWith(settings: userSettings.copyWith(aniyomiExtensionsRepositoryUrl: newUrl)),
        );
      case LocalUserModel():
    }
  }

  @override
  Future<void> updateMangaRepositoryUrl(String newUrl, User user) async {
    switch (user) {
      case AnilistUserModel():
        SettingsModel userSettings = user.settings as SettingsModel;
        await _userRepositoryAnilist.updateUserInfo(
          user.copyWith(settings: userSettings.copyWith(tachiyomiExtensionsRepositoryUrl: newUrl)),
        );
      case LocalUserModel():
    }
  }

  @override
  Future<void> addExtension(Extension extension) async {
    _aniyomiExtensionsBox = await Hive.openBox<Extension>('aniyomiExtensions');
    await _aniyomiExtensionsBox.put('${extension.name}-${extension.version}', extension);
    if (extension.type == ExtensionType.ANIYOMI) {
      _aniyomiBridge.loadAnimeExtension(extension.apk, extension.pkg);
    } else if (extension.type == ExtensionType.TACHIYOMI) {
      _aniyomiBridge.loadMangaExtension(extension.apk, extension.pkg);
    } else {
      _logger.w("Unknown extension type: ${extension.type}");
      throw Exception("Unknown extension type: ${extension.type}");
    }
  }

  @override
  Future<void> removeExtension(Extension extension) async {
    _aniyomiExtensionsBox = await Hive.openBox<Extension>('aniyomiExtensions');
    await _aniyomiExtensionsBox.delete('${extension.name}-${extension.version}');
    if (extension.type == ExtensionType.ANIYOMI) {
      _aniyomiBridge.unloadAnimeExtension(extension.pkg);
    } else if (extension.type == ExtensionType.TACHIYOMI) {
      _aniyomiBridge.unloadMangaExtension(extension.pkg);
    } else {
      _logger.w("Unknown extension type: ${extension.type}");
      throw Exception("Unknown extension type: ${extension.type}");
    }
  }

  Future<List<JSAnime>> getAnimeSearchResults(String query, Extension extension) async {
    return _aniyomiBridge.getAnimeSearchResults(query, 1, extension.pkg);
  }

  Future<List<JSEpisode>> getAnimeEpisodeList(JSAnime anime, Extension extension) async {
    return _aniyomiBridge.getEpisodeList(anime, extension.pkg);
  }

  Future<List<JVideo>> getAnimeVideoList(JSEpisode episode, Extension extension) async {
    return _aniyomiBridge.getVideoList(episode, extension.pkg);
  }

  Future<List<JSManga>> getMangaSearchResults(String query, Extension extension) async {
    return _aniyomiBridge.getMangaSearchResults(query, 1, extension.pkg);
  }

  Future<List<JSChapter>> getMangaChapterList(JSManga manga, Extension extension) async {
    return _aniyomiBridge.getChapterList(manga, extension.pkg);
  }

  Future<List<JPage>> getMangaPageList(JSChapter chapter, Extension extension) async {
    return _aniyomiBridge.getPageList(chapter, extension.pkg);
  }

  List<AniyomiRepoJsonEntity> _parseAniyomiRepoJsonList(Map<String, dynamic> json) {
    return ((json['list'] as List<dynamic>?) ?? [])
        .map((jsonItem) => AniyomiRepoJsonEntity.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }

  List<TachiyomiRepoJsonEntity> _parseTachiyomiRepoJsonList(Map<String, dynamic> json) {
    return ((json['list'] as List<dynamic>?) ?? [])
        .map((jsonItem) => TachiyomiRepoJsonEntity.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }

  Future<void> _loadInstalledAnimeExtensions(User loggedUser) async {
    Set<Extension> installedExtensions = await getInstalledAnimeExtensions(loggedUser);
    if (!_aniyomiBridge.isReady()) {
      Timer(const Duration(milliseconds: 500), () {
        _loadInstalledAnimeExtensions(loggedUser);
      });
      return;
    }
    for (Extension extension in installedExtensions) {
      _aniyomiBridge.loadAnimeExtension(extension.apk, extension.pkg);
    }
  }

  Future<void> _loadInstalledMangaExtensions(User loggedUser) async {
    Set<Extension> installedExtensions = await getInstalledMangaExtensions(loggedUser);
    if (!_aniyomiBridge.isReady()) {
      Timer(const Duration(milliseconds: 500), () {
        _loadInstalledMangaExtensions(loggedUser);
      });
      return;
    }
    for (Extension extension in installedExtensions) {
      _aniyomiBridge.loadMangaExtension(extension.apk, extension.pkg);
    }
  }

  Future<void> _closeLoggedUserSubscription() async{
    _loggedUserSubscription.cancel();
  }
}
