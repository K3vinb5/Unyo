---
name: unyo-reactive-notifiers
description: How to create and use RxDart BehaviorSubject notifiers for cross-cubit communication in the Unyo Flutter app. Use this skill whenever creating a new notifier, subscribing to notifier streams in a cubit, passing data between screens without route arguments, or debugging stream-related state issues. Also use when a new feature needs to share state across multiple cubits.
---

# Unyo Reactive Notifiers

Unyo uses **RxDart `BehaviorSubject`-based notifiers** as the inter-cubit communication layer. This is the mechanism by which data flows between independent cubits without tight coupling. Understanding this pattern is essential for any feature that spans multiple screens.

## Why Notifiers Exist

Cubits in Unyo are created as **factories** in `get_it` — each screen gets its own instance. A `HomeCubit` and an `AnimeDetailsCubit` cannot directly reference each other. Notifiers bridge this gap by providing a shared reactive stream that any cubit can subscribe to.

Common scenarios:
- User selects an anime on the Home screen → `AnimeDetailsCubit` needs to know which anime was selected
- User updates a media list entry → `HomeCubit` needs to refresh its "Continue Watching" list
- Login changes → Multiple cubits need to react to the new user

## Notifier Architecture

```
lib/core/notification/
├── anime_notifier.dart
├── anime_genres_notifier.dart
├── episode_info_notifier.dart
├── episodes_notifier.dart
├── extension_notifier.dart
├── manga_notifier.dart
├── manga_genres_notifier.dart
├── media_list_entry_notifier.dart
├── media_list_notifier.dart
├── menu_bar_notifier.dart
├── reload/
│   ├── reload_notifier.dart
│   └── reload_type.dart
├── user_notifier.dart
└── video_info_notifier.dart
```

## Pattern: Creating a Notifier

Every notifier follows the same structure: a class wrapping a `BehaviorSubject` with a public stream and update method.

```dart
// lib/core/notification/anime_notifier.dart
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/anime.dart';
import 'package:logger/logger.dart';

class AnimeNotifier {
  final BehaviorSubject<Anime> _animeSubject;
  final _logger = sl<Logger>();

  // Seed with an empty/default value so subscribers get immediate data
  AnimeNotifier() : _animeSubject = BehaviorSubject.seeded(AnimeModel.empty());

  // Public read-only stream for cubits to subscribe
  Stream<Anime> get animeStream => _animeSubject.stream;

  // Synchronous access to current value
  Anime get currentAnime => _animeSubject.value;

  // Push a new value into the stream
  void updateSelectedAnime(Anime anime) {
    _logger.d("Anime notifier updated with: $anime");
    _animeSubject.add(anime);
  }

  // Always dispose to prevent memory leaks
  void dispose() => _animeSubject.close();
}
```

### Key conventions

1. **Always seed with a default value**: `BehaviorSubject.seeded(EntityModel.empty())`. This ensures subscribers always have data and never get a `null` or wait for the first emission.
2. **Expose `Stream<T>`, not `BehaviorSubject<T>`**: Consumers only need the stream, not the subject itself. This prevents external code from pushing values.
3. **Provide a `currentX` getter**: Some cubits need synchronous access to the current value (e.g., for initial state). `BehaviorSubject.value` provides this.
4. **Name the update method clearly**: `updateSelectedAnime`, `updateSelectedManga` — not just `update` or `add`. The method name describes the real-world event.
5. **Always include `dispose()`**: Even though notifiers are lazy singletons, including `dispose()` is good practice.

## Pattern: Registering a Notifier in DI

Notifiers are registered as **lazy singletons** in `lib/core/di/locator.dart`:

```dart
// In setupLocator()
sl.registerLazySingleton<AnimeNotifier>(() => AnimeNotifier());
```

For notifiers with multiple instances (like `UserNotifier`), use **named instances**:

```dart
sl.registerLazySingleton<UserNotifier>(
  () => UserNotifier(),
  instanceName: config.loggedUserNotifier,  // "loggedUserNotifier"
);
sl.registerLazySingleton<UserNotifier>(
  () => UserNotifier(),
  instanceName: config.newUserNotifier,      // "newUserNotifier"
);
```

Named instances are resolved with:

```dart
sl<UserNotifier>(instanceName: config.loggedUserNotifier)
```

**See `unyo-dependency-injection` skill for full DI details.**

## Pattern: Subscribing in a Cubit

Cubits subscribe to notifiers in two places: the constructor (for setup) and `close()` (for cleanup):

```dart
class AnimeDetailsCubit extends Cubit<AnimeDetailsState> with EffectMixin<AnimeDetailsState> {
  final AnimeNotifier _animeNotifier;
  final MediaListNotifier _mediaListNotifier;
  final EpisodesNotifier _episodesNotifier;
  late StreamSubscription<Anime> _animeSubscription;
  late StreamSubscription<MediaList> _mediaListSubscription;
  late StreamSubscription<EpisodesInfo> _episodesSubscription;

  AnimeDetailsCubit(
    this._animeNotifier,
    this._mediaListNotifier,
    this._episodesNotifier,
    // ... other dependencies
  ) : super(AnimeDetailsState.initial()) {
    _init();
  }

  void _init() {
    // Subscribe and react to changes
    _animeSubscription = _animeNotifier.animeStream.listen((anime) {
      // Fetch details for the newly selected anime
      _getAnimeDetails(anime);
    });
    _mediaListSubscription = _mediaListNotifier.mediaListStream.listen((mediaList) {
      // React to media list changes
      emit(state.copyWith(selectedMediaList: mediaList));
    });
  }

  @override
  Future<void> close() {
    // CRITICAL: Always cancel subscriptions to prevent memory leaks
    _animeSubscription.cancel();
    _mediaListSubscription.cancel();
    _episodesSubscription.cancel();
    return super.close();
  }
}
```

### Subscription rules

1. **Always store subscriptions** as `late StreamSubscription<T>` fields — you need them for cleanup.
2. **Always cancel all subscriptions in `close()`** — failing to do so causes memory leaks and phantom updates on disposed cubits.
3. **Initialize subscriptions in a private `_init()` method** called from the constructor. This keeps the constructor clean and makes the initialization order clear.
4. **Inject the notifier via the constructor** — do not resolve notifiers inside methods. The locator registration (in `setupLocator()`) handles wiring.

## Pattern: The Reload Notifier

The `ReloadNotifier` is a special notifier that uses an enum to signal different reload types:

```dart
// lib/core/notification/reload/reload_type.dart
enum ReloadType {
  newMetadataService,
  homeMediaListEntryUpdated,
  // Add new types here as needed
}

// lib/core/notification/reload/reload_notifier.dart
class ReloadNotifier {
  final BehaviorSubject<ReloadType> _reloadSubject;

  ReloadNotifier() : _reloadSubject = BehaviorSubject.seeded(ReloadType.newMetadataService);

  Stream<ReloadType> get reloadStream => _reloadSubject.stream;
  void triggerReload(ReloadType type) => _reloadSubject.add(type);
  void dispose() => _reloadSubject.close();
}
```

Cubits subscribe and filter on the reload type:

```dart
_reloadSubscription = _reloadNotifier.reloadStream.listen((reloadType) async {
  if (reloadType == ReloadType.homeMediaListEntryUpdated) {
    await _getUserInfo(state.loggedUser, ignoreCacheAnime: true);
  }
  if (reloadType == ReloadType.newMetadataService) {
    await _getMediaCoverImages(state.loggedUser, ignoreCache: true);
  }
});
```

This pattern lets multiple cubits react to different scenarios without direct dependencies on each other.

## Pattern: Creating a Notifier for a New Feature

Example: Adding a "Studio" feature that needs to share the selected studio between cubits.

1. **Create the notifier**:

```dart
// lib/core/notification/studio_notifier.dart
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/studio.dart';
import 'package:logger/logger.dart';

class StudioNotifier {
  final BehaviorSubject<Studio> _studioSubject;
  final _logger = sl<Logger>();

  StudioNotifier() : _studioSubject = BehaviorSubject.seeded(StudioModel.empty());

  Stream<Studio> get studioStream => _studioSubject.stream;
  Studio get currentStudio => _studioSubject.value;

  void updateSelectedStudio(Studio studio) {
    _logger.d("Studio notifier updated with: $studio");
    _studioSubject.add(studio);
  }

  void dispose() => _studioSubject.close();
}
```

2. **Register in DI** (see `unyo-dependency-injection` skill):

```dart
// In setupLocator()
sl.registerLazySingleton<StudioNotifier>(() => StudioNotifier());
```

3. **Inject into cubits that need it**:

```dart
// In setupLocator()
sl.registerFactory<StudioDetailsCubit>(
  () => StudioDetailsCubit(
    sl<StudioNotifier>(),     // Injected
    sl<StudioRepositoryAnilist>(),
    // ... other dependencies
  ),
);
```

4. **Subscribe in the cubit** (see `unyo-bloc-state-management` skill):

```dart
class StudioDetailsCubit extends Cubit<StudioDetailsState> with EffectMixin<StudioDetailsState> {
  final StudioNotifier _studioNotifier;
  late StreamSubscription<Studio> _studioSubscription;

  StudioDetailsCubit(this._studioNotifier, /* ... */) : super(StudioDetailsState.initial()) {
    _init();
  }

  void _init() {
    _studioSubscription = _studioNotifier.studioStream.listen((studio) {
      _loadStudioDetails(studio);
    });
  }

  @override
  Future<void> close() {
    _studioSubscription.cancel();
    return super.close();
  }
}
```

5. **Trigger from other cubits** (e.g., navigating from a list screen):

```dart
// In StudioListCubit
void navigateToStudioDetails(Studio studio) {
  _studioNotifier.updateSelectedStudio(studio);
  pushRouteEffect(path: "/studiodetails");
}
```

## Common Pitfalls

- **Forgetting to cancel subscriptions**: This is the #1 source of bugs. Every `listen()` must have a matching `.cancel()` in `close()`.
- **Using `stream.first` instead of `listen`**: `.first` only gets the next emission. For ongoing reactions, always use `.listen()`.
- **Seeding with null**: Use `EntityModel.empty()` instead of `null`. Null requires null checks everywhere and defeats the purpose of BehaviorSubject's guaranteed initial value.
- **Creating new BehaviorSubjects inside methods**: Notifiers are singletons. If you create a `BehaviorSubject` inside a cubit method, it won't be the same instance that other cubits are subscribed to. Always use the singleton notifier from the DI container.
- **Naming collisions**: Notifier names should describe what they carry, not what uses them. `AnimeNotifier` (good) vs `HomeScreenNotifier` (bad — it's shared across screens).

## Cross-references

- **Registering notifiers in DI**: See `unyo-dependency-injection` skill
- **Using notifiers in cubits**: See `unyo-bloc-state-management` skill
- **Triggering navigation from notifiers**: See `unyo-routing-navigation` skill
- **Domain entities used in notifiers**: See `unyo-domain-data-layer` skill