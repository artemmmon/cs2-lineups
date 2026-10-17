# Null safety and types

## Flag
- `x!` where nothing above proves `x` is non-null (no preceding `if (x != null)`,
  no just-assigned value) — a null there is a runtime crash, not a compile error.
- `late` on a field that can plausibly be read before it is set (no clear
  always-initialize-first call path, e.g. set only inside a conditional branch).
- `dynamic`, or an unchecked `as Type` / `as Map<String, dynamic>`, on data decoded from
  JSON, a platform channel, or a query param — prefer a generated/checked model
  (`fromJson`) or a runtime type check with a clear error.
- A `switch` over a sealed class / enum with a `default` that silently swallows a case a
  future addition would need to handle, where exhaustiveness would have caught it.
- A class holding meaningful value data with no `==`/`hashCode` (or `Equatable`/`freezed`)
  — breaks equality-dependent code (Bloc state comparison, `Set`/`Map` keys, tests).

## Do not report
- `!` immediately after a null check in the same expression/statement, or on a value
  the type system already proved non-null.

## Severity
CRITICAL when the unsafe cast/assertion sits on data from an external source
(network, platform channel, deep link). WARNING for internal, well-controlled data.