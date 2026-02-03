// External dependencies
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Internal dependencies
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/application/states/calendar_state.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/enums/service.dart';
import 'package:unyo/core/notification/anime_notifier.dart';
import 'package:unyo/core/notification/media_list_notifier.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/data/repositories/anime_repository_anilist.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:unyo/domain/entities/media_list.dart';
import 'package:unyo/domain/entities/user.dart';

class CalendarCubit extends Cubit<CalendarState> with EffectMixin<CalendarState> {
  final Logger _logger = sl<Logger>();
  final AnimeRepositoryAnilist _animeRepositoryAnilist;
  final UserNotifier _loggedUserNotifier;
  final AnimeNotifier _selectedAnimeNotifier;
  final MediaListNotifier _selectedMediaListNotifier;
  late StreamSubscription<User> _loggedUserSubscription;

  CalendarCubit(this._animeRepositoryAnilist, this._loggedUserNotifier, this._selectedAnimeNotifier, this._selectedMediaListNotifier)
    : super(CalendarState(animeCalendarReleases: {}, loggedUser: UserModel.empty())) {
    _init();
  }

  @override
  CalendarState copyStateWithEffects(
    CalendarState state,
    List<AppEffect> effects,
  ) {
    return state.copyWith(effects: effects);
  }

  @override
  Future<void> close() {
    _loggedUserSubscription.cancel();
    return super.close();
  }

  @override
  Logger get logger => _logger;

  void _init() async {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) {
      emit(state.copyWith(loggedUser: loggedUser));
      _getCalendarEvents(loggedUser);
    });
  }

  void navigateToAnimeDetails(Anime anime, MediaList mediaList) {
    _logger.i("Navigating to Anime Details of ${anime.title.userPreferred}");
    _selectedAnimeNotifier.updateSelectedAnime(anime);
    _selectedMediaListNotifier.updateSelectedMediaList(mediaList);
    pushRouteEffect(path: "/animedetails");
  }

  void popScreen(BuildContext context) {
    popRouteEffect(context);
    // close();
  }

  Future<void> _getCalendarEvents(User loggedUser) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anilist calendar releases");
          Map<String, List<Anime>> animeCalendarReleases = await _animeRepositoryAnilist.getCalendarReleases(1, loggedUser);
          emit(
            state.copyWith(
              animeCalendarReleases: animeCalendarReleases,
            ),
          );
        case Service.mal:
        case Service.shikimori:
        case Service.kitsu:
        case Service.simkl:
      }
    } catch (e, stackTrace) {
      handleError("Error fetching user info: $e", stackTrace: stackTrace);
    }
  }
}
