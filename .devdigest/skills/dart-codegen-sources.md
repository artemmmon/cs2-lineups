# Codegen source hygiene

Generated files (`*.g.dart`, `*.freezed.dart`, …) never reach this review — only the
source that drives them does. Judge whether the source will still generate correctly
and consistently.

## Flag
- A `part '<name>.g.dart';` / `part '<name>.freezed.dart';` directive whose name does not
  match the current file's name (build_runner generates from the file name).
- A `@freezed` class that gained a hand-written method or getter without the
  `const ClassName._();` private constructor freezed requires to allow it.
- A field renamed or retyped in a `@JsonSerializable`/`@freezed` class with a
  `@JsonKey(name: ...)` that still points at the OLD wire name when the wire format
  should not have changed, or a missing `@JsonKey` when it should have been added.
- A new default value or required-ness added to a generated model's field without
  considering existing serialized/cached data that lacks it.
- A change to `build.yaml` (builder options, generated file extensions) with no mention
  of re-running `build_runner` in the PR description, when it would invalidate cached
  generated output.

## Do not report
- The generated file's own content — it is not in the diff you can see, and it is not
  the source of truth; the source class is.

## Severity
WARNING for a naming/consistency slip that build_runner will simply fail loudly on
(caught at build time, not runtime). CRITICAL only when it would silently change the
wire format of already-serialized/cached data.