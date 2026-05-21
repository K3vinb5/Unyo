//External dependencies
import 'package:freezed_annotation/freezed_annotation.dart';

//Internal dependencies
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/core/enums/selected_menu_option.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/media/manga.dart';
import 'package:unyo/domain/entities/user/user.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState implements HasEffects{
  const factory HomeState({
    required User loggedUser,
    required SelectedMenuOption selectedMenuOption,
    //TODO recommended anime / manga
    required List<Anime> continueWatching,
    required List<Manga> continueReading,
    required List<String> mediaCoverImages,
    required bool isLoading,
    required bool userLoaded,
    @Default(<AppEffect>[]) List<AppEffect> effects,
  }) = _HomeState;

  const HomeState._();

  @override
  List<AppEffect> get stateEffects => effects;
}
