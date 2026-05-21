import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/media/anime.dart';

class AnimeNotifier {
  final BehaviorSubject<Anime> _animeSubject;
  final _logger = sl<Logger>();

  AnimeNotifier() : _animeSubject = BehaviorSubject.seeded(AnimeModel.empty());

  // Public stream for Cubits to subscribe
  Stream<Anime> get animeStream => _animeSubject.stream;

  void updateSelectedAnime(Anime anime) {
    _logger.d("Anime notifier updated with: $anime");
    _animeSubject.add(anime);
  }

  Anime get currentAnime => _animeSubject.value;

  void dispose() => _animeSubject.close();
}