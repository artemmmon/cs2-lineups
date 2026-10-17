# UI accessibility and theming

## Flag
- An icon-only, tappable control (`IconButton`, a bare `GestureDetector` around an
  `Icon`) with no `tooltip`/`Semantics(label: ...)` — a screen reader has nothing to
  announce.
- A tappable target smaller than ~48x48 logical pixels with no extra hit-area padding.
- A hardcoded `Color(0x...)`/named color or a hardcoded `TextStyle`/font size where the
  repo has a `ThemeData`/`ColorScheme` already in use nearby — breaks dark mode and
  custom themes.
- A fixed-height container wrapping text with no overflow handling
  (`overflow`/`maxLines`/a scrollable) — clips or overflows when the user's text-scale
  setting is increased.
- A `Row`/`Column` of text and controls with no `Flexible`/`Expanded` where content can
  grow, risking a render overflow.

## Do not report
- Intentional brand colors that don't come from the theme, when the surrounding code
  already establishes that pattern consistently.

## Severity
WARNING throughout — these are usability/accessibility regressions, not correctness
bugs, unless the overflow would visually hide a critical action (then CRITICAL).