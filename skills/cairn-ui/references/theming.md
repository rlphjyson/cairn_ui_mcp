# Theming

## `CairnTheme` (widget)

The design tokens every Cairn component reads from.

`CairnTheme` is a [ThemeExtension], which is the deliberate integration
choice for this library. The alternative — an inherited widget of Cairn's
own — would have forced host apps to nest two theme systems and would have
broken any Material widget they already use. Riding on
[ThemeData.extensions] instead means:

* Cairn composes inside an ordinary [MaterialApp]; nothing has to be
  abandoned or wrapped.
* Flutter animates theme changes for free, because [ThemeExtension.lerp] is
  driven by [AnimatedTheme] during a light/dark transition.
* `Theme.of(context)` stays the single lookup path developers already know.

## Usage

The direct form:

```dart
MaterialApp(
  theme: ThemeData(extensions: const <ThemeExtension<dynamic>>[CairnTheme.light]),
  darkTheme: ThemeData(extensions: const <ThemeExtension<dynamic>>[CairnTheme.dark]),
);
```

Or let [CairnTheme.materialTheme] build a [ThemeData] whose Material
defaults (scaffold background, text selection, splash behaviour) already
agree with the Cairn tokens:

```dart
MaterialApp(
  theme: CairnTheme.materialTheme(CairnTheme.light),
  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
);
```

Components resolve tokens with [CairnTheme.of], which falls back to
[CairnTheme.light] rather than throwing, so a widget dropped into an app
with no extension registered still renders correctly.

**Constructor** `CairnTheme({required Brightness brightness, required Color background, required Color foreground, required Color card, required Color cardForeground, required Color popover, required Color popoverForeground, required Color primary, required Color primaryForeground, required Color secondary, required Color secondaryForeground, required Color muted, required Color mutedForeground, required Color accent, required Color accentForeground, required Color destructive, required Color destructiveForeground, required Color border, required Color input, required Color ring, double radius = CairnRadius.base, String? fontFamily, List<String>? fontFamilyFallback})`

Creates a theme from an explicit set of tokens.

Prefer [CairnTheme.light] / [CairnTheme.dark] and [copyWith] for
customisation; this constructor exists for themes built from scratch.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `brightness` | `Brightness` | yes |  | Whether this is a light or dark theme. A handful of components genuinely branch on brightness rather than on a token, because the dark theme asks for a treatment with no light-mode counterpart. The outline Button is the clearest case: on a dark page a hairline border alone barely separates the control from its background, so it takes a faint fill that would be redundant in light mode. |
| `background` | `Color` | yes |  | The page surface. |
| `foreground` | `Color` | yes |  | Default body text on [background]. |
| `card` | `Color` | yes |  | Raised content surfaces. |
| `cardForeground` | `Color` | yes |  | Text on [card]. |
| `popover` | `Color` | yes |  | Floating surfaces: Popover, Dropdown Menu, Select, Tooltip bodies, Command palette. |
| `popoverForeground` | `Color` | yes |  | Text on [popover]. |
| `primary` | `Color` | yes |  | High-emphasis fills — the default Button, the checked Checkbox and Switch, the Progress indicator. |
| `primaryForeground` | `Color` | yes |  | Text and icons on [primary]. |
| `secondary` | `Color` | yes |  | Low-emphasis fills — the secondary Button and Badge. |
| `secondaryForeground` | `Color` | yes |  | Text on [secondary]. |
| `muted` | `Color` | yes |  | De-emphasised backgrounds — Slider track, Table footer. |
| `mutedForeground` | `Color` | yes |  | Secondary text — descriptions, placeholders. |
| `accent` | `Color` | yes |  | Hover and keyboard-focus highlight for interactive rows. |
| `accentForeground` | `Color` | yes |  | Text on [accent]. |
| `destructive` | `Color` | yes |  | Danger fills and destructive text. |
| `destructiveForeground` | `Color` | yes |  | The foreground paired with [destructive] fills. A slot of its own rather than a hardcoded white, so a theme that softens the destructive fill can move the text sitting on it as well. |
| `border` | `Color` | yes |  | Hairlines and component outlines. |
| `input` | `Color` | yes |  | The border color of form controls specifically. Tokenised separately from [border] so that inputs can read at a different weight from ordinary hairlines — which the dark theme uses, lifting form controls to 15% white where a plain border sits at 10%. |
| `ring` | `Color` | yes |  | The focus ring color. Components draw it at 50% alpha and 3px thickness; see [focusRing]. |
| `radius` | `double` |  | `CairnRadius.base` | The base corner radius, in logical pixels. Defaults to [CairnRadius.base] (10.0). Change this to rescale every component's corners proportionally; see [radiusScale]. |
| `fontFamily` | `String?` |  |  | The font family applied to all Cairn text. Null means "inherit whatever the host app set". Cairn names no typeface of its own, so it adopts the host's rather than imposing one. |
| `fontFamilyFallback` | `List<String>?` |  |  | Fallback families for [fontFamily]. |

**Static members**

- `CairnTheme light = CairnTheme(brightness: Brightness.light, background: CairnColors.lightBackground, foreground: CairnColors.lightForeground, card: CairnColors.lightCard, cardF...` — Cairn's default light theme.
- `CairnTheme dark = CairnTheme(brightness: Brightness.dark, background: CairnColors.darkBackground, foreground: CairnColors.darkForeground, card: CairnColors.darkCard, cardForeg...` — Cairn's default dark theme.
- `CairnTheme of(BuildContext context)` — Resolves the ambient theme, falling back to [CairnTheme.light]. The fallback is intentional: a Cairn widget used in an app that never registered the extension still renders with correct tokens instead of throwing. Register the extension to control which theme is used.
- `ThemeData materialTheme(CairnTheme cairn)` — Builds a [ThemeData] whose Material defaults agree with [cairn]. This does not replace Material — it aligns it, so a host app mixing Cairn widgets with Material ones does not get two clashing palettes. It sets the scaffold and canvas colors, a matching [ColorScheme], the text selection colors, and disables Material's ink splash (Cairn has no ripple; its interactions are colour and shadow transitions only).
- `double lerpDouble(double a, double b, double t)` — Linearly interpolates two non-null doubles.

**Members**

- `CairnRadiusScale get radiusScale` — The derived radius scale for this theme's [radius].
- `Color get ringMuted` — [ring] at the 50% alpha the focus ring is drawn with.
- `Color get overlay` — The scrim behind modal surfaces — black at 50%.
- `List<BoxShadow> get focusRing` — The focus ring as a box-shadow list. Tailwind implements `ring-[3px]` as `box-shadow: 0 0 0 3px <color>` — a hard, unblurred outset. The Flutter equivalent is a [BoxShadow] with zero offset, zero blur and a 3px spread, which is what this returns.
- `List<BoxShadow> get invalidRing` — The focus ring tinted for invalid controls. [destructive] at 20% alpha, raised to 40% in the dark theme where the lower-contrast surface needs the extra weight to register.
- `TextStyle textStyle(TextStyle base)` — Applies [fontFamily] and [fontFamilyFallback] to a token text style.
- `TextStyle get defaultTextStyle` — The default text style for this theme: `text-sm` in [foreground].

## Guide: Theming

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
