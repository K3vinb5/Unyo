---
name: unyo-domain-data-layer
description: How to create domain entities, data models, and repositories in the Unyo Flutter app. Use this skill whenever adding new data types, creating repository interfaces or implementations, defining Freezed models, setting up Hive adapters, or mapping API responses to domain objects in the Unyo codebase. Also use when modifying existing entities, models, or data fetching logic.
---

# Unyo Domain & Data Layer

This skill covers the domain/data architecture in Unyo: entities, models, and repositories. Everything starts here — before you add a cubit, screen, or notifier, you need the domain and data layer in place.

## Architecture Overview

```
lib/
├── domain/
│   ├── entities/          # Abstract business objects
│   │   ├── anime.dart     # Abstract class + Freezed implementation
│   │   └── entities.dart  # Barrel export
│   └── repositories/      # Abstract repository contracts
│       ├── anime_repository.dart
│       └── repositories.dart  # Barrel export
├── data/
│   ├── models/            # Concrete Freezed models with JSON mapping
│   │   ├── anilist_anime_model.dart
│   │   └── models.dart    # Barrel export
│   ├── repositories/      # Repository implementations
│   │   ├── anime_repository_anilist.dart
│   │   ├── repository_mixin.dart
│   │   └── repositories.dart  # Barrel export
│   └── adapters/          # Hive type adapters
├── generated/json/        # Generated JSON serialization code
└── core/services/api/     # API services and DTOs
    ├── graphql/            # GraphQL service, queries, responses
    ├── http/               # HTTP service, responses, exceptions
    └── dto/                # Data Transfer Objects (API response models)
```

## Pattern: Entity Definition

Domain entities live in `lib/domain/entities/`. They use a **dual-class pattern**: an abstract base class defining the contract, and a Freezed-generated implementation class.

**Why two classes?** The abstract class lets repositories return a stable domain type while data models can vary by provider (AniList, MAL, etc.). The Freezed class gets `copyWith`, equality, and JSON serialization for free.

### Creating a new entity

1. Create the abstract class and Freezed model in one file:

```dart
// lib/domain/entities/anime.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'airing_episode.dart';
import 'title.dart';

part 'anime.freezed.dart';
part 'anime.g.dart';

// Abstract base — the domain contract
abstract class Anime {
  final int id;
  final String coverImage;
  // ... all fields as final

  const Anime({
    required this.id,
    required this.coverImage,
    // ... all required parameters
  });
}

// Freezed implementation — adds copyWith, equality, JSON
@freezed
abstract class AnimeModel with _$AnimeModel implements Anime {
  const factory AnimeModel({
    required int id,
    @TitleConverter() required Title title,
    required String coverImage,
    // ... all fields matching the abstract class
  }) = _AnimeModel;

  // Factory for empty/default instances (used in initial state)
  factory AnimeModel.empty() => AnimeModel(
        id: -1,
        title: TitleModel.empty(),
        coverImage: '',
      );

  // JSON serialization
  factory AnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeModelFromJson(json);

  // Required for toJson on the abstract type
  @override
  Map<String, dynamic> toJson() =>
      _$AnimeModelToJson(this as _AnimeModel);
}

// Converter for use in other Freezed classes that reference this type
class AnimeConverter
    implements JsonConverter<Anime, Map<String, dynamic>> {
  const AnimeConverter();

  @override
  Anime fromJson(Map<String, dynamic> json) =>
      AnimeModel.fromJson(json);

  @override
  Map<String, dynamic> toJson(Anime object) =>
      (object as AnimeModel).toJson();
}
```

2. **Always pair abstract + Freezed** — never use Freezed alone for a domain entity that other code references. Other code should depend on the abstract class, not the model.

3. **Custom JSON converters** are needed when a Freezed class references another abstract entity type. The converter delegates to the concrete model's `fromJson`/`toJson`. Name them `<EntityName>Converter`.

4. **Empty factories** are essential — cubit initial states need default values. Every entity should have an `.empty()` factory.

5. **Add the entity to the barrel export** in `lib/domain/entities/entities.dart`.

6. **Run code generation** after creating or modifying any entity:

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

## Pattern: Data Model with API Mapping

Data models in `lib/data/models/` extend domain entities by adding **factory constructors** that map from API response DTOs.

### Key conventions

- Models use Freezed `implements Anime` (the abstract class), NOT `extends Anime`
- Named factories like `fromScheduleEntry()`, `fromPopularOrTrendingMediaEntry()` map specific API responses
- The model file has `part 'model_name.freezed.dart'` and `part 'model_name.g.dart'`
- Models must match all fields from the abstract class exactly (same names, same types)

### Creating a model for a new data source

```dart
// lib/data/models/anilist_anime_model.dart
@freezed
abstract class AnilistAnimeModel with _$AnilistAnimeModel implements Anime {
  const AnilistAnimeModel._();  // Private constructor for custom methods

  const factory AnilistAnimeModel({
    required int id,
    required String coverImage,
    // ... all fields from Anime abstract class
  }) = _AnilistAnimeModel;

  // Map from AniList API DTO
  factory AnilistAnimeModel.fromScheduleEntry(
      MediaCollectionRecentlyReleasedDto schedule) {
    return AnilistAnimeModel(
      id: schedule.media.id,
      coverImage: schedule.media.coverImage.large,
      // ... map all fields
    );
  }

  factory AnilistAnimeModel.fromJson(Map<String, dynamic> json) =>
      _$AnilistAnimeModelFromJson(json);
}
```

**Important**: When there are multiple API sources (AniList, MAL, etc.), each source gets its own model file (e.g., `mal_anime_model.dart`) but they all implement the same `Anime` abstract class.

## Pattern: Repository Interface & Implementation

Repositories follow a strict interface-implementation separation:

### 1. Define the repository interface

```dart
// lib/domain/repositories/anime_repository.dart
abstract class AnimeRepository {
  Future<(bool, List<Anime>)> getTrendingAnimes(int page, User loggedUser);
  Future<(bool, AnimeDetails)> getAnimeDetails(Anime selectedAnime, User loggedUser);
  // ... all methods as abstract
}
```

**Convention**: Methods return Dart records `(bool, List<Anime>)` where the bool indicates if there's a next page. Methods take `User` typed parameters (the abstract `User`, not `AnilistUserModel`).

### 2. Implement with RepositoryMixin

```dart
// lib/data/repositories/anime_repository_anilist.dart
class AnimeRepositoryAnilist with RepositoryMixin implements AnimeRepository {
  final GraphQLService _anilistGraphQLService = sl<GraphQLService>(
    instanceName: config.anilistGraphQlService,
  );
  final Logger _logger = sl<Logger>();

  @override
  Future<(bool, List<Anime>)> getTrendingAnimes(int page, User loggedUser) async {
    // 1. Call the API service
    final response = await _anilistGraphQLService.query(
      query: anilist_queries.mediaTrendingOrPopularQuery,
      fromJson: MediaCollectionTrendingOrPopularGraphqlEntity.fromJson,
      variables: {"sort": "TRENDING_DESC", "page": page, "perPage": 30, "type": "ANIME"},
    );
    // 2. Use RepositoryMixin to check for errors
    throwIfGraphQlError(response);
    // 3. Map DTOs to domain models
    final animes = response.data.page.media
        .map((entry) => AnilistAnimeModel.fromPopularOrTrendingMediaEntry(entry))
        .toList();
    return (true, animes);
  }
}
```

**Key patterns**:
- Use `RepositoryMixin.throwIfGraphQlError()` to check for API errors — this throws a `GraphQLException` that cubits catch
- Name implementations after their data source: `AnimeRepositoryAnilist`, `AnimeRepositoryMal`, etc.
- Inject services via `sl<T>()` (service locator), not constructor params (repositories are singletons)

### 3. Add to barrel export

```dart
// lib/domain/repositories/repositories.dart
export 'anime_repository.dart';
// lib/data/repositories/repositories.dart
export 'anime_repository_anilist.dart';
```

## Pattern: API DTOs (Data Transfer Objects)

API response DTOs live in `lib/core/services/api/dto/`. They are generated from JSON using `json_serializable`:

```dart
// lib/core/services/api/dto/anilist/media_collection_trendingOrPopular_graphql_entity.dart
// These are typically auto-generated or manually created from the API schema
// They use json_annotation and have corresponding .g.dart files
```

**Convention**: DTO class names describe the API response structure (e.g., `MediaCollectionTrendingOrPopularGraphqlEntity`). They are internal to the data layer and never leak into domain or application code.

## Pattern: Hive Type Adapters

For entities that need local persistence via Hive:

1. The entity file must use `@HiveType(typeId: N)` annotations
2. An adapter file in `lib/data/adapters/` handles serialization
3. Register adapters in `main.dart` via `Hive.registerAdapter()` or `Hive.registerAdapters()` (auto-generated)

## Workflow: Adding a New Feature's Data Layer

When adding a completely new feature (e.g., "Studio browsing"):

1. **Entity**: Create `lib/domain/entities/studio.dart` with abstract class + Freezed model + converter
2. **Barrel**: Add export to `lib/domain/entities/entities.dart`
3. **Model** (if mapping from API): Create `lib/data/models/anilist_studio_model.dart` with mapping factories
4. **Repository interface**: Create `lib/domain/repositories/studio_repository.dart`
5. **Repository impl**: Create `lib/data/repositories/studio_repository_anilist.dart` using `RepositoryMixin`
6. **API DTOs** (if needed): Create in `lib/core/services/api/dto/anilist/`
7. **GraphQL queries** (if using GraphQL): Add to `lib/core/services/api/graphql/queries/anilist_queries.dart`
8. **Register in DI**: Add to `lib/core/di/locator.dart` (see `unyo-dependency-injection` skill)
9. **Run code gen**: `flutter pub run build_runner build --delete-conflicting-outputs`
10. **Run analysis**: `flutter analyze`

## Common Pitfalls

- **Missing `part` directives**: Every entity/model file needs `part 'filename.freezed.dart'` and `part 'filename.g.dart'` (if using JSON).
- **Field mismatches**: The Freezed factory must match the abstract class fields exactly. Missing or extra fields cause compile errors.
- **Converter forgetfulness**: If entity A references entity B via the abstract type in a Freezed class, you need a `BConverter`. Without it, Freezed generates code that tries to serialize the abstract type directly.
- **Forget to run build_runner**: After any change to `@freezed`, `@JsonSerializable`, or `@HiveType` annotated files, you must regenerate.
- **Leaking DTOs**: Never import DTO types in domain or presentation layers. The repository methods should return domain entities, and internal mapping from DTO to entity happens inside the repository implementation.

## Cross-references

- **Registering repositories in DI**: See `unyo-dependency-injection` skill
- **Using repositories in cubits**: See `unyo-bloc-state-management` skill
- **Sharing entity state across cubits**: See `unyo-reactive-notifiers` skill