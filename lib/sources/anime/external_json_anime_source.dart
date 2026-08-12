import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unyo/sources/sources.dart';
import 'package:unyo/util/utils.dart';

/// Anime source that uses external JSON configuration (Aniyomi-style)
class ExternalJsonAnimeSource implements AnimeSource {
  const ExternalJsonAnimeSource({
    required this.sourceData,
    required this.name,
  });

  final Map<String, dynamic> sourceData;
  final String name;

  String get _baseUrl {
    return sourceData['baseUrl'] ?? '';
  }

  String get _sourceId {
    return sourceData['id']?.toString() ?? '';
  }

  @override
  Future<List<List<String>>> getAnimeTitlesAndIds(String query) async {
    try {
      // Use the source's search URL pattern if available
      String? searchUrl = sourceData['searchUrl'];
      if (searchUrl != null && searchUrl.isNotEmpty) {
        searchUrl = searchUrl.replaceFirst('{query}', Uri.encodeComponent(query));
        final response = await http.get(Uri.parse(searchUrl));
        
        if (response.statusCode == 200) {
          return _parseSearchResponse(response.body);
        }
      }
      
      // Fallback: try common patterns
      final List<String> titles = [];
      final List<String> ids = [];
      
      // Try direct search on base URL
      if (_baseUrl.isNotEmpty) {
        final searchPath = sourceData['searchPath'] ?? '/search';
        final fullUrl = '$_baseUrl$searchPath?q=${Uri.encodeComponent(query)}';
        final response = await http.get(Uri.parse(fullUrl));
        
        if (response.statusCode == 200) {
          return _parseSearchResponse(response.body);
        }
      }
      
      return [titles, ids];
    } catch (e) {
      logger.e("Error fetching anime titles for $name: $e");
      return [[], []];
    }
  }

  List<List<String>> _parseSearchResponse(String body) {
    final List<String> titles = [];
    final List<String> ids = [];
    
    try {
      final data = json.decode(body);
      
      // Handle different response formats
      List<dynamic> results = [];
      if (data is List) {
        results = data;
      } else if (data is Map) {
        results = data['results'] ?? data['data'] ?? data['items'] ?? [];
      }
      
      for (var item in results) {
        if (item is Map<String, dynamic>) {
          final title = item['title'] ?? item['name'] ?? '';
          final id = item['id']?.toString() ?? item['url'] ?? '';
          
          if (title.toString().isNotEmpty) {
            titles.add(title.toString());
            ids.add(id.toString());
          }
        }
      }
    } catch (e) {
      logger.e("Error parsing search response: $e");
    }
    
    return [titles, ids];
  }

  @override
  Future<StreamData> getAnimeStreamAndCaptions(
    String id,
    String name,
    int episode,
    BuildContext context,
  ) async {
    try {
      // Get episode URL from source configuration
      String? episodeUrlPattern = sourceData['episodeUrl'];
      String episodeUrl = '';
      
      if (episodeUrlPattern != null && episodeUrlPattern.isNotEmpty) {
        episodeUrl = episodeUrlPattern
            .replaceFirst('{id}', id)
            .replaceFirst('{episode}', episode.toString());
      } else if (_baseUrl.isNotEmpty && id.startsWith('http')) {
        episodeUrl = id; // ID is already a full URL
      } else {
        episodeUrl = '$_baseUrl$id/episode/$episode';
      }
      
      // Fetch the episode page to extract video URLs
      final response = await http.get(Uri.parse(episodeUrl));
      
      if (response.statusCode == 200) {
        return _extractStreamsFromHtml(response.body, episodeUrl);
      }
      
      return StreamData.empty();
    } catch (e) {
      logger.e("Error getting stream for $name episode $episode: $e");
      return StreamData.empty();
    }
  }

  StreamData _extractStreamsFromHtml(String html, String baseUrl) {
    final List<String> streams = [];
    final List<String> qualities = [];
    
    try {
      // Extract video URLs using patterns from source config
      final List<String> patterns = 
          (sourceData['videoPatterns'] as List?)?.cast<String>() ?? 
          [r'https://[^\s\"\'<>]+\.m3u8[^\s\"\'<>]*', r'https://[^\s\"\'<>]+/stream[^\s\"\'<>]*'];
      
      for (var pattern in patterns) {
        final regex = RegExp(pattern);
        final matches = regex.allMatches(html);
        
        for (var match in matches) {
          String url = match.group(0)!;
          if (!streams.contains(url)) {
            streams.add(url);
            qualities.add(_detectQuality(url));
          }
        }
      }
      
      // If no streams found, try common iframe sources
      if (streams.isEmpty) {
        final iframeRegex = RegExp(r'<iframe[^>]+src=[\"']([^\"']+)[\"']');
        for (var match in iframeRegex.allMatches(html)) {
          String src = match.group(1)!;
          if (src.startsWith('//')) src = 'https:$src';
          if (!src.startsWith('http')) continue;
          
          streams.add(src);
          qualities.add('Auto');
        }
      }
    } catch (e) {
      logger.e("Error extracting streams: $e");
    }
    
    return StreamData(
      streams: streams,
      qualities: qualities,
      captions: null,
      tracks: null,
      headersKeys: null,
      headersValues: null,
    );
  }

  String _detectQuality(String url) {
    if (url.contains('1080')) return '1080p';
    if (url.contains('720')) return '720p';
    if (url.contains('480')) return '480p';
    if (url.contains('360')) return '360p';
    if (url.contains('.m3u8')) return 'HLS';
    return 'Auto';
  }

  @override
  String getSourceName() {
    return name;
  }
}
