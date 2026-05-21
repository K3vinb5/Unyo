import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/media/manga.dart';

class MangaNotifier {
  final BehaviorSubject<Manga> _mangaSubject;
  final _logger = sl<Logger>();

  MangaNotifier() : _mangaSubject = BehaviorSubject.seeded(MangaModel.empty());

  // Public stream for Cubits to subscribe
  Stream<Manga> get mangaStream => _mangaSubject.stream;

  void updateSelectedManga(Manga manga) {
    _logger.d("Manga notifier updated with: $manga");
    _mangaSubject.add(manga);
  }

  Manga get currentManga => _mangaSubject.value;

  void dispose() => _mangaSubject.close();
}