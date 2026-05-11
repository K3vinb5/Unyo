import 'dart:async';
import 'dart:math';

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
import 'package:unyo/domain/entities/extension.dart';
import 'package:unyo/domain/entities/user.dart';
import 'package:unyo/domain/repositories/extension_repository.dart';

class ExtensionRepositoryAniyomi implements ExtensionRepository {
  // Services
  final Logger _logger = sl<Logger>();
  final HttpService _httpService = sl<HttpService>();
  final AniyomiBridge _aniyomiBridge = sl<AniyomiBridge>();
  // Boxes
  late Box<Extension> _aniyomiExtensionsBox;
  // Notifiers
  final UserNotifier _loggedUserNotifier;
  late StreamSubscription<User> _loggedUserSubscription;

  ExtensionRepositoryAniyomi(this._loggedUserNotifier) {
    _init();
  }

  Future<void> _init() async {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) async {
        _loadInstalledAnimeExtensions(loggedUser);
        _loadInstalledMangaExtensions(loggedUser);
        _closeLoggedUserSubscription();
    });
  }

  Future<Set<Extension>> _fetchAllAnimeExtensions(User user) async {
    final Set<Extension> allExtensions = {};
    for (final String repoUrl in user.settings.aniyomiExtensionsRepositories) {
      try {
        ApiResponse<List<AniyomiRepoJsonEntity>> repositoryResponse = await _httpService.get(
          repoUrl,
          fromJson: _parseAniyomiRepoJsonList,
        );
        allExtensions.addAll(
          repositoryResponse.data.map(
            (aniyomiRepoJsonEntity) => ExtensionModel(
              name: aniyomiRepoJsonEntity.name.replaceFirst("Aniyomi: ", ""),
              pkg: aniyomiRepoJsonEntity.pkg,
              apk: "${repoUrl.replaceFirst("index.min.json", "apk/")}${aniyomiRepoJsonEntity.apk}",
              icon: "${repoUrl.replaceFirst("index.min.json", "icon/")}${aniyomiRepoJsonEntity.pkg}.png",
              lang: aniyomiRepoJsonEntity.lang,
              version: aniyomiRepoJsonEntity.version,
              nsfw: aniyomiRepoJsonEntity.nsfw.toInt(),
              type: ExtensionType.ANIYOMI,
              repositoryUrl: repoUrl,
            ),
          ),
        );
      } catch (e, stackTrace) {
        _logger.w("Failed to fetch anime extensions from $repoUrl", stackTrace: stackTrace);
      }
    }
    return allExtensions;
  }

  Future<Set<Extension>> _fetchAllMangaExtensions(User user) async {
    final Set<Extension> allExtensions = {};
    for (final String repoUrl in user.settings.tachiyomiExtensionsRepositories) {
      try {
        ApiResponse<List<TachiyomiRepoJsonEntity>> repositoryResponse = await _httpService.get(
          repoUrl,
          fromJson: _parseTachiyomiRepoJsonList,
        );
        allExtensions.addAll(
          repositoryResponse.data.map(
            (tachiyomiRepoJsonEntity) => ExtensionModel(
              name: tachiyomiRepoJsonEntity.name.replaceFirst("Tachiyomi: ", ""),
              pkg: tachiyomiRepoJsonEntity.pkg,
              apk: "${repoUrl.replaceFirst("index.min.json", "apk/")}${tachiyomiRepoJsonEntity.apk}",
              icon: "${repoUrl.replaceFirst("index.min.json", "icon/")}${tachiyomiRepoJsonEntity.pkg}.png",
              lang: tachiyomiRepoJsonEntity.lang,
              version: tachiyomiRepoJsonEntity.version,
              nsfw: tachiyomiRepoJsonEntity.nsfw.toInt(),
              type: ExtensionType.TACHIYOMI,
              repositoryUrl: repoUrl,
            ),
          ),
        );
      } catch (e, stackTrace) {
        _logger.w("Failed to fetch manga extensions from $repoUrl", stackTrace: stackTrace);
      }
    }
    return allExtensions;
  }

  @override
  Future<Set<Extension>> getAvailableAnimeExtensions(User user) async {
    _logger.d("Fetching available anime extensions for AniyomiBridge.");
    final allExtensions = await _fetchAllAnimeExtensions(user);
    final installedPkgs = (await getInstalledAnimeExtensions(user)).map((e) => e.pkg).toSet();
    return allExtensions.where((e) => !installedPkgs.contains(e.pkg)).toSet();
  }

  @override
  Future<Set<Extension>> getAvailableMangaExtensions(User user) async {
    _logger.i("Fetching available manga extensions for AniyomiBridge.");
    final allExtensions = await _fetchAllMangaExtensions(user);
    final installedPkgs = (await getInstalledMangaExtensions(user)).map((e) => e.pkg).toSet();
    return allExtensions.where((e) => !installedPkgs.contains(e.pkg)).toSet();
  }

  @override
  Future<Map<String, Extension>> getAnimeExtensionUpdates(User user) async {
    _logger.d("Checking for anime extension updates.");
    final allAvailable = await _fetchAllAnimeExtensions(user);
    final installed = await getInstalledAnimeExtensions(user);
    return _computeUpdates(allAvailable, installed);
  }

  @override
  Future<Map<String, Extension>> getMangaExtensionUpdates(User user) async {
    _logger.d("Checking for manga extension updates.");
    final allAvailable = await _fetchAllMangaExtensions(user);
    final installed = await getInstalledMangaExtensions(user);
    return _computeUpdates(allAvailable, installed);
  }

  Map<String, Extension> _computeUpdates(Set<Extension> allAvailable, Set<Extension> installed) {
    final Map<String, Extension> updates = {};
    for (final ext in installed) {
      // Only look for updates from the SAME repository the extension was installed from
      Extension? latest;
      for (final avail in allAvailable) {
        if (avail.pkg == ext.pkg && avail.repositoryUrl == ext.repositoryUrl) {
          if (latest == null || _compareVersions(avail.version, latest.version) > 0) {
            latest = avail;
          }
        }
      }
      if (latest != null && _compareVersions(latest.version, ext.version) > 0) {
        updates[ext.pkg] = latest;
      }
    }
    return updates;
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

  @override
  Future<void> updateExtension(Extension oldExtension, Extension newExtension) async {
    _logger.i("Updating extension ${oldExtension.pkg} from ${oldExtension.version} to ${newExtension.version}");
    await removeExtension(oldExtension);
    await addExtension(newExtension);
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

  int _compareVersions(String a, String b) {
    final pa = a.split('.').map(int.tryParse).map((v) => v ?? 0).toList();
    final pb = b.split('.').map(int.tryParse).map((v) => v ?? 0).toList();
    for (int i = 0; i < max(pa.length, pb.length); i++) {
      final va = i < pa.length ? pa[i] : 0;
      final vb = i < pb.length ? pb[i] : 0;
      if (va != vb) return va.compareTo(vb);
    }
    return 0;
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
