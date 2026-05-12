# Contributing to Unyo

Thank you for your interest in contributing to **Unyo**! This guide covers everything you need to know to get started, from setting up your environment to understanding our architecture and submitting changes.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Development Environment](#development-environment)
- [Project Structure](#project-structure)
- [Architecture Overview](#architecture-overview)
- [Getting Started](#getting-started)
- [Adding a New Feature](#adding-a-new-feature)
- [Code Style & Conventions](#code-style--conventions)
- [Build, Test & Analyze](#build-test--analyze)
- [Multi-Repository Setup](#multi-repository-setup)
- [Submitting Changes](#submitting-changes)

---

## Code of Conduct

- Be respectful and constructive in all interactions.
- Keep discussions focused on technical merit.
- Opening issues with suggestions or bug reports is contributing.
- Contributing means pull requests, issues, and constructive feedback — **not** rebranding the app under a new repository.

---

## Development Environment

### Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| Flutter | **3.38.1** | Pinned via `.fvmrc`. Use `fvm flutter` if you manage multiple versions. |
| Dart | Bundled with Flutter | |
| Java | **17+** | Required for local Aniyomi/Tachiyomi extensions. |
| Maven | 3.x | Required to build `unyo-core`. |
| Go | 1.21+ | Required to build the torrent server binding. |

### Repository Layout

Unyo is split across **three sibling repositories**:

```
~/Projects/
├── unyo/           # This Flutter app
├── unyo_lib/       # Flutter FFI package (JNI bindings to unyo-core)
└── unyo-core/      # Java/Kotlin JVM runtime for Aniyomi extensions
```

All three must exist as sibling directories. `unyo` depends on `unyo_lib` via a local path (`../unyo_lib`).

### Initial Setup

```sh
# 1. Clone all three repositories
git clone https://github.com/K3vinb5/Unyo.git unyo
git clone https://github.com/K3vinb5/unyo_lib.git unyo_lib
git clone https://github.com/K3vinb5/unyo-core.git unyo-core

# 2. Install Flutter dependencies
cd unyo
flutter pub get

# 3. Generate code (Freezed, Hive, AutoRoute, JSON)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Verify analysis passes
flutter analyze
```

---

## Project Structure

```
lib/
├── application/
│   ├── cubits/           # Business logic (Cubit + EffectMixin)
│   ├── states/           # Freezed state classes
│   └── effects/          # Effect type definitions
├── core/
│   ├── di/               # GetIt service locator (locator.dart)
│   ├── enums/            # App-wide enums
│   ├── notification/     # RxDart notifiers (cross-cubit communication)
│   ├── router/           # AutoRoute configuration
│   └── services/         # API, HTTP, GraphQL, video services
├── data/
│   ├── models/           # Concrete Freezed models (API → domain mapping)
│   ├── repositories/     # Repository implementations
│   └── adapters/         # Hive type adapters
├── domain/
│   ├── entities/         # Abstract domain entities + Freezed implementations
│   └── repositories/     # Repository interfaces (contracts)
├── generated/            # Auto-generated JSON serialization code
├── presentation/
│   ├── screens/          # Route screens (@RoutePage)
│   ├── dialogs/          # Modal dialogs
│   ├── drawers/          # Slide-in drawers
│   └── widgets/          # Reusable UI components
└── main.dart
```

---

## Architecture Overview

Unyo follows **Clean Architecture** with strict layer separation:

```
Presentation → Application → Domain ← Data
```

| Layer | Responsibility | Key Packages |
|-------|---------------|--------------|
| **Presentation** | Screens, widgets, effect handling | `flutter_bloc`, `auto_route`, `flutter_screenutil` |
| **Application** | Business logic, state management | `Cubit` + `EffectMixin`, `rxdart` notifiers |
| **Domain** | Entities and repository contracts | Pure Dart, no external deps |
| **Data** | API calls, JSON mapping, local persistence | `dio`, `graphql`, `hive_ce`, `json_serializable` |

### State Management: Cubit + EffectMixin

Every feature uses a **Cubit** with a custom `EffectMixin` for side effects:

- **State** — Immutable Freezed class carrying all UI data + a list of `AppEffect`s.
- **Cubit** — Business logic that emits states; never holds `BuildContext`.
- **Effects** — Side effects (navigation, dialogs, snackbars) flow through state to the UI layer.

Cubits express *intent* (e.g., "navigate to anime details") via effects. The UI layer (`BlocListener`) executes them via `AppEffectHandler`.

### Dependency Injection: GetIt

All dependencies are registered in `lib/core/di/locator.dart`:

- **Singletons** — `Logger`, bridge services (one instance, created eagerly).
- **Lazy singletons** — Repositories, notifiers, HTTP services (created on first access).
- **Factories** — **Cubits only** (new instance per screen).

Named instances are stored as `const` strings in `lib/config/config.dart`.

### Navigation: AutoRoute

Routes are declared in `lib/core/router/app_router.dart`. Code generation creates `app_router.gr.dart`. Navigation from cubits happens through effects, not direct `BuildContext` access.

### Cross-Cubit Communication: Notifiers

RxDart `BehaviorSubject` notifiers in `lib/core/notification/` share state across cubits without coupling them. Example: `AnimeNotifier` lets the home screen and anime details screen share the currently selected anime.

---

## Getting Started

### Running the App

```sh
# Debug build (Linux)
flutter run

# Release build
flutter build linux --release
```

### Running Tests

```sh
flutter test
```

### Static Analysis

```sh
flutter analyze
```

> **Always run `flutter analyze` before committing.** The CI enforces this.

---

## Adding a New Feature

The following workflow adds a complete feature end-to-end. For concrete code examples, see the relevant skill documents in `.agents/skills/`.

### Step 1: Domain Layer (Entity + Repository Contract)

1. Create the abstract entity + Freezed model in `lib/domain/entities/<feature>.dart`:
   - Abstract class defining the contract.
   - Freezed `@freezed` class `FeatureModel implements Feature`.
   - `.empty()` factory for default values.
   - `fromJson` / `toJson` for JSON serialization.
   - Custom `JsonConverter` if referencing other abstract entities.

2. Add the repository interface in `lib/domain/repositories/<feature>_repository.dart`.

3. Export both from the barrel files (`entities.dart`, `repositories.dart`).

### Step 2: Data Layer (Model + Repository Implementation)

1. Create the concrete model in `lib/data/models/<source>_<feature>_model.dart` (e.g., `anilist_studio_model.dart`).
   - `implements Feature` (the abstract class).
   - Named factories mapping from API DTOs.

2. Create the repository implementation in `lib/data/repositories/<feature>_repository_<source>.dart`.
   - `implements FeatureRepository`.
   - Use `RepositoryMixin` for error handling.
   - Inject services via `sl<T>()`.

3. Export from barrel files.

### Step 3: Application Layer (State + Cubit)

1. Create the Freezed state in `lib/application/states/<feature>_state.dart`:
   - `implements HasEffects`.
   - `@Default(<AppEffect>[]) List<AppEffect> effects`.
   - `stateEffects` getter.

2. Create the cubit in `lib/application/cubits/<feature>_cubit.dart`:
   - `extends Cubit<State> with EffectMixin<State>`.
   - Implement `copyStateWithEffects` and `logger`.
   - Constructor-inject all dependencies.
   - Private `_init()` for stream subscriptions.
   - Cancel subscriptions in `close()`.

### Step 4: Presentation Layer (Screen + Widgets)

1. Create the screen in `lib/presentation/screens/<feature>_screen.dart`:
   - Follow the **three-layer pattern**:
     - **Screen** — `BlocProvider` creates the cubit.
     - **Listener** — `BlocListener` handles effects via `AppEffectHandler`.
     - **View** — `BlocBuilder` renders UI.
   - Annotate the outer widget with `@RoutePage()`.

2. Add reusable widgets to `lib/presentation/widgets/styled/` if needed.

### Step 5: Routing

1. Add the route in `lib/core/router/app_router.dart` under the correct parent (`RootRoute` or `TabsRoute`).
2. Run code generation.

### Step 6: Dependency Injection

1. Register the repository (lazy singleton) and cubit (factory) in `lib/core/di/locator.dart`.
2. Follow the registration order: services → notifiers → repositories → cubits.

### Step 7: Code Generation

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 8: Verification

```sh
flutter analyze
flutter test
```

---

## Code Style & Conventions

### General

- **No `BuildContext` in cubits** — use effects for navigation/dialogs.
- **Immutable state only** — always use `state.copyWith()`, never mutate.
- **Cancel stream subscriptions** — always call `.cancel()` in `cubit.close()`.
- **No manual edits to `*.g.dart`** — these are generated. Run `build_runner` instead.

### Naming

| Concept | Convention | Example |
|---------|-----------|---------|
| Abstract entity | `Noun` | `Anime`, `User` |
| Freezed model | `NounModel` | `AnimeModel`, `UserModel` |
| Data model | `SourceNounModel` | `AnilistAnimeModel` |
| Repository interface | `NounRepository` | `AnimeRepository` |
| Repository impl | `NounRepositorySource` | `AnimeRepositoryAnilist` |
| Cubit | `FeatureCubit` | `HomeCubit`, `AnimeDetailsCubit` |
| State | `FeatureState` | `HomeState`, `AnimeDetailsState` |
| Screen | `FeatureScreen` | `HomeScreen`, `AnimeDetailsScreen` |
| Notifier | `NounNotifier` | `AnimeNotifier`, `UserNotifier` |
| Barrel file | `nouns.dart` | `animes.dart`, `entities.dart` |

### Generated Files

The following are auto-generated and must never be edited manually:

- `*.freezed.dart` — Freezed code generation
- `*.g.dart` — JSON serialization, Hive adapters
- `lib/generated/json/*.g.dart` — JSON model generation
- `lib/hive_registrar.g.dart` — Hive adapter registration
- `lib/core/router/app_router.gr.dart` — AutoRoute generation

### Effect Conventions

- Use `handleError("...", stackTrace: stackTrace)` for errors (logs + snackbar).
- Use `pushRouteEffect(path: "/...")` for navigation.
- Use `showWidgetDialogEffect(dialog: ...)` for dialogs.
- Always pass `cubit.clearEffects` to `AppEffectHandler.handleEffects()`.

---

## Build, Test & Analyze

### Essential Commands

```sh
# Install dependencies
flutter pub get

# Generate code after any Freezed/JSON/Hive/AutoRoute changes
flutter pub run build_runner build --delete-conflicting-outputs

# Run static analysis
flutter analyze

# Run tests
flutter test

# Build release (Linux example)
flutter build linux --release
```

> **Always run `build_runner` after `flutter pub get` or after modifying any codegen-related files.**

---

## Multi-Repository Setup

### `unyo` (this repo)

The Flutter desktop app. Depends on `unyo_lib` as a local path dependency.

### `unyo_lib` (sibling directory)

Flutter FFI package bridging to the JVM runtime via JNI:

```sh
cd ../unyo_lib
fvm flutter pub get
fvm flutter test
```

Key files:
- `lib/aniyomi_bridge.dart` — main API
- `lib/jni_isolate.dart` — JNI isolate worker
- `lib/jmodels/` — auto-generated JNI bindings (never edit manually)

### `unyo-core` (sibling directory)

Java/Kotlin Maven multi-module project providing the JVM runtime for Aniyomi/Tachiyomi extensions:

```sh
cd ../unyo-core
mvn clean package -DskipTests
```

Output: `aniyomi-bridge/target/aniyomiBridge-1.0.0.jar`

After building, copy the JAR to `unyo_lib/assets/unyo-core.jar` so the Flutter app picks it up.

### Go Binding (Torrent Server)

The torrent server (`libmtorrentserver`) lives in a separate Go module (`go/binding/desktop/`). It must be compiled per-platform as a c-shared library. The CI handles this during releases.

---

## Submitting Changes

1. **Fork** the repository.
2. **Create a branch**: `git checkout -b feature/your-feature-name`.
3. **Make your changes** following the conventions above.
4. **Run verification**:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter analyze
   flutter test
   ```
5. **Commit** with a descriptive message.
6. **Push** to your fork.
7. **Open a Pull Request** against `main`.

### PR Checklist

- [ ] `flutter analyze` passes with no new errors.
- [ ] Codegen files are up to date (`*.g.dart`, `*.freezed.dart`).
- [ ] New features follow the layer pattern (Domain → Data → Application → Presentation).
- [ ] Cubits use `EffectMixin` and do not hold `BuildContext`.
- [ ] Stream subscriptions are canceled in `close()`.
- [ ] DI registrations follow the correct order and use the right registration type.

---

## Getting Help

- Open an **issue** for bugs or feature requests.
- Check existing **skills** in `.agents/skills/` for detailed workflow documentation.
- Review existing code in the same layer you're modifying — the codebase is the best reference.

Thank you for contributing to Unyo!
