import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/list/media_list_entry.dart';

class MediaListEntryNotifier {
  final BehaviorSubject<MediaListEntry> _mediaListEntrySubject;
  final _logger = sl<Logger>();

  MediaListEntryNotifier() : _mediaListEntrySubject = BehaviorSubject.seeded(MediaListEntryModel.empty());

  // Public stream for Cubits to subscribe
  Stream<MediaListEntry> get mediaListEntryStream => _mediaListEntrySubject.stream;

  void updateSelectedMediaListEntry(MediaListEntry mediaListEntry) {
    _logger.d("MediaListEntry notifier updated with: $mediaListEntry");
    _mediaListEntrySubject.add(mediaListEntry);
  }

  MediaListEntry get currentMediaListEntry => _mediaListEntrySubject.value;

  void dispose() => _mediaListEntrySubject.close();
}