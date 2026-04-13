// External dependencies
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// Internal dependencies
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/application/states/anime_state.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/enums/service.dart';
import 'package:unyo/core/notification/anime_genres_notifier.dart';
import 'package:unyo/core/notification/anime_notifier.dart';
import 'package:unyo/core/notification/media_list_notifier.dart';
import 'package:unyo/core/notification/reload/reload_type.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/core/services/api/http/http_exception.dart';
import 'package:unyo/data/repositories/anime_repository_anilist.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:unyo/domain/entities/media_list.dart';
import 'package:unyo/domain/entities/user.dart';

import '../../core/notification/reload/reload_notifier.dart';

class AnimeCubit extends Cubit<AnimeState> with EffectMixin<AnimeState> {
  final AnimeRepositoryAnilist _animeRepositoryAnilist;
  final UserNotifier _loggedUserNotifier;
  final AnimeNotifier _selectedAnimeNotifier;
  final AnimeGenresNotifier _selectedAnimeAdvancedSearchGenresFilters;
  final MediaListNotifier _selectedMediaListNotifier;
  final ReloadNotifier _reloadNotifier;
  late StreamSubscription<User> _loggedUserSubscription;
  late StreamSubscription<ReloadType> _reloadSubscription;
  final Logger _logger = sl<Logger>();

  AnimeCubit(
    this._animeRepositoryAnilist,
    this._loggedUserNotifier,
    this._selectedAnimeNotifier,
    this._selectedAnimeAdvancedSearchGenresFilters,
    this._selectedMediaListNotifier,
    this._reloadNotifier,
  )
    : super(
        AnimeState(
          recentlyReleased: (false, []),
          popular: (false, []),
          trending: (false, []),
          recentlyCompleted: (false, []),
          upcoming: (false, []),
          banners: [],
          loggedUser: UserModel.empty(),
          isLoading: true,
          selectionDialogLoading: true,
          userLoaded: false,
        ),
      ) {
    _init();
  }

  @override
  AnimeState copyStateWithEffects(AnimeState state, List<AppEffect> effects) {
    return state.copyWith(effects: effects);
  }

  @override
  Logger get logger => _logger;

  @override
  Future<void> close() {
    _loggedUserSubscription.cancel();
    _reloadSubscription.cancel();
    return super.close();
  }

  // TODO develop some loading states for the widgets and remove the awaits to make the load look faster
  void _init() async {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((
      loggedUser,
    ) async {
      emit(state.copyWith(loggedUser: loggedUser));
      if (!state.userLoaded) {
        await _fetchRecentlyReleased(1, loggedUser);
        await _fetchTrending(1, loggedUser);
        await _fetchRecentlyCompleted(1, loggedUser);
        await _fetchPopular(1, loggedUser);
        await _fetchUpcoming(1, loggedUser);
        emit(state.copyWith(userLoaded: true, isLoading: false));
      }
    });
    _reloadSubscription = _reloadNotifier.reloadStream.listen((reloadType) async {
      if (reloadType == ReloadType.newMetadataService) {
        _logger.i("Reloading Anime Screen due to new metadata service");
        if (!state.userLoaded) {
          _fetchRecentlyReleased(1, state.loggedUser, ignoreCache: true);
          _fetchTrending(1, state.loggedUser, ignoreCache: true);
          _fetchRecentlyCompleted(1, state.loggedUser, ignoreCache: true);
          _fetchPopular(1, state.loggedUser, ignoreCache: true);
          _fetchUpcoming(1, state.loggedUser, ignoreCache: true);
        }
      }
    });
  }

  void navigateToCalendar(BuildContext context) {
    _logger.i("Navigating to Anime Calendar");
    pushRouteEffect(path: "/calendar");
  }

  void navigateToAdvancedSearch(BuildContext context) {
    _logger.i("Navigating to Anime Advanced Search");
    _selectedAnimeAdvancedSearchGenresFilters.updateSelectedAnimeGenre("");
    pushRouteEffect(path: "/animesearch");
  }

  void navigateToAnimeDetails(Anime anime, MediaList mediaList) {
    _logger.i("Navigating to Anime Details of ${anime.title.userPreferred}");
    _selectedAnimeNotifier.updateSelectedAnime(anime);
    _selectedMediaListNotifier.updateSelectedMediaList(mediaList);
    pushRouteEffect(path: "/animedetails");
  }

  Future<void> _fetchRecentlyReleased(int page, User loggedUser, {bool ignoreCache = false}) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anilist recently released anime");
          (bool, List<Anime>) recentlyReleased = await _animeRepositoryAnilist
              .getRecentlyReleasedAnimes(page, loggedUser, ignoreCache: ignoreCache);
          emit(state.copyWith(recentlyReleased: recentlyReleased));
        case Service.mal:
        case Service.kitsu:
        case Service.shikimori:
        case Service.simkl:
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError(
        "Failed to fetch recently released anime:",
        responseBody: e.message,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      handleError(
        "Failed to fetch recently released anime $e",
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _fetchTrending(int page, User loggedUser, {bool ignoreCache = false}) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anilist trending anime");
          (bool, List<Anime>) trending = await _animeRepositoryAnilist
              .getTrendingAnimes(page, loggedUser, ignoreCache: ignoreCache);
          emit(state.copyWith(trending: trending));
          if (page == 1) {
            List<Anime> banners = trending.$2.where((anime) => anime.bannerImage != "").toList();
            emit(
              state.copyWith(
                banners: banners.sublist(
                  0,
                  banners.length > 20 ? 20 : banners.length,
                ),
              ),
            );
          }
        case Service.mal:
        case Service.kitsu:
        case Service.shikimori:
        case Service.simkl:
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError(
        "Failed to fetch trending anime:",
        responseBody: e.message,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      handleError("Failed to fetch trending anime $e", stackTrace: stackTrace);
    }
  }

  Future<void> _fetchPopular(int page, User loggedUser, {bool ignoreCache = false}) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anilist popular anime");
          (bool, List<Anime>) popular = await _animeRepositoryAnilist
              .getPopularAnimes(page, loggedUser, ignoreCache: ignoreCache);
          emit(state.copyWith(popular: popular));
        case Service.mal:
        case Service.kitsu:
        case Service.shikimori:
        case Service.simkl:
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError(
        "Failed to fetch popular anime:",
        responseBody: e.message,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      handleError("Failed to fetch popular anime $e", stackTrace: stackTrace);
    }
  }

  Future<void> _fetchRecentlyCompleted(int page, User loggedUser, {bool ignoreCache = false}) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anilist recently completed anime");
          (bool, List<Anime>) recentlyCompleted = await _animeRepositoryAnilist
              .getRecentlyCompletedAnimes(page, loggedUser, ignoreCache: ignoreCache);
          emit(state.copyWith(recentlyCompleted: recentlyCompleted));
        case Service.mal:
        case Service.kitsu:
        case Service.shikimori:
        case Service.simkl:
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError(
        "Failed to fetch recently completed anime:",
        responseBody: e.message,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      handleError(
        "Failed to fetch recently completed anime $e",
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _fetchUpcoming(int page, User loggedUser, {bool ignoreCache = false}) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anilist upcoming anime");
          (bool, List<Anime>) upcoming = await _animeRepositoryAnilist
              .getUpcomingAnimes(page, loggedUser, ignoreCache: ignoreCache);
          emit(state.copyWith(upcoming: upcoming));
        case Service.mal:
        case Service.kitsu:
        case Service.shikimori:
        case Service.simkl:
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError(
        "Failed to fetch upcoming anime:",
        responseBody: e.message,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      handleError("Failed to fetch upcoming anime $e", stackTrace: stackTrace);
    }
  }
}
