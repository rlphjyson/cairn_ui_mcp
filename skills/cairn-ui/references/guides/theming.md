# Theming

CairnTheme is a ThemeExtension carrying nineteen semantic colour slots, a radius base and a font family. Everything else is derived.

### Why a ThemeExtension

This is a deliberate integration choice, not a shortcut. An inherited widget of Cairn's own would force host apps to nest two theme systems and would break any Material widget already in use. Riding on ThemeData.extensions instead means three things:

- Cairn composes inside an ordinary MaterialApp; nothing has to be abandoned or wrapped.
- Flutter animates theme changes for free, because ThemeExtension.lerp is driven by AnimatedTheme during a light/dark transition — the toggle in this site's header is a plain setState, and the crossfade you see is Flutter interpolating every token.
- Theme.of(context) stays the single lookup path developers already know.

```dart
MaterialApp(
  theme: CairnTheme.materialTheme(CairnTheme.light),
  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
)
```

materialTheme() also aligns Material's own defaults with the Cairn tokens: scaffold and canvas colours, a matching ColorScheme, text selection colours, no ink splash — Cairn's interactions are colour and shadow transitions, not ripples — and Material 3's filled TextField default switched off, since Cairn inputs are transparent-backed with a border.

If you would rather wire it yourself:

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const <ThemeExtension<dynamic>>[CairnTheme.light],
  ),
)
```


### The colour slots

Nineteen semantic slots, each named for the CSS custom property it is specified as. They come in background/foreground pairs so that a surface and the text on it always move together.

| Slot | CSS variable | What it is |
| --- | --- | --- |
| background / foreground | --background | The page surface and default body text |
| card / cardForeground | --card | Raised content surfaces |
| popover / popoverForeground | --popover | Floating surfaces: Popover, Dropdown, Select, Tooltip, Command |
| primary / primaryForeground | --primary | High-emphasis fills: default Button, checked Checkbox and Switch, Progress |
| secondary / secondaryForeground | --secondary | Low-emphasis fills: secondary Button and Badge |
| muted / mutedForeground | --muted | De-emphasised backgrounds and secondary text |
| accent / accentForeground | --accent | Hover and keyboard-focus highlight for interactive rows |
| destructive / destructiveForeground | --destructive | Danger fills and destructive text |
| border | --border | Hairlines and component outlines |
| input | --input | The border colour of form controls specifically |
| ring | --ring | The focus ring, drawn at 50% alpha and 3px |

> **destructiveForeground is a real slot, not a hardcoded white** The common convention is to paint white text onto a destructive fill and leave it at that, which stops working the moment someone themes destructive to a pale colour. Cairn keeps the foreground as its own themeable slot and merely defaults it to white.


### Tones

The palette stops at primary, secondary and destructive, which is not enough for components that carry state. CairnTone adds the missing ones: an enum of neutral, primary, success, warning, info and destructive, resolved against the active theme by CairnToneColors.resolve into a fill and the foreground that belongs on it.

| Tone | Light | Dark |
| --- | --- | --- |
| success | green-600 | green-400 |
| warning | amber-500 | amber-400 |
| info | blue-600 | blue-400 |

Like every other Cairn colour, the additions are authored in OKLCH with separate light and dark values. Status, Steps, Timeline, Rating and Radial Progress all take a tone.

```dart
final CairnToneColor c = CairnToneColors.resolve(
  CairnTheme.of(context),
  CairnTone.success,
);
// c.fill for dots and markers, c.onFill for text placed on it
```


### The radius scale

One base, --radius, defaults to 0.625rem = 10 logical pixels. Every other step is a multiplier of it rather than a fixed offset from it, which is what lets a single number rescale an entire app:

| Step | Formula | Default | Used by |
| --- | --- | --- | --- |
| xs | fixed 2px | 2 | Dialog and Sheet close affordances |
| sm | --radius × 0.6 | 6 | Badge, small chips |
| md | --radius × 0.8 | 8 | Button, Input, Textarea, Select, Popover, Dropdown |
| lg | --radius | 10 | Dialog, Alert, Tabs list |
| xl | --radius × 1.4 | 14 | Card |
| 2xl | --radius × 1.8 | 18 |  |
| full | 9999 | pill | Avatar, Switch, Pagination |

Change radius on the theme and every component's corners rescale proportionally. Read theme.radiusScale in your own widgets so they rescale too.

```dart
final CairnTheme tight = CairnTheme.dark.copyWith(radius: 4.0);
// tight.radiusScale.md == 3.2, tight.radiusScale.xl == 5.6
```


### Customising

copyWith on either preset. Nothing else is needed — there is no builder, no config file and no code generation.

```dart
final CairnTheme brand = CairnTheme.light.copyWith(
  primary: const Color(0xFF3B82F6),
  primaryForeground: const Color(0xFFFFFFFF),
  radius: 4.0,
  fontFamily: 'Inter',
);

MaterialApp(theme: CairnTheme.materialTheme(brand));
```


### Derived values

A few things are computed from the slots rather than stored, so they cannot drift out of sync:

| Getter | What it returns |
| --- | --- |
| ringMuted | ring at 50% alpha — Tailwind's ring-ring/50 |
| focusRing | The ring as a BoxShadow list: zero offset, zero blur, 3px spread, because Tailwind compiles ring-[3px] to box-shadow: 0 0 0 3px |
| invalidRing | The ring tinted destructive, at 20% in light and 40% in dark |
| radiusScale | The derived rounded-* scale for this theme's radius |
| defaultTextStyle | text-sm in foreground |


### The opacity modifier trap

Tailwind's /N modifier scales a colour's existing alpha; it does not set it. bg-input/30 compiles to color-mix(in oklab, var(--input) 30%, transparent). For an opaque token that is the same as setting alpha to 0.30 — but Cairn's dark --input is already oklch(1 0 0 / 15%), so dark:bg-input/30 is white at 4.5%, not 30%. Six times too strong is very visible as a washed-out grey fill on every dark-mode form control.

```dart
// The extension Cairn ships for exactly this.
extension CairnOpacityModifier on Color {
  Color withOpacityModifier(double factor) =>
      withValues(alpha: a * factor.clamp(0.0, 1.0));
}

theme.input.withOpacityModifier(0.3); // scales, does not replace
```