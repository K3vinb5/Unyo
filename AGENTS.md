# Unyo Agent Guide

## Build & Codegen

```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build linux --release
```

**Always run `build_runner` after `flutter pub get`** or after modifying any files using code generation (freezed, json_serializable, hive_ce_generator, auto_route). Do NOT manually edit `*.g.dart` files — they are generated.

### Testing
```sh
flutter test
```

### Analysis
```sh
flutter analyze
```

## Architecture

- **Flutter desktop app** (Linux, Windows, macOS) — anime streaming & manga reader
- **State**: BLoC (`flutter_bloc` + `rxdart`)
- **DI**: `get_it` via `lib/core/di/locator.dart`
- **Codegen tools**: `freezed`, `json_serializable`, `hive_ce_generator`, `auto_route`, `auto_route_generator`
- **Key generated files**: `*.g.dart` (Hive, Freezed, JSON), `lib/generated/json/*.g.dart`, `lib/hive_registrar.g.dart`
- **External Go binding**: The torrent server (`libmtorrentserver`) is built from `go/binding/desktop/` — cloned separately; must be compiled per-platform as a c-shared library

## Dependencies

- `unyo_lib` is a local path dependency (`../unyo_lib`). Ensure it exists as a sibling directory.
- Local extensions require **Java 17+** installed.

## Flutter Version

Pinned to **3.38.1** (see `.fvmrc`). Use `fvm flutter` if managing multiple versions.

## Release Process

Releases are triggered by **git tags**. The CI workflow (`main.yml`) builds Go bindings for all three platforms, then runs the Flutter build. Do not manually edit generated `.g.dart` files before a release tag.
