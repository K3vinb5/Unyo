import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/episode_info.dart';

class EpisodesInfoNotifier {
  final BehaviorSubject<List<EpisodeInfo>> _episodeInfoSubject;
  final _logger = sl<Logger>();

  EpisodesInfoNotifier() : _episodeInfoSubject = BehaviorSubject.seeded([]);

  // Public stream for Cubits to subscribe
  Stream<List<EpisodeInfo>> get episodeInfoStream => _episodeInfoSubject.stream;

  void updateSelectedEpisodeInfo(List<EpisodeInfo> episodeInfo) {
    _logger.d("EpisodeInfo notifier updated with: $episodeInfo");
    _episodeInfoSubject.add(episodeInfo);
  }

  List<EpisodeInfo> get currentEpisodeInfo => _episodeInfoSubject.value;

  void dispose() => _episodeInfoSubject.close();
}