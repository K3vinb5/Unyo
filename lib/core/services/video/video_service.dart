// External dependencies
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fvp/mdk.dart' as mdk;
import 'package:logger/logger.dart';

// Internal dependencies
import 'package:unyo/domain/entities/extension/headers.dart' as ext;
import 'package:unyo/domain/entities/extension/track.dart' as ext;
import 'package:unyo/domain/entities/extension/video.dart' as ext;
import 'package:unyo/core/di/locator.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

class VideoService {
  // Services
  final Logger _logger = sl<Logger>();

  final ext.Video _video;
  final List<ext.Video> _alternativeVideos;
  int _videoIndex;
  // This will be used for getting the correct video out of a playlist from a magnet / torrent
  int _episodeIndex;
  late final mdk.Player _player;
  final List<ext.Track> captionTracks = [];
  final List<ext.Track> audioTracks = [];
  ext.Track? _currentCaptionTrack;
  ext.Track? _currentAudioTrack;
  final void Function(String) _onErrorCallback;

  final bool _lowLatency;
  late bool _initialFullscreen;
  late bool _isFullscreen;
  bool _isVideoReady = false;
  bool _isBuffering = true;
  bool _isLoading = false;
  bool _isDisposed = false;
  static const mdk.SeekFlag _seekFlags = mdk.SeekFlag(
    mdk.SeekFlag.fromStart | mdk.SeekFlag.inCache | mdk.SeekFlag.fast,
  );

  VideoService({
    required ext.Video video,
    required List<ext.Video> alternativeVideos,
    required int videoIndex,
    required int episodeIndex,
    required void Function(String) onErrorCallback,
    bool lowLatency = false,
  }) : _episodeIndex = episodeIndex,
       _videoIndex = videoIndex,
       _video = video,
       _alternativeVideos = alternativeVideos,
       _onErrorCallback = onErrorCallback,
       _lowLatency = lowLatency {
    initAsync();
    _player = mdk.Player();
    // Set player ffmpeg properties
    _configureDecoder();
    _configurePlayer();
    // Set player HTTP headers
    _setPlayerHttpHeaders(_video.headers);
    // Set player logs handler
    // _setPlayerLogsHandler();
    // Waits for video to be ready and initializes embedded tracks
    // TODO handle magnets
    // Set player media properties
    _player.setMedia(_video.videoUrl, mdk.MediaType.video);
    _player.setMedia(_video.videoUrl, mdk.MediaType.audio);
    _player.loop = 0; // No loop
    _player.state = mdk.PlaybackState.paused;
    _player.onMediaStatus(_onMediaStatusInit);
  }

  /// Inits asynchronous properties
  Future<void> initAsync() async {
    _initialFullscreen = await windowManager.isFullScreen();
    _isFullscreen = _initialFullscreen;
  }

  // Getters
  Duration get position => Duration(milliseconds: _player.position);

  String get formattedPosition => _formatMilliseconds(position.inMilliseconds);

  ValueNotifier<int?> get textureId => _player.textureId;

  Duration get duration => Duration(milliseconds: _player.mediaInfo.duration);

  double get percentagePlayed => (position.inMilliseconds / duration.inMilliseconds);

  double get volume => _player.volume;

  bool get isPlaying => _player.state == mdk.PlaybackState.playing;

  bool get isBuffering => _isBuffering;

  bool get isLoading => _isLoading;

  bool get isFullscreen => _isFullscreen;

  double get aspectRatio {
    final streams = _player.mediaInfo.video;
    if (streams != null && streams.isNotEmpty) {
      final codec = streams.first.codec;
      return codec.width / codec.height;
    }
    return -1;
  }

  List<ext.Track> get captions => captionTracks;

  List<ext.Track> get audios => audioTracks;

  // Setters
  bool play() {
    if (_isBuffering) return false;
    _player.state = mdk.PlaybackState.playing;
    return true;
  }

  bool pause() {
    if (_isBuffering) return false;
    _player.state = mdk.PlaybackState.paused;
    return true;
  }

  bool togglePlay() {
    if (_isBuffering) return false;
    if (isPlaying) {
      pause();
    } else {
      play();
    }
    return true;
  }

  bool setLooping(bool loop) {
    loop ? _player.loop = -1 : _player.loop = 0;
    return true;
  }

  bool setVolume(double volume) {
    _player.volume = volume;
    return true;
  }

  bool setPlaybackSpeed(double newPlayBackSpeed) {
    _player.playbackRate = newPlayBackSpeed;
    return true;
  }

  bool seekTo(Duration newDuration) {
    _player.seek(position: newDuration.inMilliseconds, flags: _seekFlags);
    return true;
  }

  bool reverse(Duration reverseDuration) {
    return seekTo(Duration(milliseconds: position.inMilliseconds - reverseDuration.inMilliseconds));
  }

  bool forward(Duration forwardDuration) {
    return seekTo(Duration(milliseconds: position.inMilliseconds + forwardDuration.inMilliseconds));
  }

  bool setCaptionOffset(Duration duration) {
    return false;
  }

  Future<bool> setCaption(int captionIndex) async {
    if (captionIndex < 0 || captionIndex >= captionTracks.length) {
      _currentCaptionTrack = null;
      return false;
    }
    _currentCaptionTrack = captionTracks[captionIndex];
    if (_currentCaptionTrack!.embedded) {
      _player.activeSubtitleTracks = [_currentCaptionTrack?.embeddedIndex ?? 0];
    } else {
      _player.setMedia(_currentCaptionTrack!.url, mdk.MediaType.subtitle);
    }
    return true;
  }

  bool setAudioTrack(int audioTrackIndex) {
    if (audioTrackIndex < 0 || audioTrackIndex >= audioTracks.length) {
      _currentAudioTrack = null;
      return false;
    }
    _currentAudioTrack = audioTracks[audioTrackIndex];
    if (_currentAudioTrack!.embedded) {
      _player.activeAudioTracks = [_currentAudioTrack?.embeddedIndex ?? 0];
    } else {
      _player.setMedia(_currentAudioTrack!.url, mdk.MediaType.audio);
    }
    return true;
  }

  bool setFullscreen(bool fullscreen) {
    _isFullscreen = fullscreen;
    windowManager.setFullScreen(fullscreen);
    return true;
  }

  bool setPreventSleep(bool preventSleep) {
    WakelockPlus.toggle(enable: preventSleep);
    return true;
  }

  bool updateTexture() {
    _player.updateTexture();
    return true;
  }

  void dispose() {
    _isDisposed = true;
    _player.onMediaStatus(null);
    setFullscreen(_initialFullscreen);
    _player.dispose();
  }

  // Utilities
  void _configureDecoder() {
    final vd = {
      'windows': ['MFT:d3d=11', "D3D11", "DXVA", 'CUDA', 'hap', 'FFmpeg', 'dav1d'],
      'macos': ['VT', 'hap', 'FFmpeg', 'dav1d'],
      'linux': ['VAAPI', 'CUDA', 'VDPAU', 'hap', 'FFmpeg', 'dav1d'],
    };
    _player.setDecoders(mdk.MediaType.video, vd[Platform.operatingSystem]!);
  }

  void _configurePlayer() {
    _player.setProperty(
      'avio.protocol_whitelist',
      'file,ftp,rtmp,http,https,tls,rtp,tcp,udp,crypto,httpproxy,data,concatf,concat,subfile',
    );
    // Not sure about this flag
    _player.setProperty('video.decoder', 'shader_resource=0');
    _player.setProperty('avformat.strict', 'experimental');
    _player.setProperty('avformat.safe', '0');
    _player.setProperty('avio.reconnect', '1');
    _player.setProperty('avio.reconnect_delay_max', '7');
    _player.setProperty('avformat.rtsp_transport', 'tcp');
    _player.setProperty('avformat.extension_picky', '0');
    _player.setProperty('avformat.allowed_segment_extensions', 'ALL');
    if (_lowLatency) {
      _player.setProperty('avformat.fflags', '+nobuffer');
      _player.setProperty('avformat.fpsprobesize', '0');
      _player.setProperty('avformat.analyzeduration', '100000');
      _player.setBufferRange(min: 0, max: 1000, drop: true);
    } else {
      _player.setBufferRange(min: 0, max: 5000, drop: false);
    }
  }

  void _setPlayerHttpHeaders(ext.Headers? headers) {
    if (headers == null || headers.headersMap.isEmpty) return;
    final userAgent = headers.headersMap.entries
        .firstWhere((e) => e.key.toLowerCase() == 'user-agent', orElse: () => const MapEntry('', ''))
        .value;

    if (userAgent.isNotEmpty) {
      _player.setProperty('user_agent', userAgent);
    }
    final formattedHeaders = headers.headersMap.entries
        // .where((e) => e.key.toLowerCase() != 'user-agent') // Filter out UA
        .map((e) {
          // Fix cookie separator logic (HTTP spec requires '; ' not ',')
          final value = e.key.toLowerCase() == 'cookie' ? e.value.replaceAll(',', '; ') : e.value;
          return '${e.key}: $value';
        })
        .join('\r\n'); // Join with CRLF

    if (formattedHeaders.isNotEmpty) {
      _player.setProperty('headers', formattedHeaders);
      _player.setProperty('avio.headers', formattedHeaders);
    }
  }

  void _setPlayerLogsHandler() {
    mdk.setLogHandler((mdk.LogLevel level, String message) {
      if (!message.contains("unloaded media's position")) {
        switch (level) {
          case mdk.LogLevel.debug:
          // _logger.d("MDK Log: $message");
          case mdk.LogLevel.info:
          // _logger.i("MDK Log: $message");
          case mdk.LogLevel.warning:
          // _logger.w("MDK Log: $message");
          case mdk.LogLevel.error:
            _logger.e("MDK Log: $message");
          case mdk.LogLevel.off:
            break;
          case mdk.LogLevel.all:
            break;
        }
      }
    });
  }

  bool _onMediaStatusInit(mdk.MediaStatus oldStatus, mdk.MediaStatus newStatus) {
    if (_isDisposed) return false;

    if (newStatus.test(mdk.MediaStatus.loaded) && !_isVideoReady) {
      _initCaptionsAndAudiotracks();
      _player.state = mdk.PlaybackState.playing;
      setVolume(1.0);
      _isVideoReady = true;
    }
    if (newStatus.test(mdk.MediaStatus.loaded) && _isVideoReady) {
      _isLoading = false;
    }
    if (newStatus.test(mdk.MediaStatus.loading)) {
      _isLoading = true;
    }
    if (newStatus.test(mdk.MediaStatus.buffering)) {
      _isBuffering = true;
    }
    if (newStatus.test(mdk.MediaStatus.buffered)) {
      _isBuffering = false;
    }
    if (newStatus.test(mdk.MediaStatus.invalid)) {
      if (!_isDisposed) {
        _onErrorCallback("Failed to load media. Please try again later.");
      }
      return false;
    }
    return true;
  }

  Future<void> _initCaptionsAndAudiotracks() async {
    if (_player.mediaInfo.subtitle != null && _player.mediaInfo.subtitle!.isNotEmpty) {
      for (mdk.SubtitleStreamInfo subtitleStreamInfo in _player.mediaInfo.subtitle!) {
        captionTracks.add(
          ext.Track(
            url: "",
            lang:
                "${subtitleStreamInfo.metadata["title"] ?? ""} (${subtitleStreamInfo.metadata["language"]} - Embedded)",
            embedded: true,
          ),
        );
      }
    }
    captionTracks.addAll(_video.subtitleTracks);
    setCaption(0);
    if (_player.mediaInfo.audio != null && _player.mediaInfo.audio!.length > 1) {
      for (mdk.AudioStreamInfo audioStreamInfo in _player.mediaInfo.audio!) {
        audioTracks.add(
          ext.Track(
            url: "",
            lang:
                "${audioStreamInfo.metadata["title"] ?? ""} (${audioStreamInfo.metadata["language"]} - Embedded)",
            embedded: true,
            embeddedIndex: audioStreamInfo.index,
          ),
        );
      }
    }
    audioTracks.addAll(_video.audioTracks);
    if (audioTracks.isNotEmpty) {
      setAudioTrack(0);
    }
  }

  String _formatMilliseconds(int milliseconds) {
    // Calculate total seconds
    int totalSeconds = milliseconds ~/ 1000;

    // Calculate hours, minutes, and seconds
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    // Return the formatted string
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }
}
