// External dependencies
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'dart:async';

// Internal dependencies
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/application/states/video_state.dart';
import 'package:unyo/core/notification/anime_notifier.dart';
import 'package:unyo/core/notification/episode_info_notifier.dart';
import 'package:unyo/core/notification/media_list_entry_notifier.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/core/notification/video_info_notifier.dart';
import 'package:unyo/core/services/video/video_service.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:unyo/domain/entities/episode_info.dart';
import 'package:unyo/domain/entities/media_list_entry.dart';
import 'package:unyo/domain/entities/user.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/video_info.dart';
import 'package:unyo/presentation/dialogs/warning_dialog.dart';

class VideoCubit extends Cubit<VideoState> with EffectMixin<VideoState> {
  // Repositories
  final Logger _logger = sl<Logger>();

  // Notifiers / Subscriptions
  final UserNotifier _loggedUserNotifier;
  final VideoInfoNotifier _videoInfoNotifier;
  final AnimeNotifier _selectedAnimeNotifier;
  final EpisodesInfoNotifier _episodesInfoNotifier;
  final MediaListEntryNotifier _mediaListEntryNotifier;
  late StreamSubscription<User> _loggedUserSubscription;
  late StreamSubscription<VideoInfo> _videoInfoSubscription;
  late StreamSubscription<Anime> _selectedAnimeSubscription;
  late StreamSubscription<List<EpisodeInfo>> _episodeInfoSubscription;
  late StreamSubscription<MediaListEntry> _mediaListEntrySubscription;

  // Services
  late VideoService _videoService;
  // Others
  bool _videoServiceInitialized = false;

  VideoCubit(this._loggedUserNotifier, this._videoInfoNotifier, this._selectedAnimeNotifier, this._episodesInfoNotifier, this._mediaListEntryNotifier)
    : super(
      VideoState(
      loggedUser: UserModel.empty(),
      videoInfo: VideoInfoModel.empty(),
      selectedAnime: AnimeModel.empty(),
      episodesInfo: [],
      mediaListEntry: MediaListEntryModel.empty(),
      availableCastDevices: [],
      isLoading: true
    )
  ) {
    _init();
  }

  @override
  VideoState copyStateWithEffects(VideoState state, List<AppEffect> effects) {
    return state.copyWith(effects: effects);
  }

  @override
  Logger get logger => _logger;

  VideoService get videoService => _videoService;

  @override
  Future<void> close() {
    if (_videoServiceInitialized) {
      _videoService.setPreventSleep(false);
      _videoService.dispose();
    }
    _loggedUserSubscription.cancel();
    _videoInfoSubscription.cancel();
    _selectedAnimeSubscription.cancel();
    _episodeInfoSubscription.cancel();
    _mediaListEntrySubscription.cancel();
    _logger.d("VideoCubit closed and subscriptions cancelled.");
    return super.close();
  }

  void _init() {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) {
      emit(state.copyWith(loggedUser: loggedUser));
    });
    _videoInfoSubscription = _videoInfoNotifier.videoInfoStream.listen((videoInfo) {

      _videoService = VideoService(
          video: videoInfo.currentVideo,
          alternativeVideos: videoInfo.alternativeVideos,
          videoIndex: videoInfo.videoIndex,
          episodeIndex: videoInfo.playlistIndex,
          onErrorCallback: _handleVideoError,
          lowLatency: false
      );
      _videoService.setPreventSleep(true);
      _videoServiceInitialized = true;
      emit(state.copyWith(videoInfo: videoInfo, isLoading: false));
    });
    _selectedAnimeSubscription = _selectedAnimeNotifier.animeStream.listen((selectedAnime) {
      emit(state.copyWith(selectedAnime: selectedAnime));
    });
    _episodeInfoSubscription = _episodesInfoNotifier.episodeInfoStream.listen((episodesInfo) {
      emit(state.copyWith(episodesInfo: episodesInfo));
    });
    _mediaListEntrySubscription = _mediaListEntryNotifier.mediaListEntryStream.listen((mediaListEntry) {
      emit(state.copyWith(mediaListEntry: mediaListEntry));
    });
    _getAvailableCastDevices();
  }

  Future<void> _getAvailableCastDevices() async {
    List<CastDevice> availableCastDevices = await CastDiscoveryService().search();
    emit(state.copyWith(availableCastDevices: availableCastDevices));
  }

  Future<void> _connectAndPlayMediaOnCastDevice(CastDevice device) async {
    final session = await CastSessionManager().startSession(device);

    session.stateStream.listen((castState) {
      if (castState == CastSessionState.connected) {
        _logger.d("Connected to Cast device: ${device.name}");
        showSnackBarEffect(
          "Cast Connected",
          message: "Connected to ${device.name}",
          contentType: ContentType.success,
        );
      }
    });

    var messageIndex = 0;
    session.messageStream.listen((message) {
      messageIndex += 1;
      _logger.d("Cast message received ($messageIndex): $message");

      // After receiving the initial messages, send the media load command
      if (messageIndex == 2) {
        Future.delayed(const Duration(seconds: 2)).then((_) {
          _sendMediaToCastSession(session);
        });
      }
    });

    // Launch the default media receiver app
    session.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': 'CC1AD845', // Google's default media receiver app ID
    });
  }

  void _sendMediaToCastSession(CastSession session) {
    final video = state.videoInfo.currentVideo;
    final anime = state.selectedAnime;
    final episodeNumber = state.videoInfo.playlistIndex + 1;

    // Determine the content type based on the video URL
    final contentType = _getContentType(video.videoUrl);
    final streamType = _getStreamType(video.videoUrl);

    _logger.d("Casting video: ${video.videoUrl} with contentType: $contentType, streamType: $streamType");

    // Build the media message
    final Map<String, dynamic> message = {
      'contentId': video.videoUrl,
      'contentType': contentType,
      'streamType': streamType,
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': "${anime.title.userPreferred} - Episode $episodeNumber",
        'images': [
          {'url': anime.coverImage}
        ]
      }
    };

    // Add custom headers if available (for custom receivers that support it)
    // Note: The default media receiver (CC1AD845) has limited header support.
    // For full header support, a custom receiver app may be needed.
    if (video.headers != null && video.headers!.headersMap.isNotEmpty) {
      final headers = video.headers!.headersMap;
      _logger.d("Including custom headers for cast: $headers");

      // Add headers via customData (requires custom receiver support)
      message['customData'] = {
        'headers': headers,
      };
    }

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': _videoService.position.inSeconds,
      'media': message,
    });

    // Pause local playback when casting
    _videoService.pause();
  }

  String _getContentType(String videoUrl) {
    final lowerUrl = videoUrl.toLowerCase();

    if (lowerUrl.contains('.m3u8') || lowerUrl.contains('m3u8')) {
      return 'application/x-mpegurl';
    } else if (lowerUrl.contains('.mpd')) {
      return 'application/dash+xml';
    } else if (lowerUrl.endsWith('.webm')) {
      return 'video/webm';
    } else if (lowerUrl.endsWith('.mkv')) {
      return 'video/x-matroska';
    } else if (lowerUrl.endsWith('.avi')) {
      return 'video/x-msvideo';
    } else if (lowerUrl.endsWith('.mov')) {
      return 'video/quicktime';
    } else if (lowerUrl.endsWith('.ts')) {
      return 'video/mp2t';
    } else if (lowerUrl.endsWith('.flv')) {
      return 'video/x-flv';
    } else if (lowerUrl.endsWith('.mp3')) {
      return 'audio/mpeg';
    } else if (lowerUrl.endsWith('.aac')) {
      return 'audio/aac';
    } else {
      // Default to mp4 for most video streams
      return 'video/mp4';
    }
  }

  String _getStreamType(String videoUrl) {
    final lowerUrl = videoUrl.toLowerCase();

    // HLS and DASH are typically live/buffered streams
    if (lowerUrl.contains('.m3u8') || lowerUrl.contains('m3u8') || lowerUrl.contains('.mpd')) {
      // Could be LIVE or BUFFERED depending on the stream
      // For VOD content, BUFFERED is more appropriate
      return 'BUFFERED';
    }

    // Regular file-based content
    return 'BUFFERED';
  }

  void navigateBackToAnimeDetailsPage(BuildContext context) {
    _logger.d("Returning to Anime Details Page");
    popRouteEffect(context);
    // The BlocProvider will dispose/close this cubit when the route is popped.
  }

  void castToDevice(CastDevice device) {
    _logger.d("Casting to device: ${device.name}");
    _connectAndPlayMediaOnCastDevice(device);
  }

  void _handleVideoError(String errorTitle) {
    showWidgetDialogEffect(dialog: WarningDialog(width: 500, height: 200, title: errorTitle));
  }
}
