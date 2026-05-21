import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/list/media_list.dart';

class MediaListNotifier {
  final BehaviorSubject<MediaList> _mediaListSubject;
  final _logger = sl<Logger>();

  MediaListNotifier() : _mediaListSubject = BehaviorSubject.seeded(MediaListModel.empty());

  // Public stream for Cubits to subscribe
  Stream<MediaList> get mediaListStream => _mediaListSubject.stream;

  void updateSelectedMediaList(MediaList mediaList) {
    _logger.d("MediaList notifier updated with: $mediaList");
    _mediaListSubject.add(mediaList);
  }

  MediaList get currentMediaList => _mediaListSubject.value;

  void dispose() => _mediaListSubject.close();
}