// External dependencies
import 'dart:async';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fvp/mdk.dart' as mdk;
import 'package:logger/logger.dart';

// Internal dependencies
import 'package:unyo/domain/entities/extension/headers.dart' as ext;
import 'package:unyo/domain/entities/extension/track.dart' as ext;
import 'package:unyo/domain/entities/extension/video.dart' as ext;
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/services/torrent/torrent_service.dart';
import 'package:unyo/domain/entities/torrent/torrent_file_stat.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:window_manager/window_manager.dart';

class VideoService {
  // Services
  final Logger _logger = sl<Logger>();
  final TorrentService _torrentService = sl<TorrentService>();
  final Set<String> _torrentHashes = {};

  ext.Video _video;
  List<ext.Video> _alternativeVideos;
  int _videoIndex;
  int _episodeIndex; // This will be used for getting the correct video out of a playlist from a magnet / torrent
  final void Function(String) _onErrorCallback;

  late final mdk.Player _player;
  final List<ext.Track> captionTracks = [];
  final List<ext.Track> audioTracks = [];
  ext.Track? _currentCaptionTrack;
  ext.Track? _currentAudioTrack;

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
    _player = mdk.Player();
    _configureDecoder();
    _configurePlayer();
    _setPlayerHttpHeaders(_video.headers);
    _initAsync();
  }

  /// Inits asynchronous properties and sets player media
  Future<void> _initAsync() async {
    _initialFullscreen = await windowManager.isFullScreen();
    _isFullscreen = _initialFullscreen;
    try {
      final resolvedUrl = await _resolveVideoUrl(_video.videoUrl);
      _player.setMedia(resolvedUrl, mdk.MediaType.video);
      _player.setMedia(resolvedUrl, mdk.MediaType.audio);
    } catch (e, st) {
      _logger.e("Failed to resolve video URL in _initAsync", error: e, stackTrace: st);
      _onErrorCallback(e.toString());
    }
    _player.loop = 0;
    _player.state = mdk.PlaybackState.paused;
    _player.onMediaStatus(_onMediaStatusInit);
  }

  Future<void> changeVideo({
    required ext.Video video,
    required List<ext.Video> alternativeVideos,
    required int videoIndex,
    required int episodeIndex,
  }) async {
    _attemptDisposeTorrent();
    _video = video;
    _alternativeVideos = alternativeVideos;
    _videoIndex = videoIndex;
    _episodeIndex = episodeIndex;
    try {
      final resolvedUrl = await _resolveVideoUrl(_video.videoUrl);
      _player.setMedia(resolvedUrl, mdk.MediaType.video);
      _player.setMedia(resolvedUrl, mdk.MediaType.audio);
    } catch (e, st) {
      _logger.e("Failed to resolve video URL on change", error: e, stackTrace: st);
      _onErrorCallback(e.toString());
    }
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

  bool get isVideoReady => _isVideoReady;

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

  int get videoIndex => _videoIndex;

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

  bool seekTo(Duration newPosition) {
    if (newPosition > duration) {
      _player.seek(position: duration.inMilliseconds, flags: _seekFlags);
    } else if (newPosition < Duration.zero) {
      _player.seek(position: 0, flags: _seekFlags);
    }
    _player.seek(position: newPosition.inMilliseconds, flags: _seekFlags);
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

  bool resetService() {
    _player.state = mdk.PlaybackState.paused;
    _isBuffering = true;
    _isVideoReady = false;
    _isBuffering = true;
    _isLoading = false;
    return true;
  }

  Future<void> swapVideoUrl(int index) async {
    if (index < 0 || index >= _alternativeVideos.length) {
      return;
    }
    pause();
    ext.Video video = _alternativeVideos[index];
    _videoIndex = index;
    _video = video;
    final position = this.position;
    await _player.seek(position: 0, flags: _seekFlags);
    try {
      final resolvedUrl = await _resolveVideoUrl(video.videoUrl);
      _player.setMedia(resolvedUrl, mdk.MediaType.video);
      _player.setMedia(resolvedUrl, mdk.MediaType.audio);
    } catch (e, st) {
      _logger.e("Failed to resolve video URL on swap", error: e, stackTrace: st);
      _onErrorCallback(e.toString());
      return;
    }
    _initCaptionsAndAudiotracks();
    await Future.delayed(const Duration(milliseconds: 500));
    await _player.seek(position: position.inMilliseconds, flags: _seekFlags);
    play();
  }

  bool setCaption(int captionIndex) {
    if (captionIndex < 0 || captionIndex >= captionTracks.length) {
      _currentCaptionTrack = null;
      return false;
    }
    _currentCaptionTrack = captionTracks[captionIndex];
    if (_currentCaptionTrack!.embedded) {
      _player.setActiveTracks(mdk.MediaType.subtitle, [_currentCaptionTrack?.embeddedIndex ?? 0]);
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
      _player.setActiveTracks(mdk.MediaType.audio, [_currentAudioTrack?.embeddedIndex ?? 0]);
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
    _attemptDisposeTorrent();
  }

  // Magnet / Torrent resolution
  Future<String> _resolveVideoUrl(String url) async {
    if (!url.toLowerCase().startsWith("magnet:")) {
      return url;
    }
    final cleanMagnet = _cleanMagnetUrl(url);
    final hash = _extractHashFromMagnet(cleanMagnet);
    final status = await _torrentService.addTorrent(cleanMagnet);
    _torrentHashes.add(status.hash);
    if (status.stat >= 2 && status.fileStats.isNotEmpty) {
      final fileIndex = _selectFileIndex(status.fileStats, _episodeIndex);
      return _torrentService.getStreamUrl(hash, fileIndex);
    }
    _logger.w("No metadata available, streaming with fallback index $_episodeIndex");
    return _torrentService.getStreamUrl(hash, _episodeIndex);
  }

  int _selectFileIndex(List<TorrentFileStat> files, int episodeIndex) {
    if (files.isEmpty) return 0;
    if (files.length == 1) return files.first.id;

    // Strategy 1: Fuzzy match filename against episode patterns
    final patterns = [
      "episode $episodeIndex",
      "e$episodeIndex",
      "ep$episodeIndex",
      episodeIndex.toString().padLeft(2, '0'),
    ];
    final List<(int, TorrentFileStat)> allScores = [];
    for (final pattern in patterns) {
      for (final file in files) {
        final fileName = file.path.toLowerCase();
        final score = tokenSortRatio(pattern, fileName);
        allScores.add((score, file));
      }
    }
    allScores.sort((a, b) => b.$1.compareTo(a.$1));
    if (allScores.isNotEmpty && allScores.first.$1 > 60) {
      return allScores.first.$2.id;
    }

    // Strategy 2: Direct id match with episode index
    final directMatch = files.firstWhereOrNull((f) => f.id == episodeIndex);
    if (directMatch != null) return directMatch.id;

    // Strategy 3: Fallback to first file
    return files.first.id;
  }

  /// Removes non-standard query parameters (like `index`) that extensions append
  /// to magnet URIs, since torrserver may not handle them gracefully.
  String _cleanMagnetUrl(String magnet) {
    try {
      final uri = Uri.parse(magnet);
      final standardParams = ['xt', 'dn', 'tr', 'ws', 'xs', 'as', 'mt', 'kt'];
      final cleanedQuery = Map<String, List<String>>.fromEntries(
        uri.queryParametersAll.entries.where((e) => standardParams.contains(e.key.toLowerCase())),
      );
      final cleanedUri = uri.replace(queryParameters: cleanedQuery.isEmpty ? null : cleanedQuery);
      return cleanedUri.toString();
    } catch (e) {
      return magnet;
    }
  }

  String _extractHashFromMagnet(String magnet) {
    try {
      final uri = Uri.parse(magnet);
      final xt = uri.queryParameters['xt'];
      if (xt != null && xt.startsWith("urn:btih:")) {
        return xt.substring("urn:btih:".length).toLowerCase();
      }
    } catch (e) {
      _logger.w("Failed to parse magnet URI: $e");
    }
    // Fallback: try to extract 40-char hex hash from the string
    final hexHashMatch = RegExp(r'([0-9a-fA-F]{40})').firstMatch(magnet);
    if (hexHashMatch != null) {
      return hexHashMatch.group(1)!.toLowerCase();
    }
    _logger.e("Could not extract infohash from magnet URI");
    throw Exception("Could not extract infohash from magnet URI");
  }

  void _attemptDisposeTorrent() {
    for (final hash in _torrentHashes) {
      _torrentService.removeTorrent(hash);
    }
    _torrentHashes.clear();
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

  void _initCaptionsAndAudiotracks() {
    captionTracks.clear();
    audioTracks.clear();
    if (_player.mediaInfo.subtitle != null && _player.mediaInfo.subtitle!.isNotEmpty) {
      for (mdk.SubtitleStreamInfo subtitleStreamInfo in _player.mediaInfo.subtitle!) {
        captionTracks.add(
          ext.Track(
            url: "",
            lang:
                "${subtitleStreamInfo.metadata["title"] ?? ""} (${subtitleStreamInfo.metadata["language"]} - Embedded)",
            embedded: true,
            embeddedIndex: subtitleStreamInfo.index,
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
