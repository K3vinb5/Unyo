import 'package:k3vinb5_aniyomi_bridge/jmodels/jsepisode.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';

class EpisodesNotifier {
  final BehaviorSubject<List<JSEpisode>> _episodesSubject;
  final _logger = sl<Logger>();

  EpisodesNotifier() : _episodesSubject = BehaviorSubject.seeded([]);

  // Public stream for Cubits to subscribe
  Stream<List<JSEpisode>> get episodesStream => _episodesSubject.stream;

  void updateSelectedJSEpisodes(List<JSEpisode> episodes) {
    _logger.d("JSEpisodes notifier updated with: $episodes");
    _episodesSubject.add(episodes);
  }

  List<JSEpisode> get currentJSEpisodes => _episodesSubject.value;

  void dispose() => _episodesSubject.close();
}