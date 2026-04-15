---
name: unyo-dependency-injection
description: How to register and resolve dependencies using GetIt in the Unyo Flutter app. Use this skill whenever adding new services, repositories, cubits, or notifiers to the dependency injection container, understanding registration types (singleton vs factory vs lazySingleton), dealing with named instances, or debugging DI-related errors like "Object not found" or circular dependencies.
---

# Unyo Dependency Injection with GetIt

Unyo uses **GetIt** as its service locator for dependency injection. All registrations happen in a single file (`lib/core/di/locator.dart`) and follow a clear two-phase initialization pattern.

## The Service Locator

```dart
// lib/core/di/locator.dart
final sl = GetIt.instance;
```

`sl` is the global service locator instance used throughout the app. Every dependency — services, repositories, notifiers, cubits — is registered in and resolved from `sl`.

## Two-Phase Initialization

Unyo initializes dependencies in two phases because some services depend on asynchronous platform APIs (like `getApplicationSupportDirectory()`) and others depend on Hive being ready.

### Phase 1: `setupLocator()` — Called before `runApp()`

```dart
void setupLocator() async {
  // 1. Async platform dependencies first
  sl.registerSingletonAsync<Directory>(
    () => getApplicationSupportDirectory(),
    instanceName: config.applicationSupportDirectory,
  );
  await sl.isReady<Directory>(instanceName: config.applicationSupportDirectory);

  // 2. Singletons with no async dependencies
  sl.registerSingleton<Logger>(getLogger());
  sl.registerSingleton<AniyomiBridge>(AniyomiBridge());
  sl.registerSingleton<TorrentService>(TorrentService());
  sl.registerSingleton<SettingsService>(SettingsService());

  // 3. Lazy singletons (services, notifiers, repositories)
  sl.registerLazySingleton<HttpService>(() => HttpService());
  sl.registerLazySingleton<GraphQLService>(
    () => GraphQLService(httpService: sl<HttpService>(), endpoint: config.anilistGraphQLEndpoint),
    instanceName: config.anilistGraphQlService,
  );
  sl.registerLazySingleton<AppEffectHandler>(() => AppEffectHandler());

  // 4. Notifiers (all lazy singletons)
  sl.registerLazySingleton<AnimeNotifier>(() => AnimeNotifier());
  sl.registerLazySingleton<MangaNotifier>(() => MangaNotifier());
  // ... more notifiers

  // 5. Repositories (lazy singletons)
  sl.registerLazySingleton<AnimeRepositoryAnilist>(() => AnimeRepositoryAnilist());
  sl.registerLazySingleton<MangaRepositoryAnilist>(() => MangaRepositoryAnilist());

  // 6. Cubits (factories — new instance each time)
  sl.registerFactory<HomeCubit>(() => HomeCubit(
    sl<UserNotifier>(instanceName: config.loggedUserNotifier),
    sl<AnimeNotifier>(),
    sl<MangaNotifier>(),
    // ... all dependencies
  ));
}
```

### Phase 2: `setupLocatorAfterHiveInit()` — Called after Hive initializes

```dart
void setupLocatorAfterHiveInit() {
  // Dependencies that require Hive to be ready
  sl.registerSingleton<ExtensionRepositoryAniyomi>(
    ExtensionRepositoryAniyomi(
      sl<UserRepositoryAnilist>(),
      sl<UserNotifier>(instanceName: config.loggedUserNotifier),
    ),
  );
}
```

**Why two phases?** `ExtensionRepositoryAniyomi` uses Hive boxes for storage, so it can't be constructed until after Hive is initialized. The `main()` function calls `setupLocator()` → Hive init → `setupLocatorAfterHiveInit()`.

## Registration Types

### `registerSingleton<T>` — Eager, one instance forever

```dart
sl.registerSingleton<Logger>(getLogger());
```

- Created immediately at registration time
- Same instance returned for every `sl<Logger>()` call
- Use for: Logger, platform services, anything needed ASAP

### `registerLazySingleton<T>` — Lazy, one instance forever (after first access)

```dart
sl.registerLazySingleton<AnimeRepositoryAnilist>(() => AnimeRepositoryAnilist());
```

- Created only when first accessed via `sl<AnimeRepositoryAnilist>()`
- Same instance for all subsequent calls
- Use for: Repositories, notifiers, services — things that are heavy or may not always be needed

### `registerFactory<T>` — New instance every time

```dart
sl.registerFactory<HomeCubit>(() => HomeCubit(
  sl<UserNotifier>(instanceName: config.loggedUserNotifier),
  sl<AnimeNotifier>(),
));
```

- Factory function runs every time `sl<HomeCubit>()` is called
- Each call gets a fresh instance
- Use for: **Cubits** — each screen gets its own cubit instance

### `registerSingletonAsync<T>` — Async eager singleton

```dart
sl.registerSingletonAsync<Directory>(
  () => getApplicationSupportDirectory(),
  instanceName: config.applicationSupportDirectory,
);
await sl.isReady<Directory>(instanceName: config.applicationSupportDirectory);
```

- Created asynchronously
- Must await `isReady<T>()` before using
- Use for: Platform dependencies that return Futures

## Named Instances

When you need multiple registrations of the same type, use named instances:

```dart
// In config.dart
const String loggedUserNotifier = 'loggedUserNotifier';
const String newUserNotifier = 'newUserNotifier';

// Registration
sl.registerLazySingleton<UserNotifier>(() => UserNotifier(), instanceName: config.loggedUserNotifier);
sl.registerLazySingleton<UserNotifier>(() => UserNotifier(), instanceName: config.newUserNotifier);

// Resolution
sl<UserNotifier>(instanceName: config.loggedUserNotifier)  // Different instance
sl<UserNotifier>(instanceName: config.newUserNotifier)      // Different instance
```

**Convention**: Store instance name strings as `const` in `lib/config/config.dart`, not as magic strings in the locator.

## Adding a New Dependency: Complete Workflow

### Example: Adding a new `StudioNotifier` and `StudioRepository`

1. **Create config constants** (if adding named instances):

```dart
// lib/config/config.dart
const String studioNotifier = 'studioNotifier';
```

2. **Register in `setupLocator()`** in the correct section:

```dart
// Notifiers section
sl.registerLazySingleton<StudioNotifier>(() => StudioNotifier());

// Repositories section
sl.registerLazySingleton<StudioRepositoryAnilist>(() => StudioRepositoryAnilist());

// Cubits section (factories!)
sl.registerFactory<StudioCubit>(() => StudioCubit(
  sl<StudioNotifier>(),
  sl<StudioRepositoryAnilist>(),
));
```

3. **If the dependency needs Hive**, register in `setupLocatorAfterHiveInit()` instead.

4. **Import the cubit/notifier in locator.dart**:

```dart
import 'package:unyo/application/cubits/studio_cubit.dart';
import 'package:unyo/core/notification/studio_notifier.dart';
```

5. **Use in screens** via `BlocProvider`:

```dart
// In the screen widget
BlocProvider(
  create: (context) => sl<StudioCubit>(),
  child: const StudioListener(),
)
```

## Registration Order Matters

GetIt resolves dependencies at construction time. If `HomeCubit` needs `AnimeNotifier`, then `AnimeNotifier` must be registered **before** `HomeCubit`. Within each phase, follow this order:

1. **Platform dependencies** (async singletons like `Directory`)
2. **Core singletons** (`Logger`, bridge services)
3. **Services** (`HttpService`, `GraphQLService`, `TorrentService`)
4. **Singletons depending on services** (`ThemeService`, `SettingsService`)
5. **Notifiers** (all lazy singletons)
6. **Repositories** (lazy singletons that depend on services)
7. **Cubits** (factories that depend on everything above)

## Dependency Injection in Repositories

Repositories access services via the locator, not constructor injection:

```dart
class AnimeRepositoryAnilist with RepositoryMixin implements AnimeRepository {
  final GraphQLService _anilistGraphQLService = sl<GraphQLService>(
    instanceName: config.anilistGraphQlService,
  );
  final Logger _logger = sl<Logger>();
```

This is intentional — repositories are lazy singletons that only exist once, so direct locator access is simpler than threading services through constructors. Cubits, however, receive all their dependencies via constructor injection from the locator.

## Common Pitfalls

- **Registering after resolution**: GetIt throws at runtime if you try to resolve a type that hasn't been registered. Always add new registrations to `setupLocator()` **before** any code that uses `sl<T>()`.
- **Missing `await sl.isReady<T>()`**: For async singletons, you must wait for readiness before using them. The `main()` function handles this, but if you add a new async singleton, make sure to add the await.
- **Using `registerFactory` for notifiers**: Notifiers must be `registerLazySingleton` so all cubits share the same stream. Using `registerFactory` would create separate instances, breaking cross-cubit communication.
- **Using `registerSingleton` for cubits**: Cubits must be `registerFactory` to ensure each screen gets its own instance. Using `registerSingleton` would share state between screens and cause bugs.
- **Missing named instance on resolution**: If you register with `instanceName`, you must also resolve with the same `instanceName`:
  ```dart
  // WRONG — resolves the unnamed instance, not the logged user notifier
  sl<UserNotifier>()
  // CORRECT — resolves the named instance
  sl<UserNotifier>(instanceName: config.loggedUserNotifier)
  ```
- **Circular dependencies**: If A needs B and B needs A, GetIt can't resolve them. Break the cycle by using lazy resolution: pass a factory function instead of the actual instance.

## Cross-references

- **Notifier pattern details**: See `unyo-reactive-notifiers` skill
- **Cubit registration and wiring**: See `unyo-bloc-state-management` skill
- **Repository pattern details**: See `unyo-domain-data-layer` skill