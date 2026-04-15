---
name: unyo-bloc-state-management
description: How to create cubits, define states, use the EffectMixin pattern, and handle side effects in the Unyo Flutter app. Use this skill whenever creating a new cubit, defining a new state class, adding navigation/dialog/snackbar effects, handling errors in cubits, or wiring cubits to screens with BlocProvider and BlocListener. Also use when modifying existing cubit behavior or debugging state-related issues.
---

# Unyo BLoC State Management (Cubit + Effect Pattern)

Unyo uses **Cubit** (from `flutter_bloc`) for state management, enhanced with a custom **EffectMixin** that handles side effects (navigation, dialogs, snackbars) through the state itself. This is the core pattern for all business logic in the app.

## Architecture Overview

```
lib/application/
├── cubits/
│   ├── home_cubit.dart           # Cubit classes
│   ├── anime_cubit.dart
│   ├── anime_details_cubit.dart
│   ├── video_cubit.dart
│   ├── effect_mixin.dart         # Mixin for side effects
│   └── ...
├── states/
│   ├── home_state.dart           # Freezed state classes
│   ├── anime_state.dart
│   ├── anime_details_state.dart
│   └── ...
└── effects/
    └── app_effects.dart           # Effect type definitions
```

## The Three-Part Pattern

Every feature's state management consists of:

1. **State** — Immutable Freezed class carrying all data + a list of effects
2. **Cubit** — Business logic that emits new states, mixes in `EffectMixin`
3. **Effect Handler** — UI layer that reads effects from state and executes them

## Pattern: Defining a State

States are Freezed classes that implement `HasEffects`. Every state must include a `List<AppEffect> effects` field.

```dart
// lib/application/states/home_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:unyo/application/cubits/effect_mixin.dart';
import 'package:unyo/application/effects/app_effects.dart';
import 'package:unyo/core/enums/selected_menu_option.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:unyo/domain/entities/manga.dart';
import 'package:unyo/domain/entities/user.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState implements HasEffects {
  const factory HomeState({
    required User loggedUser,
    required SelectedMenuOption selectedMenuOption,
    required List<Anime> continueWatching,
    required List<Manga> continueReading,
    required List<String> mediaCoverImages,
    required bool isLoading,
    required bool userLoaded,
    @Default(<AppEffect>[]) List<AppEffect> effects,  // ALWAYS include this
  }) = _HomeState;

  const HomeState._();

  @override
  List<AppEffect> get stateEffects => effects;  // ALWAYS implement this
}
```

### State conventions

1. **All fields `required` or have `@Default()`** — no nullable fields in states. Use sensible defaults (empty lists, `false`, `Model.empty()`).
2. **`effects` always defaults to `<AppEffect>[]`** — this is the mechanism for side effects. Without it, the UI cannot show snackbars, navigate, or open dialogs.
3. **`implements HasEffects`** — required for `EffectMixin` to work.
4. **`const HomeState._()`** — private constructor needed when you have method overrides alongside Freezed.
5. **Never have computed getters in the state** — states are pure data. Put computed logic in the cubit or utility methods.

### Initial state pattern

States are created with all required fields in the cubit's `super()` call:

```dart
: super(HomeState(
    loggedUser: UserModel.empty(),
    selectedMenuOption: SelectedMenuOption.home,
    continueWatching: [],
    continueReading: [],
    mediaCoverImages: [],
    isLoading: true,
    userLoaded: false,
  ));
```

Use `Model.empty()` factory constructors for initial values, not null.

## Pattern: Creating a Cubit

Cubits extend `Cubit<State>` and mix in `EffectMixin<State>`:

```dart
// lib/application/cubits/home_cubit.dart
class HomeCubit extends Cubit<HomeState> with EffectMixin<HomeState> {
  // Repositories
  final UserRepositoryAnilist _userRepositoryAnilist;
  final AnimeRepositoryAnilist _animeRepositoryAnilist;
  // Notifiers
  final UserNotifier _loggedUserNotifier;
  final AnimeNotifier _selectedAnimeNotifier;
  final MangaNotifier _selectedMangaNotifier;
  final MediaListNotifier _selectedMediaListNotifier;
  final ReloadNotifier _reloadNotifier;
  // Subscriptions (for notifiers)
  late StreamSubscription<User> _newLoggedUserSubscription;
  late StreamSubscription<ReloadType> _reloadSubscription;
  // Logger
  final Logger _logger = sl<Logger>();

  HomeCubit(
    this._loggedUserNotifier,
    this._selectedAnimeNotifier,
    this._selectedMangaNotifier,
    this._selectedMediaListNotifier,
    this._userRepositoryAnilist,
    this._animeRepositoryAnilist,
    this._menuBarNotifier,
    this._reloadNotifier,
  ) : super(HomeState(
    loggedUser: UserModel.empty(),
    selectedMenuOption: SelectedMenuOption.home,
    continueWatching: [],
    continueReading: [],
    mediaCoverImages: [],
    isLoading: true,
    userLoaded: false,
  )) {
    _init();
  }

  @override
  State copyStateWithEffects(State state, List<AppEffect> effects) {
    return state.copyWith(effects: effects);
  }

  @override
  Logger get logger => _logger;

  void _init() {
    _newLoggedUserSubscription = _loggedUserNotifier.userStream.listen((user) {
      emit(state.copyWith(loggedUser: user));
      if (!state.userLoaded) {
        _getUserInfo(user);
        emit(state.copyWith(userLoaded: true, isLoading: false));
      }
    });
    _reloadSubscription = _reloadNotifier.reloadStream.listen((reloadType) async {
      if (reloadType == ReloadType.homeMediaListEntryUpdated) {
        await _getUserInfo(state.loggedUser, ignoreCacheAnime: true);
      }
    });
  }

  @override
  Future<void> close() {
    _newLoggedUserSubscription.cancel();
    _reloadSubscription.cancel();
    return super.close();
  }
}
```

### Cubit conventions

1. **Mixin `EffectMixin<State>`** — this is non-optional. Every cubit needs it for navigation and user feedback.
2. **Implement `copyStateWithEffects()` and `logger`** — required by `EffectMixin`. The `copyStateWithEffects` implementation always uses `state.copyWith(effects: effects)`.
3. **Constructor injection** — all dependencies (repositories, notifiers) come through the constructor. The DI container provides them when creating the cubit.
4. **Private `_init()` method** — called from constructor to set up stream subscriptions after fields are initialized.
5. **Always cancel subscriptions in `close()`** — prevents memory leaks.

## Pattern: EffectMixin — Side Effects in Cubits

The `EffectMixin` provides methods for navigation, dialogs, and feedback without directly accessing `BuildContext` (which cubits should never hold):

### Available effect methods

```dart
// Navigation effects
pushRouteEffect(path: "/animedetails");          // Push onto stack
replaceRouteEffect(path: "/login");               // Replace current route
navigateRouteEffect(path: "/tabs");               // Navigate within tabs
changeRouteTabEffect(context, path: "/anime");    // Switch tab in AutoTabsRouter
popRouteEffect(context);                          // Pop current route

// Dialog effects
showWidgetDialogEffect(dialog: MyDialog());                    // Show arbitrary widget dialog
showDrawerDialogEffect(
  drawerDialog: MyDrawer(),
  backgroundColor: Colors.black54,
  startPosition: AxisDirection.right,
);                                                              // Show slide-in drawer dialog
closeDialogEffect(context);                                     // Close current dialog

// Feedback effects
showSnackBarEffect("Title", message: "Details", contentType: ContentType.failure);
showSnackBarEffect("Success!", message: "Saved", contentType: ContentType.success);

// Error handling (combines logging + snackbar)
handleError("Error fetching data: $e", stackTrace: stackTrace);
```

### How effects flow

1. **Cubit calls** `pushRouteEffect(path: "/animedetails")`
2. **EffectMixin creates** a `PushRouteEffect("/animedetails")` and adds it to the state's effects list via `emit(copyStateWithEffects(state, [...currentEffects, effect]))`
3. **BlocListener in the UI** detects `state.effects.isNotEmpty` and calls `sl<AppEffectHandler>().handleEffects(context, state.effects, cubit.clearEffects)`
4. **AppEffectHandler** pattern-matches on the effect type and calls `AutoRouter.of(context).pushPath(...)`
5. **clearEffects()** removes all effects from state after processing

This pattern keeps cubits free of `BuildContext` while still enabling navigation and UI feedback.

### Why effects instead of direct navigation?

Cubits should not hold `BuildContext` references (they outlive the widget tree). Effects let cubits express intent ("navigate to anime details") without knowing how or when it happens. The UI layer handles the actual navigation.

## Pattern: Emitting State Changes

```dart
// Simple property update
emit(state.copyWith(isLoading: true));

// Conditional logic
if (!state.userLoaded) {
  await _getUserInfo(user);
  emit(state.copyWith(userLoaded: true, isLoading: false));
}

// Error handling with effect
try {
  final data = await _repository.getData();
  emit(state.copyWith(data: data, isLoading: false));
} catch (e, stackTrace) {
  handleError("Failed to load data: $e", stackTrace: stackTrace);
  replaceRouteEffect(path: "/login");
}
```

### Key emission rules

- **Always use `state.copyWith()`** — never mutate state directly. Freezed enforces this since all fields are immutable.
- **Chain related emissions** — it's fine to emit multiple times in one method. Each emission triggers a rebuild in `BlocBuilder`.
- **Don't emit after async gaps without checking** — after an `await`, the cubit might be closed. Wrap post-async logic in try/catch.

## Pattern: Subscribing to Notifiers in Cubits

See the `unyo-reactive-notifiers` skill for the full pattern. The key steps:

1. Declare `late StreamSubscription<T>` fields
2. Subscribe in `_init()` called from constructor
3. Call `.cancel()` on all subscriptions in `close()`

```dart
late StreamSubscription<User> _userSub;

void _init() {
  _userSub = _userNotifier.userStream.listen((user) {
    emit(state.copyWith(loggedUser: user));
  });
}

@override
Future<void> close() {
  _userSub.cancel();
  return super.close();
}
```

## Creating a New Cubit+State: Complete Workflow

1. **Create the state file** at `lib/application/states/<feature>_state.dart`:
   - Freezed class implementing `HasEffects`
   - Include `@Default(<AppEffect>[]) List<AppEffect> effects`
   - All required fields with sensible defaults
   - Part directives for `*.freezed.dart`

2. **Create the cubit file** at `lib/application/cubits/<feature>_cubit.dart`:
   - Extends `Cubit<State>` with `EffectMixin<State>`
   - Implements `copyStateWithEffects` and `logger`
   - Constructor injection of all dependencies
   - `_init()` for stream subscriptions
   - `close()` for cleanup

3. **Register in DI** at `lib/core/di/locator.dart`:
   ```dart
   sl.registerFactory<FeatureCubit>(() => FeatureCubit(
     sl<FeatureNotifier>(),
     sl<FeatureRepositoryAnilist>(),
   ));
   ```

4. **Wire to screen** — see `unyo-ui-presentation` skill for BlocProvider/BlocListener/BlocBuilder pattern.

5. **Run code generation**:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run analysis**:
   ```sh
   flutter analyze
   ```

## Common Pitfalls

- **Forgetting `implements HasEffects`**: The state must implement this interface for `EffectMixin` to work. Without it, `_currentEffects` throws a `StateError`.
- **Not calling `clearEffects()` from the UI**: `BlocListener` must call `cubit.clearEffects()` after processing effects, otherwise effects will keep firing on every rebuild.
- **Storing `BuildContext` in a cubit**: Never do this. Cubits outlive widget trees. Use effects instead.
- **Mutating state directly**: Freezed states are immutable. Always use `state.copyWith(...)`.
- **Missing `copyStateWithEffects` implementation**: Every cubit that mixes in `EffectMixin` must implement this. It always looks like `state.copyWith(effects: effects)`.
- **Not canceling subscriptions**: Will cause memory leaks and phantom updates on disposed cubits.
- **Registering cubits as singletons**: Cubits must be `registerFactory`, not `registerSingleton` or `registerLazySingleton`. Each screen needs its own instance.

## Cross-references

- **Effect types and handler**: Examined in `unyo-ui-presentation` skill
- **Notifier subscription pattern**: See `unyo-reactive-notifiers` skill
- **DI registration**: See `unyo-dependency-injection` skill
- **State entities used in states**: See `unyo-domain-data-layer` skill