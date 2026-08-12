import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:unyo/sources/sources.dart';
import 'package:unyo/util/utils.dart';

/// Manager for loading external anime/manga sources from JSON repositories
class ExternalSourcesManager {
  static final ExternalSourcesManager _instance = 
      ExternalSourcesManager._internal();
  
  factory ExternalSourcesManager() => _instance;
  
  ExternalSourcesManager._internal();

  String _repoUrl = "https://raw.githubusercontent.com/aniyomiorg/aniyomi-extensions/repo/index.json";
  Map<int, AnimeSource>? _externalAnimeSources;
  Map<int, MangaSource>? _externalMangaSources;
  
  /// Set custom repository URL
  void setRepositoryUrl(String url) {
    _repoUrl = url;
  }
  
  String getRepositoryUrl() => _repoUrl;
  
  /// Load external sources from JSON repository
  Future<void> loadExternalSources() async {
    await _loadAnimeSources();
    await _loadMangaSources();
  }
  
  /// Load anime sources from external JSON
  Future<void> _loadAnimeSources() async {
    _externalAnimeSources = {};
    try {
      // Try to load from local cache first
      final supportDir = await getApplicationSupportDirectory();
      final cacheFile = File(p.join(supportDir.path, 'anime_sources.json'));
      
      List<dynamic> sourcesData = [];
      
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        sourcesData = json.decode(content);
        logger.i("Loaded ${sourcesData.length} anime sources from cache");
      } else {
        // Fetch from remote repository
        final response = await http.get(Uri.parse(_repoUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          // Aniyomi repo structure: {"anime": [...], "manga": [...]}
          if (data is Map && data.containsKey('anime')) {
            sourcesData = data['anime'];
          } else if (data is List) {
            sourcesData = data;
          }
          
          // Cache the data
          await cacheFile.create(recursive: true);
          await cacheFile.writeAsString(json.encode(sourcesData));
          logger.i("Loaded ${sourcesData.length} anime sources from remote");
        } else {
          logger.e("Failed to fetch anime sources: ${response.statusCode}");
          return;
        }
      }
      
      int index = 0;
      for (var sourceData in sourcesData) {
        if (sourceData is Map<String, dynamic>) {
          final name = sourceData['name'] ?? 'Unknown';
          final lang = sourceData['lang'] ?? 'en';
          final hasAnime = sourceData['hasAnime'] ?? false;
          
          if (hasAnime) {
            _externalAnimeSources![index] = ExternalJsonAnimeSource(
              sourceData: sourceData,
              name: "$name ($lang)",
            );
            index++;
          }
        }
      }
      
      logger.i("Initialized ${_externalAnimeSources!.length} external anime sources");
    } catch (e) {
      logger.e("Error loading external anime sources: $e");
      _externalAnimeSources = {};
    }
  }
  
  /// Load manga sources from external JSON
  Future<void> _loadMangaSources() async {
    _externalMangaSources = {};
    try {
      final supportDir = await getApplicationSupportDirectory();
      final cacheFile = File(p.join(supportDir.path, 'manga_sources.json'));
      
      List<dynamic> sourcesData = [];
      
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        sourcesData = json.decode(content);
        logger.i("Loaded ${sourcesData.length} manga sources from cache");
      } else {
        final response = await http.get(Uri.parse(_repoUrl));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data is Map && data.containsKey('manga')) {
            sourcesData = data['manga'];
          } else if (data is List) {
            sourcesData = data;
          }
          
          await cacheFile.create(recursive: true);
          await cacheFile.writeAsString(json.encode(sourcesData));
          logger.i("Loaded ${sourcesData.length} manga sources from remote");
        } else {
          logger.e("Failed to fetch manga sources: ${response.statusCode}");
          return;
        }
      }
      
      int index = 0;
      for (var sourceData in sourcesData) {
        if (sourceData is Map<String, dynamic>) {
          final name = sourceData['name'] ?? 'Unknown';
          final lang = sourceData['lang'] ?? 'en';
          final hasManga = sourceData['hasManga'] ?? sourceData['hasAnime'] ?? false;
          
          if (hasManga) {
            _externalMangaSources![index] = ExternalJsonMangaSource(
              sourceData: sourceData,
              name: "$name ($lang)",
            );
            index++;
          }
        }
      }
      
      logger.i("Initialized ${_externalMangaSources!.length} external manga sources");
    } catch (e) {
      logger.e("Error loading external manga sources: $e");
      _externalMangaSources = {};
    }
  }
  
  Map<int, AnimeSource>? getExternalAnimeSources() => _externalAnimeSources;
  Map<int, MangaSource>? getExternalMangaSources() => _externalMangaSources;
  
  /// Clear cached sources
  Future<void> clearCache() async {
    try {
      final supportDir = await getApplicationSupportDirectory();
      final animeCache = File(p.join(supportDir.path, 'anime_sources.json'));
      final mangaCache = File(p.join(supportDir.path, 'manga_sources.json'));
      
      if (await animeCache.exists()) await animeCache.delete();
      if (await mangaCache.exists()) await mangaCache.delete();
      
      logger.i("Cleared external sources cache");
    } catch (e) {
      logger.e("Error clearing cache: $e");
    }
  }
}
