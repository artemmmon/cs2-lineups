# Bloc/Cubit conventions

## Flag
- A state class that is mutable (no `Equatable`/`freezed` value equality, or a
  `copyWith` that forgets a field) — `BlocBuilder` then skips rebuilds it shouldn't.
- `BuildContext` or any widget type held inside a Bloc/Cubit or its state/event.
- `emit(...)` called after an `await` with no `if (isClosed) return;` guard, or after
  `close()` could plausibly have run.
- A `Bloc`'s `on<Event>` handler with no event transformer (`droppable()`/`restartable()`/
  `sequential()`) on a handler that starts async work and can be re-triggered rapidly
  (search-as-you-type, submit button) — the default is unbounded concurrent processing.
- Business logic or a repository call inside `BlocListener`/`BlocConsumer`'s listener when
  it belongs in the Bloc/Cubit; conversely, navigation or a SnackBar inside `BlocBuilder`'s
  builder (a builder must be a pure function of state — side effects belong in the listener).
- `context.read<X>()` inside `build()` instead of `context.watch<X>()`/`BlocBuilder` (misses
  rebuilds), or the reverse: `context.watch` inside a callback (rebuilds needlessly, and
  can throw outside the widget tree's build phase).
- A repository/service instantiated directly inside a Bloc/Cubit instead of injected via
  its constructor — makes the Bloc untestable without a real backend.

## Do not report
- Provider/Riverpod/GetX/MobX state management with no Bloc/Cubit in the diff — this
  skill does not apply.

## Severity
CRITICAL for emit-after-close or a BuildContext leak into state. WARNING for the rest.