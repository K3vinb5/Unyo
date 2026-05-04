import 'dart:async';
import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:unyo_lib/jmodels/jsanime.dart';
import 'package:unyo_lib/jmodels/jsepisode.dart';
import 'package:unyo_lib/jmodels/jvideo.dart';
import 'package:logger/logger.dart';
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/application/states/anime_details_state.dart';
import 'package:bloc/bloc.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/enums/episode_service.dart';
import 'package:unyo/core/enums/service.dart';
import 'package:unyo/core/notification/anime_genres_notifier.dart';
import 'package:unyo/core/notification/anime_notifier.dart';
import 'package:unyo/core/notification/episode_info_notifier.dart';
import 'package:unyo/core/notification/episodes_notifier.dart';
import 'package:unyo/core/notification/extension_notifier.dart';
import 'package:unyo/core/notification/media_list_entry_notifier.dart';
import 'package:unyo/core/notification/media_list_notifier.dart';
import 'package:unyo/core/notification/reload/reload_notifier.dart';
import 'package:unyo/core/notification/reload/reload_type.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/core/notification/video_info_notifier.dart';
import 'package:unyo/core/services/api/http/http_exception.dart';
import 'package:unyo/data/models/anilist_user_model.dart';
import 'package:unyo/data/models/local_user_model.dart';
import 'package:unyo/data/repositories/anime_repository_anilist.dart';
import 'package:unyo/data/repositories/episode_repository_anizip.dart';
import 'package:unyo/data/repositories/extension_repository_aniyomi.dart';
import 'package:unyo/data/repositories/repositories.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:unyo/domain/entities/anime_details.dart';
import 'package:unyo/domain/entities/episode_info.dart';
import 'package:unyo/domain/entities/extension.dart';
import 'package:unyo/domain/entities/extension/video.dart' as ext;
import 'package:unyo/domain/entities/media_list.dart';
import 'package:unyo/domain/entities/media_list_entry.dart';
import 'package:unyo/domain/entities/settings.dart';
import 'package:unyo/domain/entities/user.dart';
import 'package:unyo/domain/entities/video_info.dart';
import 'package:unyo/presentation/dialogs/anime_details_media_entry_dialog.dart';
import 'package:unyo/presentation/drawers/anime_server_selection_drawer.dart';

class AnimeDetailsCubit extends Cubit<AnimeDetailsState> with EffectMixin<AnimeDetailsState> {
  // Repositories
  final AnimeRepositoryAnilist _animeRepositoryAnilist;
  final EpisodeRepositoryAnizip _episodeRepositoryAnizip;
  final ExtensionRepositoryAniyomi _extensionRepositoryAniyomi;
  final UserRepositoryAnilist _userRepositoryAnilist;

  // Notifiers / Subscriptions
  final UserNotifier _loggedUserNotifier;
  final AnimeNotifier _selectedAnimeNotifier;
  final AnimeGenresNotifier _selectedAnimeAdvancedSearchGenresFilters;
  final MediaListNotifier _selectedMediaListNotifier;
  final VideoInfoNotifier _videoInfoNotifier;
  final EpisodesInfoNotifier _episodesInfoNotifier;
  final MediaListEntryNotifier _mediaListEntryNotifier;
  final ExtensionNotifier _selectedExtensionNotifier;
  final EpisodesNotifier _selectedEpisodesNotifier;
  final ReloadNotifier _reloadNotifier;
  late StreamSubscription<Anime> _selectedAnimeSubscription;
  late StreamSubscription<User> _loggedUserSubscription;
  late StreamSubscription<MediaList> _selectedMediaListSubscription;
  late StreamSubscription<ReloadType> _reloadSubscription;

  // Logger
  final Logger _logger = sl<Logger>();

  AnimeDetailsCubit(
    this._animeRepositoryAnilist,
    this._episodeRepositoryAnizip,
    this._loggedUserNotifier,
    this._selectedAnimeNotifier,
    this._selectedAnimeAdvancedSearchGenresFilters,
    this._selectedMediaListNotifier,
    this._videoInfoNotifier,
    this._extensionRepositoryAniyomi,
    this._userRepositoryAnilist,
    this._episodesInfoNotifier,
    this._mediaListEntryNotifier,
    this._selectedExtensionNotifier,
    this._selectedEpisodesNotifier,
    this._reloadNotifier,
  ) : super(
        AnimeDetailsState(
          loggedUser: UserModel.empty(),
          selectedMediaList: MediaListModel.empty(),
          selectedAnime: AnimeModel.empty(),
          mediaListEntry: MediaListEntryModel.empty(),
          newMediaListEntry: MediaListEntryModel.empty(),
          characters: (false, []),
          recommendations: (false, []),
          episodesInfo: [],
          banners: [],
          alternateImage: '',
          installedExtensions: {},
          selectedExtension: null,
          userLoaded: false,
          animeServerDialogReady: false,
          animeServerDialogLoading: false,
          extensionAnimeResults: [],
          selectedAnimeResultIndex: 0,
          extensionEpisodeResults: [],
          extensionVideoResults: [],
        ),
      ) {
    _init();
  }

  @override
  AnimeDetailsState copyStateWithEffects(AnimeDetailsState state, List<AppEffect> effects) {
    return state.copyWith(effects: effects);
  }

  @override
  Future<void> close() {
    _loggedUserSubscription.cancel();
    _selectedAnimeSubscription.cancel();
    _selectedMediaListSubscription.cancel();
    _reloadSubscription.cancel();
    return super.close();
  }

  @override
  Logger get logger => _logger;

  void _init() {
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) {
      emit(state.copyWith(loggedUser: loggedUser));
      if (!state.userLoaded) {
        _getAnimeBanners(loggedUser);
        emit(state.copyWith(userLoaded: true));
      }
    });
    _selectedAnimeSubscription = _selectedAnimeNotifier.animeStream.listen((anime) {
      _getAnimeDetails(state.loggedUser, anime);
      _getEpisodesDetails(state.loggedUser, anime);
      emit(state.copyWith(selectedAnime: anime));
    });
    _selectedMediaListSubscription = _selectedMediaListNotifier.mediaListStream.listen((mediaList) {
      emit(state.copyWith(selectedMediaList: mediaList));
    });
    _reloadSubscription = _reloadNotifier.reloadStream.listen((reloadType) {
      if (reloadType == ReloadType.videoMediaListEntryUpdated) {
        _logger.i("Reloading Anime Details due to video media list entry update");
        _getUserMediaListEntry(state.loggedUser, state.selectedAnime, ignoreCache: true);
      }
      if (reloadType == ReloadType.animeMediaListEntryUpdated) {
        _logger.i("Reloading Anime Details due to anime media list entry update");
        _getUserMediaListEntry(state.loggedUser, state.selectedAnime, ignoreCache: true);
      }
    });
    _loadInstalledExtensions();
  }

  void navigateBackToAnimePage(BuildContext context) {
    _logger.d("Returning to Anime Page");
    popRouteEffect(context);
    // close();
  }

  void navigateToAnimeDetails(Anime anime, MediaList mediaList) {
    _logger.i("Navigating to Anime Details of ${anime.title.userPreferred}");
    _selectedAnimeNotifier.updateSelectedAnime(anime);
    _selectedMediaListNotifier.updateSelectedMediaList(mediaList);
  }

  void navigateToAnimeAdvancedSearchScreenWithFilters(BuildContext context, String newAnimeGenre) {
    _logger.i("Navigating to Anime Advanced Search Filters");
    bool hasAnimeSearchInStack = AutoRouter.of(
      context,
    ).stackData.any((route) => route.name == "AnimeAdvancedSearchRoute");
    if (hasAnimeSearchInStack) {
      _selectedAnimeAdvancedSearchGenresFilters.updateSelectedAnimeGenre(newAnimeGenre);
      popRouteEffect(context);
    } else {
      _selectedAnimeAdvancedSearchGenresFilters.updateSelectedAnimeGenre(newAnimeGenre);
      pushRouteEffect(path: "/animesearch");
    }
  }

  Future<void> navigateToVideoPlayer(ext.Video selectedVideo, int episodeIndex, int videoIndex) async {
    _logger.i("Navigating to Video Player with selected video from ${state.selectedExtension?.name}");
    _mediaListEntryNotifier.updateSelectedMediaListEntry(state.mediaListEntry);
    _videoInfoNotifier.updateVideoInfo(
        VideoInfoModel(
          currentVideo: selectedVideo,
          alternativeVideos: state.extensionVideoResults,
          videoIndex: videoIndex,
          playlistIndex: episodeIndex,
       )
    );
    pushRouteEffect(path: "/video");
  }

  Future<void> selectAnimeExtension(String? selectedAnimeExtensionName) async {
    Extension? selectedExtension =
        state.installedExtensions
            .where((extension) => selectedAnimeExtensionName == extension.name)
            .firstOrNull;
    if (selectedExtension != null) {
      emit(state.copyWith(selectedExtension: selectedExtension));
      _selectedExtensionNotifier.updateSelectedExtension(selectedExtension);
      switch (state.loggedUser) {
        case AnilistUserModel anilistUserModel:
          SettingsModel userSettings = anilistUserModel.settings as SettingsModel;
          Map<String, Extension> mediaExtensionsConfigUpdated = Map.from(userSettings.mediaExtensionConfigs);
          mediaExtensionsConfigUpdated.addAll({state.selectedAnime.id.toString(): selectedExtension});
          await _userRepositoryAnilist.updateUserInfo(
            anilistUserModel.copyWith(
              settings: userSettings.copyWith(mediaExtensionConfigs: mediaExtensionsConfigUpdated),
            ),
          );
        case LocalUserModel localUserModel:
      }
      _getAnimeInfoFromSelectedExtension(selectedExtension);
    } else {
      _logger.w("Selected extension $selectedAnimeExtensionName not found among installed extensions.");
      showSnackBarEffect(
        "Extension Not Found",
        message: "The selected extension is not installed.",
        contentType: ContentType.warning,
      );
    }
  }

  void openAnimeDetailsMediaEntryDialog(BuildContext context) {
    showWidgetDialogEffect(dialog: AnimeDetailsMediaEntryDialog(cubit: this));
  }

  Future<void> openAnimeServerSelectionDrawer(BuildContext context, int episodeIndex) async {
    if (state.animeServerDialogLoading) return;
    emit(state.copyWith(animeServerDialogReady: false, animeServerDialogLoading: true, extensionVideoResults: []));
    // TODO - You may not want to select the found index (selectedAnimeResultIndex) on extensionAnimeResults
    bool canOpenDrawer = await _getEpisodesFromSelectedExtension(
      state.selectedExtension,
      state.extensionAnimeResults[state.selectedAnimeResultIndex],
    );
    if (!canOpenDrawer) {
      emit(state.copyWith(animeServerDialogLoading: false));
     return;
    }
    showDrawerDialogEffect(
        drawerDialog: AnimeServerSelectionDrawer(
          cubit: this,
          episodeIndex: episodeIndex,
          onOpen: () async {
            if (episodeIndex >= state.extensionEpisodeResults.length) {
              _logger.w("Episode index $episodeIndex is out of bounds for extension episode results.");
              showSnackBarEffect("${state.selectedExtension?.name} Error", message: "Only ${state.extensionEpisodeResults.length} episodes were found", contentType: ContentType.warning);
              return false;
            }
            bool shouldKeepDialog = await _getVideosFromSelectedExtension(
              state.selectedExtension,
              state.extensionEpisodeResults[episodeIndex],
            );
            if (!shouldKeepDialog && context.mounted) {
              emit(state.copyWith(animeServerDialogReady: false, animeServerDialogLoading: false));
              return false;
            }
            emit(state.copyWith(animeServerDialogReady: true, animeServerDialogLoading: false));
            return true;
          },
        ),
        backgroundColor: Colors.black.withValues(alpha: 0.55),
        startPosition: AxisDirection.down
    );
  }

  Future<void> updateMediaListEntry(BuildContext context) async {
    MediaListEntry desiredMediaListEntry = state.newMediaListEntry;
    MediaListEntry beforeUpdateMediaListEntry = state.mediaListEntry;
    try {
      switch (state.loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Updating Media List Entry to $desiredMediaListEntry on Anilist");
          await _animeRepositoryAnilist.updateMediaListEntry(
            desiredMediaListEntry,
            state.selectedAnime,
            state.loggedUser,
          );
          _reloadNotifier.emitReload(ReloadType.animeMediaListEntryUpdated);
          if (desiredMediaListEntry.status != beforeUpdateMediaListEntry.status) {
            _reloadNotifier.emitReload(ReloadType.homeMediaListEntryUpdated);
          }
        case Service.mal:
          _logger.i("Updating Media List Entry to $desiredMediaListEntry on MyAnimeList");
        case Service.shikimori:
          _logger.i("Updating Media List Entry to $desiredMediaListEntry on Shikimori");
        case Service.kitsu:
          _logger.i("Updating Media List Entry to $desiredMediaListEntry on Kitsu");
        case Service.simkl:
          _logger.i("Updating Media List Entry to $desiredMediaListEntry on Simkl");
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError("Error updating Anime Entry:", responseBody: e.message, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry: $e", stackTrace: stackTrace);
    }
    if (!context.mounted) return;
    popRouteEffect(context);
  }

  Future<void> updateMediaListEntryStatus(String? newStatus) async {
    if (newStatus == null) return;
    try {
      MediaListEntry updatedMediaListEntry = (state.newMediaListEntry as MediaListEntryModel).copyWith(
        status: newStatus,
      );
      emit(state.copyWith(newMediaListEntry: updatedMediaListEntry));
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry status: $e", stackTrace: stackTrace);
    }
  }

  Future<void> updateMediaListEntryProgress(int? newProgress) async {
    if (newProgress == null) return;
    try {
      MediaListEntry updatedMediaListEntry = (state.newMediaListEntry as MediaListEntryModel).copyWith(
        progress: newProgress,
      );
      emit(state.copyWith(newMediaListEntry: updatedMediaListEntry));
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry progress: $e", stackTrace: stackTrace);
    }
  }

  Future<void> updateMediaListEntryScore(double? newScore) async {
    if (newScore == null) return;
    try {
      MediaListEntry updatedMediaListEntry = (state.newMediaListEntry as MediaListEntryModel).copyWith(
        score: newScore,
      );
      emit(state.copyWith(newMediaListEntry: updatedMediaListEntry));
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry score: $e", stackTrace: stackTrace);
    }
  }

  Future<void> updateMediaListEntryRepeat(int? newRepeat) async {
    if (newRepeat == null) return;
    try {
      MediaListEntry updatedMediaListEntry = (state.newMediaListEntry as MediaListEntryModel).copyWith(
        repeat: newRepeat,
      );
      emit(state.copyWith(newMediaListEntry: updatedMediaListEntry));
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry repeat: $e", stackTrace: stackTrace);
    }
  }

  Future<void> updateMediaListEntryStartedAt(BuildContext context) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDateTime == null) return;
    try {
      MediaListEntry updatedMediaListEntry = (state.newMediaListEntry as MediaListEntryModel).copyWith(
        startedAt: [
          selectedDateTime.day.toString(),
          selectedDateTime.month.toString(),
          selectedDateTime.year.toString(),
        ],
      );
      emit(state.copyWith(newMediaListEntry: updatedMediaListEntry));
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry started at: $e", stackTrace: stackTrace);
    }
  }

  Future<void> updateMediaListEntryCompletedAt(BuildContext context) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDateTime == null) return;
    try {
      MediaListEntry updatedMediaListEntry = (state.newMediaListEntry as MediaListEntryModel).copyWith(
        completedAt: [
          selectedDateTime.day.toString(),
          selectedDateTime.month.toString(),
          selectedDateTime.year.toString(),
        ],
      );
      emit(state.copyWith(newMediaListEntry: updatedMediaListEntry));
    } catch (e, stackTrace) {
      handleError("Error updating Anime Entry completed at: $e", stackTrace: stackTrace);
    }
  }

  Future<void> _getUserMediaListEntry(User loggedUser, Anime selectedAnime, {bool ignoreCache = false}) async {
   try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching User Media List Entry from AniList for ${state.selectedAnime.title.userPreferred}");
          MediaListEntry mediaListEntry = await _animeRepositoryAnilist.getMediaListEntry(
            selectedAnime,
            loggedUser,
            ignoreCache: ignoreCache,
          );
          emit(state.copyWith(mediaListEntry: mediaListEntry, newMediaListEntry: mediaListEntry));
          _mediaListEntryNotifier.updateSelectedMediaListEntry(mediaListEntry);
        case Service.mal:
          _logger.i("Fetching User Media List Entry from MyAnimeList for ${state.selectedAnime.title.userPreferred}");
        case Service.shikimori:
          _logger.i("Fetching User Media List Entry from Shikimori for ${state.selectedAnime.title.userPreferred}");
        case Service.kitsu:
          _logger.i("Fetching User Media List Entry from Kitsu for ${state.selectedAnime.title.userPreferred}");
        case Service.simkl:
          _logger.i("Fetching User Media List Entry from Simkl for ${state.selectedAnime.title.userPreferred}");
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError("Error fetching User Media List entry:", responseBody: e.message, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      handleError("Error fetching User Media List Entry: $e", stackTrace: stackTrace);
    }
  }

  Future<void> _getAnimeDetails(User loggedUser, Anime selectedAnime) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anime Details from AniList for ${state.selectedAnime.title.userPreferred}");
          (bool, AnimeDetails) animeDetails = await _animeRepositoryAnilist.getAnimeDetails(
            selectedAnime,
            loggedUser,
          );
          emit(
            state.copyWith(
              characters: (animeDetails.$2.characters.isNotEmpty, animeDetails.$2.characters),
              mediaListEntry: animeDetails.$2.mediaListEntry,
              newMediaListEntry: animeDetails.$2.mediaListEntry,
              recommendations: (
                animeDetails.$2.recommendedAnimes.isNotEmpty,
                animeDetails.$2.recommendedAnimes,
              ),
            ),
          );
          if (animeDetails.$2.recommendedAnimes.isEmpty) {
            (bool, List<Anime>) trendingAnimes = await _animeRepositoryAnilist.getTrendingAnimes(
              1,
              loggedUser,
            );
            emit(state.copyWith(recommendations: (trendingAnimes.$1, trendingAnimes.$2.shuffled(Random()))));
          }
          _getAlternativeImage(loggedUser, selectedAnime);
        case Service.mal:
          _logger.i("Fetching Anime Details from MyAnimeList for ${state.selectedAnime.title.userPreferred}");
        case Service.shikimori:
          _logger.i("Fetching Anime Details from Shikimori for ${state.selectedAnime.title.userPreferred}");
        case Service.kitsu:
          _logger.i("Fetching Anime Details from Kitsu for ${state.selectedAnime.title.userPreferred}");
        case Service.simkl:
          _logger.i("Fetching Anime Details from Simkl for ${state.selectedAnime.title.userPreferred}");
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError("Error fetching Anime details:", responseBody: e.message, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      handleError("Error fetching Anime Details: $e", stackTrace: stackTrace);
    }
  }

  Future<void> _loadInstalledExtensions() async {
    try {
      _logger.i("Loading installed extensions for Aniyomi");
      Set<Extension> installedExtensions = await _extensionRepositoryAniyomi.getInstalledAnimeExtensions(
        state.loggedUser,
      );
      emit(state.copyWith(installedExtensions: installedExtensions));
      _setSelectedExtension(state.loggedUser, state.selectedAnime);
    } catch (e, stackTrace) {
      handleError("Failed to load installed extensions $e", stackTrace: stackTrace);
    }
  }

  Future<void> _getAnimeInfoFromSelectedExtension(Extension selectedExtension) async {
    try {
      if (state.installedExtensions.isEmpty) {
        _logger.w("No installed extensions available to fetch anime info.");
        showSnackBarEffect(
          "No Installed Extensions",
          message: "Install some extensions if you want to watch some content",
          contentType: ContentType.warning,
        );
        return;
      }
      _logger.i(
        "Fetching Anime Info from extension ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}",
      );
      List<JSAnime> animeResults = await _extensionRepositoryAniyomi.getAnimeSearchResults(
        state.selectedAnime.title.userPreferred,
        selectedExtension,
      );
      if (animeResults.isEmpty) {
        _logger.w("No results found in ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}, trying alternative english title.");
        animeResults = await _extensionRepositoryAniyomi.getAnimeSearchResults(
          state.selectedAnime.title.english,
          selectedExtension,
        );
      }
      if (animeResults.isEmpty) {
        _logger.w("No results found in ${selectedExtension.name} for ${state.selectedAnime.title.english}, trying alternative native title.");
        animeResults = await _extensionRepositoryAniyomi.getAnimeSearchResults(
          state.selectedAnime.title.nativeTitle,
          selectedExtension,
        );
      }
      if (animeResults.isEmpty) {
        _logger.w("No results found in ${selectedExtension.name} for ${state.selectedAnime.title.nativeTitle}, trying alternative romaji title.");
        animeResults = await _extensionRepositoryAniyomi.getAnimeSearchResults(
          state.selectedAnime.title.romaji,
          selectedExtension,
        );
      }
      int selectedAnimeResultIndex = await _fuzzySelectAnimeResultIndex(animeResults);
      emit(state.copyWith(extensionAnimeResults: animeResults, selectedAnimeResultIndex: selectedAnimeResultIndex));
      if (animeResults.isNotEmpty) {
        showSnackBarEffect(
          selectedExtension.name,
          message: "Found: ${animeResults[selectedAnimeResultIndex].getTitle()}",
          contentType: ContentType.success,
        );
      } else {
        showSnackBarEffect(
          selectedExtension.name,
          message:
              "No results found in ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}",
          contentType: ContentType.warning,
        );
      }
    } catch (e, stackTrace) {
      handleError("Error fetching Anime Info from selected extension: $e", stackTrace: stackTrace);
    }
  }

  Future<int> _fuzzySelectAnimeResultIndex(List<JSAnime> animeResults) async {
    Set<String> animeTitles = {
      state.selectedAnime.title.userPreferred.toLowerCase(),
      if (state.selectedAnime.title.english.isNotEmpty)
        state.selectedAnime.title.english.toLowerCase(),
      if (state.selectedAnime.title.romaji.isNotEmpty)
        state.selectedAnime.title.romaji.toLowerCase(),
      if (state.selectedAnime.title.nativeTitle.isNotEmpty)
        state.selectedAnime.title.nativeTitle.toLowerCase(),
    };
    List<(int, JSAnime)> resultScores = [];
    for (var validTitle in animeTitles) {
      for (var animeResult in animeResults) {
        String testingTitle = animeResult.getTitle().toDartString().toLowerCase();
        int score = tokenSortRatio(validTitle, testingTitle);
        resultScores.add((score, animeResult));
      }
    }
    resultScores.sort((a, b) => b.$1.compareTo(a.$1));
    return animeResults.indexOf(resultScores.first.$2);
  }

  Future<bool> _getEpisodesFromSelectedExtension(
    Extension? selectedExtension,
    JSAnime? selectedJSAnime,
  ) async {
    if (selectedExtension == null) {
      _logger.w("No extension selected to fetch episodes.");
      showSnackBarEffect(
        "No Extension Selected",
        message: "Select an extension to fetch episodes.",
        contentType: ContentType.warning,
      );
      return false;
    } else if (selectedJSAnime == null) {
      _logger.w("No JSAnime selected to fetch episodes.");
      showSnackBarEffect(
        "No Anime Selected",
        message: "Select an anime to fetch episodes.",
        contentType: ContentType.warning,
      );
      return false;
    }
    try {
      _logger.i(
        "Fetching Episodes Info from extension ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}",
      );
      List<JSEpisode> episodeResults = await _extensionRepositoryAniyomi.getAnimeEpisodeList(
        selectedJSAnime,
        selectedExtension,
      );
      if (episodeResults.isNotEmpty) {
        List<JSEpisode> sortedEpisodes = episodeResults.sorted((animeEpisode1, animeEpisode2) => animeEpisode1.getEpisode_number().toInt() - animeEpisode2.getEpisode_number().toInt());
        emit(state.copyWith(extensionEpisodeResults: sortedEpisodes));
        _selectedEpisodesNotifier.updateSelectedJSEpisodes(sortedEpisodes);
        return true;
      } else {
        showSnackBarEffect(
          selectedExtension.name,
          message:
              "No episodes found in ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}",
          contentType: ContentType.warning,
        );
        return false;
      }
    } catch (e, stackTrace) {
      handleError("Error fetching Episodes Info from selected extension: $e", stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> _getVideosFromSelectedExtension(
    Extension? selectedExtension,
    JSEpisode? selectedJSEpisode,
  ) async {
    if (selectedExtension == null) {
      _logger.w("No extension selected to fetch videos.");
      showSnackBarEffect(
        "No Extension Selected",
        message: "Select an extension to fetch videos.",
        contentType: ContentType.warning,
      );
      return false;
    } else if (selectedJSEpisode == null) {
      _logger.w("No JSEpisode selected to fetch videos.");
      showSnackBarEffect(
        "No Episode Selected",
        message: "Select an episode to fetch videos.",
        contentType: ContentType.warning,
      );
      return false;
    }
    try {
      _logger.i(
        "Fetching Videos Info from extension ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}",
      );
      List<JVideo> videoResults = await _extensionRepositoryAniyomi.getAnimeVideoList(
        selectedJSEpisode,
        selectedExtension,
      );
      if (videoResults.isNotEmpty) {
        emit(state.copyWith(extensionVideoResults: videoResults.map((jVideo) => ext.Video.fromJVideo(jVideo)).toList()));
        return true;
      } else {
        showSnackBarEffect(
          selectedExtension.name,
          message:
              "No video links found in ${selectedExtension.name} for ${state.selectedAnime.title.userPreferred}",
          contentType: ContentType.warning,
        );
        return false;
      }
    } catch (e, stackTrace) {
      handleError("Error fetching Videos Info from selected extension: $e", stackTrace: stackTrace);
      return false;
    }
  }

  Future<void> _getAlternativeImage(User loggedUser, Anime selectedAnime) async {
    try {
      switch (loggedUser.settings.episodeService) {
        case EpisodeService.anizip:
          _logger.i("Fetching Alternative Image from Anizip for ${state.selectedAnime.title.userPreferred}");
          late String alternateImage;
          if (loggedUser.settings.service == Service.anilist) {
            alternateImage = await _episodeRepositoryAnizip.getAlternativeImage(
              malId: -1,
              anilistId: selectedAnime.id,
            );
          } else {
            alternateImage = await _episodeRepositoryAnizip.getAlternativeImage(
              malId: selectedAnime.idMal,
              anilistId: -1,
            );
          }
          emit(state.copyWith(alternateImage: alternateImage));
        case EpisodeService.kitsu:
          _logger.i("Fetching Alternative Image from Kitsu for ${state.selectedAnime.title.userPreferred}");
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError("Error fetching Alternative Image:", responseBody: e.message, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      handleError("Error fetching Alternative Image: $e", stackTrace: stackTrace);
    }
  }

  Future<void> _getEpisodesDetails(User loggedUser, Anime selectedAnime) async {
    try {
      switch (loggedUser.settings.episodeService) {
        case EpisodeService.anizip:
          _logger.i("Fetching Episodes Details from Anizip for ${state.selectedAnime.title.userPreferred}");
          late List<EpisodeInfo> episodesInfo;
          if (loggedUser.settings.service == Service.anilist) {
            episodesInfo = await _episodeRepositoryAnizip.getEpisodeInfo(
              malId: -1,
              anilistId: selectedAnime.id,
            );
          } else {
            episodesInfo = await _episodeRepositoryAnizip.getEpisodeInfo(
              malId: selectedAnime.idMal,
              anilistId: -1,
            );
          }
          emit(state.copyWith(episodesInfo: episodesInfo));
          _episodesInfoNotifier.updateSelectedEpisodeInfo(episodesInfo);
        case EpisodeService.kitsu:
          _logger.i("Fetching Episodes Details from Kitsu for ${state.selectedAnime.title.userPreferred}");
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError("Error fetching Episodes details:", responseBody: e.message, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      handleError("Error fetching Episodes Details: $e", stackTrace: stackTrace);
    }
  }

  Future<void> _getAnimeBanners(User loggedUser) async {
    try {
      switch (loggedUser.settings.service) {
        case Service.anilist:
          _logger.i("Fetching Anime Banners from AniList for ${state.selectedAnime.title.userPreferred}");
          List<String> banners = await _animeRepositoryAnilist.getMediaCoverImages(loggedUser);
          emit(state.copyWith(banners: banners));
        case Service.mal:
          _logger.i("Fetching Anime Banners from MyAnimeList for ${state.selectedAnime.title.userPreferred}");
        case Service.shikimori:
          _logger.i("Fetching Anime Banners from Shikimori for ${state.selectedAnime.title.userPreferred}");
        case Service.kitsu:
          _logger.i("Fetching Anime Banners from Kitsu for ${state.selectedAnime.title.userPreferred}");
        case Service.simkl:
          _logger.i("Fetching Anime Banners from Simkl for ${state.selectedAnime.title.userPreferred}");
      }
    } on HttpServerException catch (e, stackTrace) {
      handleError("Error fetching Anime banners:", responseBody: e.message, stackTrace: stackTrace);
    } catch (e, stackTrace) {
      handleError("Error fetching Anime Banners: $e", stackTrace: stackTrace);
    }
  }

  Future<void> _setSelectedExtension(User loggedUser, Anime selectedAnime) async {
    try {
      switch (loggedUser) {
        case AnilistUserModel anilistUserModel:
          SettingsModel userSettings = anilistUserModel.settings as SettingsModel;
          Extension? selectedExtension = userSettings.mediaExtensionConfigs[selectedAnime.id.toString()];
          if (selectedExtension != null) {
            selectAnimeExtension(selectedExtension.name);
          }
        case LocalUserModel localUserModel:
      }
    } catch (e, stackTrace) {
      handleError("Error setting selected extension: $e", stackTrace: stackTrace);
    }
  }
}
