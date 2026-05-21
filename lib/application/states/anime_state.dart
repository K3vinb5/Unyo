import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/domain/entities/media/anime.dart';
import 'package:unyo/domain/entities/user/user.dart';

part 'anime_state.freezed.dart';

@freezed
abstract class AnimeState with _$AnimeState implements HasEffects{
  const factory AnimeState({
    required (bool, List<Anime>) recentlyReleased,
    required (bool, List<Anime>) trending,
    required (bool, List<Anime>) recentlyCompleted,
    required (bool, List<Anime>) popular,
    required (bool, List<Anime>) upcoming,
    required List<Anime> banners,
    required User loggedUser,
    required bool isLoading,
    required bool selectionDialogLoading,
    required bool userLoaded,
    @Default(<AppEffect>[]) List<AppEffect> effects,
  }) = _AnimeState;

  const AnimeState._();

  @override
  List<AppEffect> get stateEffects => effects;
}