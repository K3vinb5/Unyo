import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/core/enums/selected_menu_option.dart';
import 'package:unyo/domain/entities/user/user.dart';

part 'tabs_state.freezed.dart';

@freezed
abstract class TabsState with _$TabsState implements HasEffects {
  const factory TabsState({
    required SelectedMenuOption selectedMenuOption,
    required bool showMenuBar,
    required bool showTabView,
    required User loggedUser,
    @Default(<AppEffect>[]) List<AppEffect> effects,
  }) = _TabsState;

  const TabsState._();

  @override
  List<AppEffect> get stateEffects => effects;
}