// External dependencies
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'dart:async';

// Internal dependencies
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/application/states/video_state.dart';
import 'package:unyo/core/notification/anime_notifier.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/core/notification/video_info_notifier.dart';
import 'package:unyo/core/services/video/video_service.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:unyo/domain/entities/user.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/video_info.dart';

class VideoCubit extends Cubit<VideoState> with EffectMixin<VideoState> {
  // Repositories
  final Logger _logger = sl<Logger>();

  // Notifiers / Subscriptions
  final UserNotifier _loggedUserNotifier;
  final VideoInfoNotifier _videoInfoNotifier;
  final AnimeNotifier _selectedAnimeNotifier;
  late StreamSubscription<User> _loggedUserSubscription;
  late StreamSubscription<VideoInfo> _videoInfoSubscription;
  late StreamSubscription<Anime> _selectedAnimeSubscription;

  // Services
  late VideoService _videoService;
  bool _videoServiceInitialized = false;

  VideoCubit(this._loggedUserNotifier, this._videoInfoNotifier, this._selectedAnimeNotifier)
    : super(
      VideoState(
      loggedUser: UserModel.empty(),
      videoInfo: VideoInfoModel.empty(),
      selectedAnime: AnimeModel.empty(),
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
    _logger.d("VideoCubit closed and subscriptions cancelled.");
    return super.close();
  }

  void _init() {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) {
      emit(state.copyWith(loggedUser: loggedUser));
    });
    _videoInfoSubscription = _videoInfoNotifier.videoInfoStream.listen((videoInfo) {
      _videoService = VideoService(video: videoInfo.currentVideo, playlistIndex: videoInfo.playlistIndex, lowLatency: false);
      _videoService.setPreventSleep(true);
      _videoServiceInitialized = true;
      emit(state.copyWith(videoInfo: videoInfo, isLoading: false));
    });
    _selectedAnimeSubscription = _selectedAnimeNotifier.animeStream.listen((selectedAnime) {
      emit(state.copyWith(selectedAnime: selectedAnime));
    });
  }

  void navigateBackToAnimeDetailsPage(BuildContext context) {
    _logger.d("Returning to Anime Details Page");
    popRouteEffect(context);
    // The BlocProvider will dispose/close this cubit when the route is popped.
  }
}
