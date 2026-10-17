# Platform, assets and localization

## Flag
- An asset (image, font) referenced in Dart code (`Image.asset`, `rootBundle.load`) with
  no matching entry under `flutter: assets:`/`fonts:` in `pubspec.yaml`.
- A new plugin that needs a permission (camera, location, notifications, bluetooth) with
  no corresponding entry in `AndroidManifest.xml` (`<uses-permission>`) or `Info.plist`
  (an `NSXxxUsageDescription` key) in the same diff.
- A `MethodChannel`/`EventChannel` name or method name that changed on one platform side
  (Dart) without the matching native side, or vice versa — a channel mismatch fails
  silently at runtime (`MissingPluginException`).
- A new user-facing string hardcoded in a widget instead of added to the app's `.arb`
  files, when the repo has a localization setup (an `l10n.yaml` or `AppLocalizations` in
  the diff/repo).
- A key added to one locale's `.arb` file but not the app's other locale files (when more
  than one `.arb` exists in the repo).

## Do not report
- An asset/permission already present before this diff and merely referenced again.
- Repos with no localization setup at all — don't invent the requirement.

## Severity
WARNING — these fail at runtime, not compile time, but rarely corrupt data or leak
information. CRITICAL only if the missing permission would crash the app on launch.