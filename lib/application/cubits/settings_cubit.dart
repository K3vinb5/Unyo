import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Internal dependencies
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/application/states/settings_state.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/notification/reload/reload_notifier.dart';
import 'package:unyo/core/notification/reload/reload_type.dart';
import 'package:unyo/core/notification/user_notifier.dart';
import 'package:unyo/core/services/media/episode_service.dart';
import 'package:unyo/core/services/media/media_service.dart';
import 'package:unyo/data/models/anilist_user_model.dart';
import 'package:unyo/data/models/local_user_model.dart';
import 'package:unyo/data/repositories/repositories.dart';
import 'package:unyo/domain/entities/settings.dart';
import 'package:unyo/domain/entities/user.dart';
import 'package:unyo/presentation/dialogs/textfield_dialog.dart';

class SettingsCubit extends Cubit<SettingsState> with EffectMixin<SettingsState> {
  final Logger _logger = sl<Logger>();
  final UserRepositoryAnilist _userRepositoryAnilist;
  final UserRepositoryLocal _userRepositoryLocal;
  final UserNotifier _loggedUserNotifier;
  final ReloadNotifier _reloadNotifier;
  late StreamSubscription<User> _loggedUserSubscription;

  SettingsCubit(this._userRepositoryAnilist, this._userRepositoryLocal, this._loggedUserNotifier, this._reloadNotifier)
    : super(SettingsState(loggedUser: UserModel.empty())) {
    _init();
  }

  @override
  SettingsState copyStateWithEffects(SettingsState state, List<AppEffect> effects) {
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
    _loggedUserSubscription = _loggedUserNotifier.userStream.listen((loggedUser) async {
      emit(state.copyWith(loggedUser: loggedUser));
    });
  }

  Future<void> updateMediaMetadataService(String? newService) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        service: MediaServiceFactory.getEnumMediaService(newService),
      );
      await _updateUserInfo(updatedSettings);
      _reloadNotifier.emitReload(ReloadType.newMetadataService);
    } catch (e, stackTrace) {
      logger.e("Error updating media metadata service $e", stackTrace: stackTrace);
      handleError("Error updating media metadata service", stackTrace: stackTrace);
    }
  }

  Future<void> updateEpisodeMetadataService(String? newService) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        episodeService: EpisodeMediaServiceFactory.getEnumEpisodeService(newService),
      );
      await _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error updating episode metadata service $e", stackTrace: stackTrace);
      handleError("Error updating episode metadata service", stackTrace: stackTrace);
    }
  }

  Future<void> updateMediaTitleLanguage(String? newLanguage) async {
    if (newLanguage == null || newLanguage.isEmpty) {
      return;
    }
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        mediaTitleLanguage: newLanguage,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error updating media title language $e", stackTrace: stackTrace);
      handleError("Error updating media title language", stackTrace: stackTrace);
    }
  }

  Future<void> updateEpisodeTitleLanguage(String? newLanguage) async {
    if (newLanguage == null || newLanguage.isEmpty) {
      return;
    }
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        episodeTitleLanguage: newLanguage,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error updating episode title language $e", stackTrace: stackTrace);
      handleError("Error updating episode title language", stackTrace: stackTrace);
    }
  }

  Future<void> enableNSFWContent(bool enable) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        enableNsfwContent: enable,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error enabling/disabling NSFW content $e", stackTrace: stackTrace);
      handleError("Error enabling/disabling NSFW content", stackTrace: stackTrace);
    }
  }

  Future<void> enableDiscordRichPresence(bool enable) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        enableDiscordRichPresence: enable,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error enabling/disabling Discord Rich Presence $e", stackTrace: stackTrace);
      handleError("Error enabling/disabling Discord Rich Presence", stackTrace: stackTrace);
    }
  }

  Future<void> enableAutomaticallySkipOpening(bool enable) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        automaticallySkipOpening: enable,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error enabling/disabling automatically skip opening $e", stackTrace: stackTrace);
      handleError("Error enabling/disabling automatically skip opening", stackTrace: stackTrace);
    }
  }

  Future<void> enableAutomaticallySkipEnding(bool enable) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        automaticallySkipEnding: enable,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error enabling/disabling automatically skip ending $e", stackTrace: stackTrace);
      handleError("Error enabling/disabling automatically skip ending", stackTrace: stackTrace);
    }
  }

  Future<void> enableAutoPlayNextEpisode(bool enable) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        autoPlayNextEpisode: enable,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error enabling/disabling auto play next episode $e", stackTrace: stackTrace);
      handleError("Error enabling/disabling auto play next episode", stackTrace: stackTrace);
    }
  }

  Future<void> enableOpenSubtitlesIntegration(bool enable) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        enableOpenSubtitlesIntegration: enable,
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error enabling/disabling OpenSubtitles integration $e", stackTrace: stackTrace);
      handleError("Error enabling/disabling OpenSubtitles integration", stackTrace: stackTrace);
    }
  }

  Future<void> manualSkipTimeUpdate(double newSkipTime) async {
    try {
      Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
        manualSkipTime: newSkipTime.toInt(),
      );
      _updateUserInfo(updatedSettings);
    } catch (e, stackTrace) {
      logger.e("Error updating manual skip time $e", stackTrace: stackTrace);
      handleError("Error updating manual skip time", stackTrace: stackTrace);
    }
  }

  void openAniyomiExtensionsDialog() {
    showWidgetDialogEffect(
      dialog: TextFieldDialog(
        width: 500.w,
        height: 200.h,
        title: "Aniyomi extensions repository URL",
        hint: state.loggedUser.settings.aniyomiExtensionsRepositoryUrl,
        onSubmitted: (newExtensionsUrl) {
          if (newExtensionsUrl == null || newExtensionsUrl.isEmpty) {
            return;
          }
          try {
            Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
              aniyomiExtensionsRepositoryUrl: newExtensionsUrl,
            );
            _updateUserInfo(updatedSettings);
          } catch (e, stackTrace) {
            logger.e("Error updating Aniyomi extensions URL $e", stackTrace: stackTrace);
            handleError("Error updating Aniyomi extensions URL", stackTrace: stackTrace);
          }
        },
      ),
    );
  }

  void openTachiyomiExtensionsDialog() {
    showWidgetDialogEffect(
      dialog: TextFieldDialog(
        width: 500.w,
        height: 200.h,
        title: "Tachiyomi extensions repository URL",
        hint: state.loggedUser.settings.tachiyomiExtensionsRepositoryUrl,
        onSubmitted: (newExtensionsUrl) {
          if (newExtensionsUrl == null || newExtensionsUrl.isEmpty) {
            return;
          }
          try {
            Settings updatedSettings = (state.loggedUser.settings as SettingsModel).copyWith(
              tachiyomiExtensionsRepositoryUrl: newExtensionsUrl,
            );
            _updateUserInfo(updatedSettings);
          } catch (e, stackTrace) {
            logger.e("Error updating Tachiyomi extensions URL $e", stackTrace: stackTrace);
            handleError("Error updating Tachiyomi extensions URL", stackTrace: stackTrace);
          }
        },
      ),
    );
  }

  Future<void> _updateUserInfo(Settings settings) async {
    try {
      switch (state.loggedUser) {
        case AnilistUserModel anilistUserModel:
          AnilistUserModel updatedAnilistUserModel = anilistUserModel.copyWith(settings: settings);
          await _userRepositoryAnilist.updateUserInfo(updatedAnilistUserModel);
          break;
        case LocalUserModel localUserModel:
          LocalUserModel updatedLocalUserModel = localUserModel.copyWith(settings: settings);
          await _userRepositoryLocal.updateUserInfo(updatedLocalUserModel);
          break;
      }
    } catch (e, stackTrace) {
      logger.e("Error updating user info $e", stackTrace: stackTrace);
      handleError("Error updating user info", stackTrace: stackTrace);
    }
  }
}
