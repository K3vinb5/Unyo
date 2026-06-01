---
name: fjson-dart-bean-generator
description: Generate Dart bean classes from JSON and regenerate serialization helpers using the fjson CLI. Use this skill whenever the user needs to create Dart models from API JSON responses, generate @JsonSerializable entity classes, or regenerate .g.dart helper files. Also use when the user mentions FlutterJsonBeanFactory, fjson, json_to_dart, JSON serialization, @JSONField, @JsonSerializable, or needs to add new API response DTOs to the unyo project.
---

# fjson CLI — Dart Bean Generator

The fjson CLI generates `@JsonSerializable` Dart entity classes from JSON responses and regenerates `.g.dart` serialization helpers, `json_field.dart`, and `json_convert_content.dart`. It replaces the FlutterJsonBeanFactory IntelliJ plugin for CLI/agent workflows.

The bundled JAR lives inside this skill directory: **`fjson-cli.jar`**. Invoke it as:

```bash
java -jar <path-to-skill>/fjson-cli.jar <command> [options]
```

When running from the unyo project root, the skill is at `.agents/skills/fjson-dart-bean-generator/`:

```bash
java -jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar <command> [options]
```

If you need to rebuild the JAR (rare — only after modifying fjson-cli source):

```bash
cd ../fjson-cli && ./gradlew jar
# Then copy the new JAR into the skill:
cp ../fjson-cli/build/libs/fjson-cli.jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar
```

## Two Commands

| Command | Purpose | When to use |
|---------|---------|-------------|
| `fjson bean` | Create a new entity `.dart` file from JSON | User provides a class name + JSON (string or file) |
| `fjson gen` | Regenerate all `.g.dart` helpers, `json_field.dart`, `json_convert_content.dart` | After adding/modifying any `@JsonSerializable` class |

> **Important**: `fjson bean` **automatically runs** `fjson gen` when invoked inside a Flutter project (one with a `pubspec.yaml`). You do NOT need to run `gen` separately after `bean`.

## `fjson bean` — Generate a new entity from JSON

### Required flags

| Flag | Description | Example |
|------|-------------|---------|
| `--class <Name>` | Root class name (use the API response root name) | `--class MediaResponse` |
| `--json <string>` | Raw JSON string | `--json '{"id":1,"title":"..."}'` |
| `--file <path>` | Path to a `.json` file (alternative to `--json`) | `--file response.json` |

### Optional flags

| Flag | Description | Default | When to use |
|------|-------------|---------|-------------|
| `--output <path>` | Directory for the generated `.dart` file | `./lib` | Direct entity to correct DTO subfolder |
| `--suffix <text>` | Suffix appended to generated class names | `entity` | Leave as default for unyo |
| `--nullable` | Make fields nullable (`Type?`) | off | Rarely needed in unyo |
| `--set-default` | Assign default values to primitive fields | off | **Always use this for unyo DTOs** |
| `--project <path>` | Flutter project root | `.` | Usually not needed from unyo root |

### Typical unyo invocation

```bash
java -jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar bean \
  --class MediaCollectionResponse \
  --json '<paste JSON here>' \
  --output ./lib/core/services/api/dto/anilist/ \
  --set-default
```

Or from a file:

```bash
java -jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar bean \
  --class AnizipEpisodeInfo \
  --file ./response.json \
  --output ./lib/core/services/api/dto/anizip/ \
  --set-default
```

### What gets generated

The command produces a `.dart` file containing:

- A root `@JsonSerializable()` class with `--suffix` appended (e.g., `MediaCollectionResponse` → `MediaCollectionResponseEntity`)
- Nested `@JsonSerializable()` classes for each nested JSON object (e.g., `MediaCollectionResponseDtoPage`)
- `@JSONField(name: 'original_key')` annotations for keys whose Dart naming differs from JSON
- `late` fields with default values (if `--set-default`)
- `fromJson()` factory and `toJson()` method stubs
- `import` of `json_field.dart` and the matching `.g.dart`
- `export` of the matching `.g.dart`

The generated entity **also auto-triggers `fjson gen`**, so the matching `.g.dart`, `json_field.dart`, and `json_convert_content.dart` are all regenerated immediately.

## `fjson gen` — Regenerate all helpers

```bash
java -jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar gen --project .
```

This scans `lib/**/*.dart` for every `@JsonSerializable` class and:

1. Regenerates each `<entity>.g.dart` file in `lib/generated/json/`
2. Rebuilds `lib/generated/json/base/json_field.dart` (annotation definitions)
3. Rebuilds `lib/generated/json/base/json_convert_content.dart` (the `JsonConvert` runtime and `JsonConvertClassCollection` registry with all entity imports)
4. Deletes any stale `.g.dart` files for entities that no longer exist

Run this **after any manual edit** to an entity file (adding/removing/renaming fields).

## Generated File Layout in unyo

```
unyo/
├── lib/core/services/api/dto/
│   └── anilist/
│       └── media_response_entity.dart          ← fjson bean output
└── lib/generated/json/
    ├── media_response_entity.g.dart             ← auto-generated helpers
    ├── media_collection_graphql_entity.g.dart   ← existing
    ├── ...                                      ← all other .g.dart
    └── base/
        ├── json_field.dart                     ← annotations
        └── json_convert_content.dart            ← registry + runtime
```

### Entity file naming convention in unyo

- **Snake_case filenames**: e.g., `media_details_graphql_entity.dart`
- **PascalCase class names**: e.g., `MediaDetailsGraphqlEntity`
- fjson converts PascalCase `--class` names to snake_case filenames automatically
- Always place entities in the correct DTO subfolder: `lib/core/services/api/dto/<provider>/`
  - Providers: `anilist/`, `anizip/`, `aniskip/`, `extensions/`

### Default unyo settings that fjson matches

- `--set-default` is always used → all fields get `= ''`, `= 0`, `= false`, etc.
- `--suffix entity` (default) → class names end with `Entity`
- `flutter_json.generated_path` is `generated/json` in `pubspec.yaml`

## Workflow: Adding a new API response model

1. **Get the JSON** — Either from the user, from a file, or from a GraphQL response
2. **Determine the provider** (anilist, anizip, aniskip, extensions)
3. **Run `fjson bean`** with `--class`, `--json/--file`, `--output`, and `--set-default`:
   ```bash
   java -jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar bean \
     --class NewApiResponse \
     --json '<the JSON>' \
     --output ./lib/core/services/api/dto/anilist/ \
     --set-default
   ```
4. **Verify the output** — Open the generated `.dart` file and check:
   - Class names and field types are correct
   - Nested objects are properly generated as sub-classes
   - `@JSONField(name: ...)` mappings are correct for non-matching keys
5. **Update `json_convert_content.dart`** — Already done automatically by `fjson gen` (triggered by `fjson bean`). Verify the new entity's import is present.
6. **Run analysis** — `flutter analyze` to ensure no issues
7. **If fields need adjustment** — Edit the entity file directly, then re-run `fjson gen`:
   ```bash
   java -jar .agents/skills/fjson-dart-bean-generator/fjson-cli.jar gen --project .
   ```

## Common Pitfalls

- **Wrong `--output` path**: Entity files must go to the correct provider subfolder (`lib/core/services/api/dto/<provider>/`) for the import in `json_convert_content.dart` and `.g.dart` files to resolve correctly.
- **Forgetting `--set-default`**: Without it, fields use `late` without defaults. In unyo, all DTO fields have defaults (except `dynamic`).
- **Running in wrong directory**: Commands assume the current working directory is the unyo project root (where `pubspec.yaml` lives). The `--project` flag overrides this.
- **Class name collision**: If a class name already exists in another entity file, the generated `.g.dart` will have duplicate function names, causing compile errors. Check for existing names before running.
- **JSON with empty arrays**: fjson handles this but cannot infer the element type of an empty `List`. The field will be typed `List<dynamic>` and must be corrected manually.
- **After running `bean` in a non-Flutter directory**: `fjson gen` is skipped. You must manually run it from the project root.

## Cross-references

- **unyo project structure and entity patterns**: See `unyo-domain-data-layer` skill
- **DTO conventions and GraphQL response mapping**: See `unyo-domain-data-layer` skill
- **Rebuilding fjson-cli from source**: See `../fjson-cli/README.md`
