# Dart async correctness

## Flag
- A `Future` started and not awaited, stored, or wrapped in `unawaited(...)` — its
  error is silently dropped and its side effect races the surrounding code.
- `list.forEach((x) async { await ... })` — `forEach` does not await its callback; the
  futures run unordered and the caller moves on before they finish. Use a `for` loop
  (sequential) or `Future.wait` (parallel).
- `FutureBuilder`/`StreamBuilder` whose `future`/`stream` argument is created inline in
  `build()` (e.g. `future: fetchData()`) — a new future starts on every rebuild.
- A `Stream` subscription or controller with no `onError`, silently dropping errors.
- `Future.wait` on futures where one failing should not cancel the others, used without
  `eagerError: false` when that is the intent.
- CPU-heavy synchronous work (JSON parsing/decoding a large payload, image processing)
  run directly on the UI isolate instead of via `compute()`/an isolate — causes jank.

## Do not report
- A fire-and-forget future that is a deliberate, explicit `unawaited(...)` with a comment
  or an error handler attached (`.catchError`).

## Severity
CRITICAL when a dropped error can hide a failed write/payment/critical action.
WARNING for jank or a cosmetic race.