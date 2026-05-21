
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/media/video_info.dart';

class VideoInfoNotifier {
  final BehaviorSubject<VideoInfo> _videoInfoSubject;
  final _logger = sl<Logger>();

  VideoInfoNotifier() : _videoInfoSubject = BehaviorSubject.seeded(VideoInfoModel.empty());

  // Public stream for Cubits to subscribe
  Stream<VideoInfo> get videoInfoStream => _videoInfoSubject.stream;

  void updateVideoInfo(VideoInfo videoInfo) {
    _logger.d("VideoInfo notifier updated");
    _videoInfoSubject.add(videoInfo);
  }

  VideoInfo get currentVideoInfo => _videoInfoSubject.value;

  void dispose() => _videoInfoSubject.close();
}