import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unyo/sources/manga/manga_source.dart';
import 'package:unyo/util/utils.dart';

/// Manga source that uses external JSON configuration (Tachiyomi-style)
class ExternalJsonMangaSource implements MangaSource {
  const ExternalJsonMangaSource({
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
  Future<List<List<String>>> getMangaTitlesAndIds(String query) async {
    try {
      String? searchUrl = sourceData['searchUrl'];
      if (searchUrl != null && searchUrl.isNotEmpty) {
        searchUrl = searchUrl.replaceFirst('{query}', Uri.encodeComponent(query));
        final response = await http.get(Uri.parse(searchUrl));
        
        if (response.statusCode == 200) {
          return _parseSearchResponse(response.body);
        }
      }
      
      final List<String> titles = [];
      final List<String> ids = [];
      
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
      logger.e("Error fetching manga titles for $name: $e");
      return [[], []];
    }
  }

  List<List<String>> _parseSearchResponse(String body) {
    final List<String> titles = [];
    final List<String> ids = [];
    
    try {
      final data = json.decode(body);
      List<dynamic> results = [];
      
      if (data is List) {
        results = data;
      } else if (data is Map) {
        results = data['results'] ?? data['data'] ?? data['mangas'] ?? [];
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
      logger.e("Error parsing manga search response: $e");
    }
    
    return [titles, ids];
  }

  @override
  Future<List<String>> getMangaChapterIds(String mangaId) async {
    try {
      String? chaptersUrl = sourceData['chaptersUrl'];
      String url = '';
      
      if (chaptersUrl != null && chaptersUrl.isNotEmpty) {
        url = chaptersUrl.replaceFirst('{id}', mangaId);
      } else if (_baseUrl.isNotEmpty && mangaId.startsWith('http')) {
        url = mangaId;
      } else {
        url = '$_baseUrl$mangaId/chapters';
      }
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return _parseChaptersResponse(response.body);
      }
      
      return [];
    } catch (e) {
      logger.e("Error fetching chapters for $name: $e");
      return [];
    }
  }

  List<String> _parseChaptersResponse(String body) {
    final List<String> chapters = [];
    
    try {
      final data = json.decode(body);
      List<dynamic> chapterList = [];
      
      if (data is List) {
        chapterList = data;
      } else if (data is Map) {
        chapterList = data['chapters'] ?? data['data'] ?? [];
      }
      
      for (var chapter in chapterList) {
        if (chapter is Map<String, dynamic>) {
          final chapterName = chapter['name'] ?? chapter['title'] ?? '';
          final chapterId = chapter['id']?.toString() ?? chapter['url'] ?? '';
          chapters.add('$chapterName|$chapterId');
        } else if (chapter is String) {
          chapters.add(chapter);
        }
      }
    } catch (e) {
      logger.e("Error parsing chapters response: $e");
    }
    
    return chapters;
  }

  @override
  Future<List<String>> getMangaChapterPages(String chapterId) async {
    try {
      // chapterId format: "chapterName|chapterUrl"
      final parts = chapterId.split('|');
      final String url = parts.length > 1 ? parts[1] : chapterId;
      
      String pageUrl = url;
      if (!url.startsWith('http') && _baseUrl.isNotEmpty) {
        pageUrl = '$_baseUrl$url';
      }
      
      final response = await http.get(Uri.parse(pageUrl));
      
      if (response.statusCode == 200) {
        return _parsePagesResponse(response.body);
      }
      
      return [];
    } catch (e) {
      logger.e("Error fetching pages for chapter: $e");
      return [];
    }
  }

  List<String> _parsePagesResponse(String body) {
    final List<String> pages = [];
    
    try {
      final data = json.decode(body);
      List<dynamic> pageList = [];
      
      if (data is List) {
        pageList = data;
      } else if (data is Map) {
        pageList = data['pages'] ?? data['images'] ?? data['data'] ?? [];
      }
      
      for (var page in pageList) {
        if (page is Map<String, dynamic>) {
          final imageUrl = page['url'] ?? page['image'] ?? page['src'] ?? '';
          if (imageUrl.toString().isNotEmpty) {
            pages.add(imageUrl.toString());
          }
        } else if (page is String && page.startsWith('http')) {
          pages.add(page);
        }
      }
      
      // If no images found in JSON, try to extract from HTML
      if (pages.isEmpty) {
        final imgRegex = RegExp(r'<img[^>]+src=[\"']([^\"']+\\.(?:jpg|jpeg|png|gif|webp))[\"']');
        for (var match in imgRegex.allMatches(body)) {
          String src = match.group(1)!;
          if (src.startsWith('//')) src = 'https:$src';
          if (src.startsWith('http')) {
            pages.add(src);
          }
        }
      }
    } catch (e) {
      logger.e("Error parsing pages response: $e");
    }
    
    return pages;
  }

  @override
  String getSourceName() {
    return name;
  }
}
