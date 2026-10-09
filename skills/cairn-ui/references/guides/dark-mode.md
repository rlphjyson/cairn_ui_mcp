# Dark mode

Both themes ship. Switching between them is one field on MaterialApp, and Flutter animates every token across the change.

### The two presets

CairnTheme.light and CairnTheme.dark are Cairn's Neutral base — an achromatic palette specified in OKLCH, where every step lands exactly on a published neutral ramp. Hand both to MaterialApp and pick with themeMode:

```dart
MaterialApp(
  theme: CairnTheme.materialTheme(CairnTheme.light),
  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
  themeMode: _mode, // ThemeMode.dark, .light or .system
)
```


### How this site does it

The toggle in the header is a ChangeNotifier holding a ThemeMode, exposed through an InheritedNotifier. It defaults to ThemeMode.dark rather than ThemeMode.system, and it only ever moves between the two explicit modes — so a visitor whose OS is already dark still sees the control do something.

`lib/src/app/site_theme.dart`
```dart
class SiteThemeController extends ChangeNotifier {
  SiteThemeController({ThemeMode initial = ThemeMode.dark}) : _mode = initial;

  ThemeMode _mode;
  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
```

There is one escape hatch: appending ?theme=light to any URL on this site boots into the light theme. That is not a preference store — it exists so a light-mode screenshot can be captured head-lessly and so a link can point at a specific treatment. Anyone who simply opens the site still gets dark.

> **The crossfade is free** CairnTheme implements ThemeExtension.lerp, interpolating every colour slot and the radius. MaterialApp wraps its child in an AnimatedTheme, so flipping themeMode animates all nineteen slots over Flutter's default theme duration. There is no explicit animation anywhere in this site's toggle code.


### Where dark is not just inverted light

A handful of components genuinely branch on brightness rather than on a token, because the design calls for a dark-only treatment with no light counterpart. The outline Button gains a subtle fill in dark mode that simply does not exist in light mode; the invalid focus ring goes from 20% to 40% alpha, because a destructive tint that reads clearly on white disappears on near-black. CairnTheme carries brightness precisely so those branches can be honest about it.

The dark theme also switches borders from an opaque grey to a translucent white — --border is oklch(1 0 0 / 10%) — so that a hairline lifts correctly over both the page background and a raised card. That is why theme.border is not a flat colour you can blend against a known background.