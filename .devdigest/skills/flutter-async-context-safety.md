# Async + BuildContext safety

A widget can be disposed while an `await` is pending. Using its `context`, calling
`setState`, or reaching `Navigator`/`ScaffoldMessenger` after that throws or acts on a
dead tree.

## Flag
- `context` (or anything derived from it — `Theme.of(context)`, `Navigator.of(context)`)
  used after an `await` with no `if (!context.mounted) return;` (or `if (!mounted)` in a
  `State`) between the await and the use.
- `setState(...)` called after an `await` with no mounted guard.
- A `BuildContext` captured in a closure, callback, or passed into an async function and
  used later without re-checking `mounted`.
- `Navigator.pop`/`push`, `ScaffoldMessenger.of(context).showSnackBar` after async work,
  ungated.

## Do not report
- Synchronous use of `context` (no `await` in between).
- A guard already present, however it's spelled (`mounted`, `context.mounted`, an early
  return checking a cancellation token before touching `context`).

## Severity
CRITICAL when the missing guard is on the main flow of new behaviour (a common user
action: submit, navigate, load). WARNING for a secondary/rare path.