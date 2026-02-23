import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/data/models/anilist_user_model.dart';
import 'package:unyo/data/models/local_user_model.dart';
import 'package:unyo/data/repositories/user_repository_anilist.dart';
import 'package:unyo/data/repositories/user_repository_local.dart';
import 'package:unyo/domain/entities/settings.dart';
import 'package:unyo/domain/entities/user.dart';

class ThemeService {
  final BehaviorSubject<ThemeData> _themeSubject;

  // Repositories
  final UserRepositoryAnilist _userRepositoryAnilist;
  final UserRepositoryLocal _userRepositoryLocal;

  ThemeService(this._userRepositoryAnilist, this._userRepositoryLocal)
      : _themeSubject = BehaviorSubject<ThemeData>.seeded(_defaultTheme);


  Stream<ThemeData> get theme$ => _themeSubject.stream;

  ThemeData get current => _themeSubject.value;

  void updateThemeFromColors(
      {required User loggedUser, required Color primary, required bool useWallpaperAsThemeColor, Color? secondary, Color? tertiary}) {
    final newTheme = _defaultTheme.copyWith(
      colorScheme: ColorScheme.dark(
        primary: Color.lerp(primary, Colors.black, 0.1) ?? primary,
        secondary: secondary ?? (Color.lerp(primary, Colors.black, 0.7) ?? primary),
        tertiary: tertiary ?? (Color.lerp(primary, Colors.white, 0.7) ?? primary),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.white,
      ),
      appBarTheme: AppBarTheme(backgroundColor: primary),
    );
    _themeSubject.add(newTheme);
    _updateUserThemeSettings(loggedUser, primary, useWallpaperAsThemeColor, newTheme.colorScheme);
  }

  void updateThemeFromColorScheme(
      {required User logedUser, required bool useWallpaperAsThemeColor, required ColorScheme newcolorScheme}) {
    final newTheme = _defaultTheme.copyWith(
      colorScheme: newcolorScheme,
    );
    _themeSubject.add(newTheme);
      _updateUserThemeSettings(logedUser, newcolorScheme.primary, useWallpaperAsThemeColor, newcolorScheme);
  }

  Future<void> _updateUserThemeSettings(User loggedUser, Color primary, bool useWallpaperAsThemeColor, ColorScheme colorScheme) async {
    Settings updatedSettings = (loggedUser.settings as SettingsModel).copyWith(
      themeColor: primary,
      useWallpaperAsThemeColor: useWallpaperAsThemeColor
    );
    switch (loggedUser) {
      case AnilistUserModel anilistUserModel:
        AnilistUserModel updatedAnilistUserModel = anilistUserModel.copyWith(settings: updatedSettings);
        await _userRepositoryAnilist.updateUserInfo(updatedAnilistUserModel);
        break;
      case LocalUserModel localUserModel:
        LocalUserModel updatedLocalUserModel = localUserModel.copyWith(settings: updatedSettings);
        await _userRepositoryLocal.updateUserInfo(updatedLocalUserModel);
        break;
    }
  }

  void setTheme(ThemeData theme) => _themeSubject.add(theme);
}

final _defaultTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color.fromARGB(255, 44, 44, 44),
  textTheme: const TextTheme(
    // Display styles (largest) - white
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 35,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),

    // Headline styles - white to light gray
    headlineLarge: TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),

    // Title styles - light gray to mid gray
    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 18,
      // fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      // fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      // fontWeight: FontWeight.w500,
    ),

    // Body styles - dark gray to black
    bodyLarge: TextStyle(color: Colors.white, fontSize: 14),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 12),
    bodySmall: TextStyle(color: Colors.white, fontSize: 10),

    // Label styles - black
    labelLarge: TextStyle(
      color: Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      color: Colors.grey,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      color: Colors.grey,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  ),
);
