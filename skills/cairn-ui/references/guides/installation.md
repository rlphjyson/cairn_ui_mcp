# Installation

Cairn is a normal Flutter package with no transitive dependencies. Add it, import one barrel, and register the theme extension.

### Add the dependency

From pub.dev, once published:

`pubspec.yaml`
```yaml
dependencies:
  cairn_ui: ^0.2.0
```

Or straight from git. Pin an exact commit rather than a branch — a floating ref means an upstream push can change what your app renders between two builds of the same source, which turns a visual regression into a mystery:

`pubspec.yaml`
```yaml
dependencies:
  cairn_ui:
    git:
      url: https://github.com/rlphjyson/cairn_ui.git
      ref: v0.2.0
```

```shell
flutter pub get
```


### Import

One barrel exports every component, token and theme type. There are no per-component imports to remember.

```dart
import 'package:cairn_ui/cairn_ui.dart';
```


### Register the theme

CairnTheme is a ThemeExtension, so it rides on ThemeData rather than introducing a second theme system. CairnTheme.materialTheme() builds a ThemeData whose Material defaults already agree with the Cairn tokens:

```dart
MaterialApp(
  theme: CairnTheme.materialTheme(CairnTheme.light),
  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
  themeMode: ThemeMode.dark,
  home: const HomeScreen(),
)
```

> **Components never throw for a missing theme** CairnTheme.of(context) falls back to CairnTheme.light rather than asserting, so a Cairn widget dropped into an app that never registered the extension still renders with correct tokens. Register the extension to control which theme is used, not to make things work at all.


### Fonts

Cairn's typography tokens leave fontFamily null — the type scale is about size, line height, weight and tracking, not about which typeface you use. Whatever your app sets is inherited. To use the font this site and the golden tests use, bundle Geist and set it once on the theme:

```dart
CairnTheme.materialTheme(
  CairnTheme.dark.copyWith(fontFamily: 'Geist'),
)
```

That is precisely what this site does — Geist is bundled under fonts/, registered in pubspec.yaml, and applied with a single copyWith at the theme root.


### Platform support

There is nothing platform-specific to break: no platform channels, no native code, no plugins. The package declares every target Flutter supports. This site is the Flutter web build.