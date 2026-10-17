# Resource disposal

Every controller, subscription and timer a widget or a Bloc/Cubit creates must be
released, or it leaks and can fire callbacks against a disposed tree.

## Flag
- A `TextEditingController`, `AnimationController`, `ScrollController`, `PageController`
  or `FocusNode` created in `initState`/a field without a matching `.dispose()` in
  `dispose()`.
- A `StreamSubscription` from `.listen(...)` with no `.cancel()`.
- A `Timer`/`Timer.periodic` with no `.cancel()`.
- A `Bloc`/`Cubit` instantiated directly (`MyCubit()`, not via `BlocProvider(create: ...)`)
  with no `.close()` — or a `BlocProvider.value` that closes a bloc it does not own.
- A `ChangeNotifier` subclass with a missing `super.dispose()` or a listener added
  without `removeListener`.

## Do not report
- A controller passed in from a parent and NOT created by this widget — the owner
  disposes it, not this one. Same for `BlocProvider.value`'s bloc.
- Disposal already present under a different but equivalent method name/pattern.

## Severity
CRITICAL for a leak on a screen that is created/destroyed often (a list item, a
dialog, a route pushed repeatedly). WARNING for a singleton-lifetime screen.