# Design tokens

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

## `CairnColors`

Cairn's semantic color tokens, as Flutter [Color] constants.

## How the palette is built

Cairn ships one neutral base palette in two themes. Every value is authored
in the CSS `oklch()` color function rather than as hex, because OKLCH is
perceptually uniform: the light and dark themes are two readings of the same
lightness ramp, so a pair that is legible in one is legible in the other by
construction rather than by eye. Each constant below records the literal
`oklch()` string it was authored as, and `test/tokens/colors_test.dart`
re-derives every constant through [Oklch.toColor] to prove the baked value
still matches that source.

The achromatic steps land exactly on Tailwind's published `neutral` ramp —
`oklch(0.145 0 0)` is `#0A0A0A` (neutral-950), `oklch(0.922 0 0)` is
`#E5E5E5` (neutral-200). That is both an independent check that the OKLab
pipeline is correct and a convenience: Cairn's greys sit flush against a
Tailwind-flavoured design without a seam.

## Roles, not shades

Tokens are named for the job they do — `primary`, `mutedForeground`,
`border` — never for how they look. A component asks for *the foreground
that belongs on a destructive surface*, not for white, which is what makes
overriding a single slot in [CairnTheme] re-theme every component that
reads it.

These raw constants are rarely used directly; consume them through
[CairnTheme], which exposes the same slots and supports overriding.

**Static members**

- `Color lightBackground = Color(0xFFFFFFFF)` — `background` = `oklch(1 0 0)` — `#FFFFFF`.
- `Color lightForeground = Color(0xFF0A0A0A)` — `foreground` = `oklch(0.145 0 0)` — `#0A0A0A` (neutral-950).
- `Color lightCard = Color(0xFFFFFFFF)` — `card` = `oklch(1 0 0)` — `#FFFFFF`.
- `Color lightCardForeground = Color(0xFF0A0A0A)` — `cardForeground` = `oklch(0.145 0 0)` — `#0A0A0A`.
- `Color lightPopover = Color(0xFFFFFFFF)` — `popover` = `oklch(1 0 0)` — `#FFFFFF`.
- `Color lightPopoverForeground = Color(0xFF0A0A0A)` — `popoverForeground` = `oklch(0.145 0 0)` — `#0A0A0A`.
- `Color lightPrimary = Color(0xFF171717)` — `primary` = `oklch(0.205 0 0)` — `#171717` (neutral-900).
- `Color lightPrimaryForeground = Color(0xFFFAFAFA)` — `primaryForeground` = `oklch(0.985 0 0)` — `#FAFAFA` (neutral-50).
- `Color lightSecondary = Color(0xFFF5F5F5)` — `secondary` = `oklch(0.97 0 0)` — `#F5F5F5` (neutral-100).
- `Color lightSecondaryForeground = Color(0xFF171717)` — `secondaryForeground` = `oklch(0.205 0 0)` — `#171717`.
- `Color lightMuted = Color(0xFFF5F5F5)` — `muted` = `oklch(0.97 0 0)` — `#F5F5F5`.
- `Color lightMutedForeground = Color(0xFF737373)` — `mutedForeground` = `oklch(0.556 0 0)` — `#737373` (neutral-500).
- `Color lightAccent = Color(0xFFF5F5F5)` — `accent` = `oklch(0.97 0 0)` — `#F5F5F5`.
- `Color lightAccentForeground = Color(0xFF171717)` — `accentForeground` = `oklch(0.205 0 0)` — `#171717`.
- `Color lightDestructive = Color(0xFFE7000B)` — `destructive` = `oklch(0.577 0.245 27.325)` — `#E7000B` (red-600).
- `Color lightDestructiveForeground = Color(0xFFFFFFFF)` — The foreground that sits on destructive surfaces. Kept as its own slot rather than hardcoding white into destructive Buttons and Badges: a theme that softens the destructive fill needs to move the text on it too, and a hardcoded colour would leave that unreachable. The default is white, which is what the default red needs.
- `Color lightBorder = Color(0xFFE5E5E5)` — `border` = `oklch(0.922 0 0)` — `#E5E5E5` (neutral-200).
- `Color lightInput = Color(0xFFE5E5E5)` — `input` = `oklch(0.922 0 0)` — `#E5E5E5`.
- `Color lightRing = Color(0xFFA1A1A1)` — `ring` = `oklch(0.708 0 0)` — `#A1A1A1` (neutral-400).
- `Color darkBackground = Color(0xFF0A0A0A)` — `background` = `oklch(0.145 0 0)` — `#0A0A0A`.
- `Color darkForeground = Color(0xFFFAFAFA)` — `foreground` = `oklch(0.985 0 0)` — `#FAFAFA`.
- `Color darkCard = Color(0xFF171717)` — `card` = `oklch(0.205 0 0)` — `#171717`. Dark cards sit *lighter* than the page, inverting the light theme's relationship where the card is white on a near-white page.
- `Color darkCardForeground = Color(0xFFFAFAFA)` — `cardForeground` = `oklch(0.985 0 0)` — `#FAFAFA`.
- `Color darkPopover = Color(0xFF171717)` — `popover` = `oklch(0.205 0 0)` — `#171717`.
- `Color darkPopoverForeground = Color(0xFFFAFAFA)` — `popoverForeground` = `oklch(0.985 0 0)` — `#FAFAFA`.
- `Color darkPrimary = Color(0xFFE5E5E5)` — `primary` = `oklch(0.922 0 0)` — `#E5E5E5` (neutral-200).
- `Color darkPrimaryForeground = Color(0xFF171717)` — `primaryForeground` = `oklch(0.205 0 0)` — `#171717`.
- `Color darkSecondary = Color(0xFF262626)` — `secondary` = `oklch(0.269 0 0)` — `#262626` (neutral-800).
- `Color darkSecondaryForeground = Color(0xFFFAFAFA)` — `secondaryForeground` = `oklch(0.985 0 0)` — `#FAFAFA`.
- `Color darkMuted = Color(0xFF262626)` — `muted` = `oklch(0.269 0 0)` — `#262626`.
- `Color darkMutedForeground = Color(0xFFA1A1A1)` — `mutedForeground` = `oklch(0.708 0 0)` — `#A1A1A1`.
- `Color darkAccent = Color(0xFF262626)` — `accent` = `oklch(0.269 0 0)` — `#262626`.
- `Color darkAccentForeground = Color(0xFFFAFAFA)` — `accentForeground` = `oklch(0.985 0 0)` — `#FAFAFA`.
- `Color darkDestructive = Color(0xFFFF6467)` — `destructive` = `oklch(0.704 0.191 22.216)` — `#FF6467` (red-400).
- `Color darkDestructiveForeground = Color(0xFFFFFFFF)` — White. The destructive fill stays saturated in the dark theme, so the foreground pairing does not change between themes.
- `Color darkBorder = Color(0x1AFFFFFF)` — `border` = `oklch(1 0 0 / 10%)` — white at 10% alpha. The dark theme switches borders from an opaque grey to a translucent white so they lift correctly over both the page and raised card surfaces.
- `Color darkInput = Color(0x26FFFFFF)` — `input` = `oklch(1 0 0 / 15%)` — white at 15% alpha.
- `Color darkRing = Color(0xFF737373)` — `ring` = `oklch(0.556 0 0)` — `#737373`.
- `Color chart1 = Color(0xFFD4D4D4)` — `chart1` = `oklch(0.87 0 0)` — `#D4D4D4`.
- `Color chart2 = Color(0xFF737373)` — `chart2` = `oklch(0.556 0 0)` — `#737373`.
- `Color chart3 = Color(0xFF525252)` — `chart3` = `oklch(0.439 0 0)` — `#525252`.
- `Color chart4 = Color(0xFF404040)` — `chart4` = `oklch(0.371 0 0)` — `#404040`.
- `Color chart5 = Color(0xFF262626)` — `chart5` = `oklch(0.269 0 0)` — `#262626`.
- `Color overlay = Color(0x80000000)` — The scrim behind Dialog, Alert Dialog, Sheet and Drawer. Black at 50%, and deliberately not a theme slot: a scrim's job is to darken whatever happens to be behind it, which is the same job in both themes.
- `Color white = Color(0xFFFFFFFF)` — Pure white, for text on destructive fills and for the Slider thumb, which stays white in both themes.

## `CairnMotion`

Cairn's transition durations and easing curves.

The default is `150ms` on a `cubic-bezier(0.4, 0, 0.2, 1)` curve — an
asymmetric ease that leaves quickly and arrives slowly, which is what makes
a hover or press state feel responsive rather than sluggish. Note that this
is *not* the CSS keyword `ease-in-out` (`cubic-bezier(0.42, 0, 0.58, 1)`),
which is symmetric and reads as noticeably lazier on short transitions.

Individual components override the duration where the distance travelled
justifies it: Dialog and Alert Dialog use 200ms, Accordion animates its
height over 200ms, and Sheet is deliberately asymmetric — 500ms to open,
300ms to close.

Flutter ships no built-in [Curve] with those control points, so [standard]
constructs one with [Cubic].

**Static members**

- `Duration d75 = Duration(milliseconds: 75)` — `duration-75`.
- `Duration d100 = Duration(milliseconds: 100)` — `duration-100`.
- `Duration d150 = Duration(milliseconds: 150)` — `duration-150` — Tailwind's `transition` default.
- `Duration d200 = Duration(milliseconds: 200)` — `duration-200` — Dialog, Alert Dialog, Accordion, Popover.
- `Duration d300 = Duration(milliseconds: 300)` — `duration-300` — Sheet and Drawer closing.
- `Duration d500 = Duration(milliseconds: 500)` — `duration-500` — Sheet and Drawer opening.
- `Duration d1000 = Duration(milliseconds: 1000)` — `duration-1000` — the Input OTP caret blink.
- `Cubic standard = Cubic(0.4, 0.0, 0.2, 1.0)` — Tailwind's default easing, `cubic-bezier(0.4, 0, 0.2, 1)`. Applied to colour, shadow and transform transitions across the library. Identical in value to Flutter's [Curves.fastOutSlowIn]'s intent but spelled out so the provenance is unambiguous.
- `Cubic easeOut = Cubic(0.0, 0.0, 0.2, 1.0)` — `ease-out` — `cubic-bezier(0, 0, 0.2, 1)`. Entrance transitions.
- `Cubic easeIn = Cubic(0.4, 0.0, 1.0, 1.0)` — `ease-in` — `cubic-bezier(0.4, 0, 1, 1)`. Exit transitions.
- `Curve linear = Curves.linear` — `linear` — used by the Spinner and the indeterminate Progress sweep.
- `Duration pulse = Duration(seconds: 2)` — The `animate-pulse` keyframe duration used by Skeleton (`2s`).
- `Duration spin = Duration(seconds: 1)` — The `animate-spin` rotation period used by Spinner (`1s`).

## `Oklch`

Converts colors expressed in the CSS `oklch()` color function into
Flutter [Color] values.

Cairn's palette is authored in OKLCH rather than HSL or raw hex. OKLCH is
perceptually uniform: an equal step in `L` reads as an equal step in
brightness at every hue, which is what keeps a light and a dark theme
derived from the same ramp visually balanced. Every semantic color token in
[CairnColors] is therefore written as an `oklch()` triple and converted
here.

Keeping the conversion in the package (rather than pasting pre-computed hex
values) means the provenance of every color is checkable: the doc comment on
each token records the literal `oklch()` string it was authored as, and
`test/tokens/oklch_test.dart` re-derives the baked constants from it.

The pipeline is the standard one from Björn Ottosson's OKLab specification:

```text
OKLCH -> OKLab -> LMS' -> LMS -> linear sRGB -> gamma-encoded sRGB
```

Out-of-gamut results are clipped per channel, which matches how browsers
render these particular tokens (all of Cairn's default tokens are in-gamut
for sRGB, so clipping is a safety net rather than a routine operation).

**Static members**

- `Color toColor(double l, double c, double h, {double opacity = 1.0})` — Converts an `oklch(L C H)` triple to a [Color]. [l] is perceptual lightness in the range 0..1, [c] is chroma (0 for the achromatic greys that make up most of Cairn's neutral base), and [h] is the hue angle in degrees. [opacity] maps to the `/ <alpha>` component of the CSS function and defaults to fully opaque. ```dart // --background: oklch(1 0 0)  ->  #FFFFFF Oklch.toColor(1, 0, 0); ```

## `CairnRadius`

Cairn's border-radius scale, expressed in Flutter logical pixels.

The entire scale derives from a single base value, [base], which defaults to
10 logical pixels. Every step is a fixed **multiple** of that base:

```text
xs  = 2 (fixed)
sm  = base * 0.6   ->  6
md  = base * 0.8   ->  8
lg  = base         -> 10
xl  = base * 1.4   -> 14
2xl = base * 1.8   -> 18
3xl = base * 2.2   -> 22
4xl = base * 2.6   -> 26
```

Multipliers rather than offsets is a deliberate choice. The obvious
alternative — fixed pixel offsets from the base (`base - 4`, `base - 2`,
`base + 4`) — produces identical numbers at the default base, but falls
apart the moment the base is retuned: a compact 4px theme would give a
*negative* small radius, and a generous 24px theme would compress the whole
scale into a narrow band. A proportional scale holds its shape at any base,
so changing `CairnTheme.radius` rescales every corner in the library
coherently instead of requiring a per-component audit. [CairnRadius.scaled]
is that computation.

**Static members**

- `double base = 10.0` — The base radius: 10 logical pixels.
- `double none = 0.0` — No rounding — 0px.
- `double xs = 2.0` — 2px. A fixed step rather than a multiple of [base]. Used by the close-button affordance in Dialog and Sheet, where the target is small enough that a proportional radius would read as a circle.
- `double sm = 6.0` — `base * 0.6` = 6px.
- `double md = 8.0` — `base * 0.8` = 8px. The most common radius in the library: Button, Input, Textarea, Select trigger, Popover and Dropdown content all use it.
- `double lg = 10.0` — `base` = 10px. Used by Dialog, Alert and Tabs list.
- `double xl = 14.0` — `base * 1.4` = 14px. Used by Card.
- `double xl2 = 18.0` — `base * 1.8` = 18px.
- `double xl3 = 22.0` — `base * 2.2` = 22px.
- `double xl4 = 26.0` — `base * 2.6` = 26px.
- `double full = 9999.0` — A very large radius that reads as a pill or circle. CSS uses `9999px`; Flutter clamps a [BorderRadius] to half the shorter side, so any sufficiently large number behaves identically.
- `BorderRadius brSm = BorderRadius.all(Radius.circular(sm))` — `BorderRadius.circular(CairnRadius.sm)`.
- `BorderRadius brMd = BorderRadius.all(Radius.circular(md))` — `BorderRadius.circular(CairnRadius.md)`.
- `BorderRadius brLg = BorderRadius.all(Radius.circular(lg))` — `BorderRadius.circular(CairnRadius.lg)`.
- `BorderRadius brXl = BorderRadius.all(Radius.circular(xl))` — `BorderRadius.circular(CairnRadius.xl)`.
- `BorderRadius brFull = BorderRadius.all(Radius.circular(full))` — `BorderRadius.circular(CairnRadius.full)`.
- `CairnRadiusScale scaled(double radius)` — Recomputes the whole scale for a custom base radius. ```dart // A tighter theme built on a 6px base. CairnRadius.scaled(6).md; // 4.8 ```

## `CairnRadiusScale`

A radius scale derived from a custom base radius.

Produced by [CairnRadius.scaled]. Applies the same multipliers as the
default scale, so a retuned theme keeps proportional radii across every
component.

**Constructor** `CairnRadiusScale(double base)`

Creates a scale from a base radius in logical pixels.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `base` | `double` | yes |  | The base radius, in logical pixels. |

**Members**

- `double get sm` — `base * 0.6`.
- `double get md` — `base * 0.8`.
- `double get lg` — `base`.
- `double get xl` — `base * 1.4`.
- `double get xl2` — `base * 1.8`.
- `double get xl3` — `base * 2.2`.
- `double get xl4` — `base * 2.6`.

## `CairnShadows`

Tailwind CSS's box-shadow scale, translated to Flutter [BoxShadow] lists.

## Why this is not a direct field-for-field copy

CSS and Flutter disagree about what "blur radius" means, so copying the
numbers out of `box-shadow` straight into [BoxShadow.blurRadius] produces a
visibly softer, larger shadow than the browser draws.

* **CSS** specifies that a shadow's blur is a Gaussian whose *standard
  deviation is half the blur-radius value*. So `0 1px 3px` means sigma 1.5.
* **Flutter** converts [BoxShadow.blurRadius] to a sigma with
  `sigma = radius * 0.57735 + 0.5` (`BoxShadow.blurSigma`, inherited from
  Skia's `convertRadiusToSigma`).

Setting `blurRadius: 3` in Flutter therefore yields sigma `2.23`, roughly
50% wider than the browser's `1.5`. [cssBlur] inverts Flutter's formula so
the rendered sigma matches the CSS one:

```text
blurRadius = (cssBlurPx / 2 - 0.5) / 0.57735
```

CSS's fourth `box-shadow` length — spread — maps cleanly onto
[BoxShadow.spreadRadius], including the negative spreads Tailwind uses to
keep large shadows tight against their element.

**Static members**

- `List<BoxShadow> none = <BoxShadow>[]` — `shadow-none`.
- `double cssBlur(double cssBlurPx)` — Converts a CSS blur-radius in px to the [BoxShadow.blurRadius] that makes Flutter render the same Gaussian sigma a browser would. Returns 0 for CSS blurs of 1px or less, where the inverted formula would go negative — such shadows are effectively hard edges in both engines.
- `List<BoxShadow> xs2` — `shadow-2xs` — `0 1px rgb(0 0 0 / 0.05)`.
- `List<BoxShadow> xs` — `shadow-xs` — `0 1px 2px 0 rgb(0 0 0 / 0.05)`. The default resting elevation for Input, Textarea, Select trigger, Checkbox, Switch and the outline Button variant.
- `List<BoxShadow> sm` — `shadow-sm` — `0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)`. Used by Card and the active Tabs trigger.
- `List<BoxShadow> md` — `shadow-md` — `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`. Used by Popover, Dropdown Menu, Select and Hover Card content.
- `List<BoxShadow> lg` — `shadow-lg` — `0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)`. Used by Dialog, Alert Dialog, Sheet and submenu content.
- `List<BoxShadow> xl` — `shadow-xl` — `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)`.
- `List<BoxShadow> xl2` — `shadow-2xl` — `0 25px 50px -12px rgb(0 0 0 / 0.25)`.

## `CairnSpacing`

Tailwind CSS's spacing scale, expressed in Flutter logical pixels.

Tailwind v4 defines a single spacing base — `--spacing: 0.25rem` — and every
numeric spacing utility is a multiple of it. With the browser default root
font size of 16px, `0.25rem` is 4px, so `p-4` is `4 * 4px = 16px`.

Flutter's logical pixel is the same unit as a CSS px at `devicePixelRatio`
1, so the conversion is 1:1 with no scaling factor.

```text
Tailwind class   rem      css px   CairnSpacing
gap-1            0.25rem  4px      CairnSpacing.s1
px-3             0.75rem  12px     CairnSpacing.s3
p-6              1.5rem   24px     CairnSpacing.s6
```

**Static members**

- `double base = 4.0` — The Tailwind spacing base, `--spacing: 0.25rem` = 4 logical pixels. Prefer the named steps below; use this directly only when translating a class Tailwind expresses as a raw multiple of `--spacing`.
- `double s0 = 0.0` — `0` — zero spacing.
- `double s0p5 = 2.0` — `0.5` — 0.125rem / 2px.
- `double s1 = 4.0` — `1` — 0.25rem / 4px.
- `double s1p5 = 6.0` — `1.5` — 0.375rem / 6px.
- `double s2 = 8.0` — `2` — 0.5rem / 8px.
- `double s2p5 = 10.0` — `2.5` — 0.625rem / 10px.
- `double s3 = 12.0` — `3` — 0.75rem / 12px.
- `double s3p5 = 14.0` — `3.5` — 0.875rem / 14px.
- `double s4 = 16.0` — `4` — 1rem / 16px.
- `double s5 = 20.0` — `5` — 1.25rem / 20px.
- `double s6 = 24.0` — `6` — 1.5rem / 24px.
- `double s7 = 28.0` — `7` — 1.75rem / 28px.
- `double s8 = 32.0` — `8` — 2rem / 32px.
- `double s9 = 36.0` — `9` — 2.25rem / 36px.
- `double s10 = 40.0` — `10` — 2.5rem / 40px.
- `double s11 = 44.0` — `11` — 2.75rem / 44px.
- `double s12 = 48.0` — `12` — 3rem / 48px.
- `double s16 = 64.0` — `16` — 4rem / 64px.
- `double s20 = 80.0` — `20` — 5rem / 80px.
- `double s24 = 96.0` — `24` — 6rem / 96px.
- `double step(double multiplier)` — Resolves an arbitrary Tailwind spacing step to logical pixels. `CairnSpacing.step(3.5)` is `14.0`, matching `p-3.5`.

## `CairnTone`

A semantic intent a component can be tinted with. Components that communicate *state* — a Status dot, a Steps indicator, a
Timeline marker — need a few more intents than that, so Cairn adds three
(`success`, `warning`, `info`) as an extension of the token layer rather
than as colours hardcoded into each component.

## `CairnToneColor`

A fill and the foreground that belongs on it.

**Constructor** `CairnToneColor(Color fill, Color onFill)`

Creates a fill/foreground pair.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `fill` | `Color` | yes |  | The solid colour for dots, markers and filled shapes. |
| `onFill` | `Color` | yes |  | The colour for text and icons placed on [fill]. |

## `CairnToneColors`

Resolves a [CairnTone] to concrete colours for a [CairnTheme].

Like every other Cairn colour, the additions are authored in OKLCH and
converted by the package, so their provenance is checkable. The light
values sit at Tailwind's 600 step (500 for warning, which needs the extra
lightness to read as amber rather than brown) and the dark values at the
400 step, mirroring how `destructive` is lifted in the dark theme.

**Static members**

- `CairnToneColor resolve(CairnTheme theme, CairnTone tone)` — The colours for [tone] under [theme].

## `CairnTypography`

Tailwind CSS's type scale, expressed as Flutter [TextStyle]s.

## Font size and line height

Tailwind's `text-*` utilities set a font size *and* a paired line height.
Both are authored in `rem`, which resolves against the 16px browser root
font size, so `text-sm` is `0.875rem / 1.25rem` = 14px text on a 20px line.

Flutter expresses line height as [TextStyle.height], a **multiple of the
font size**, not an absolute length. The conversion is therefore:

```text
height = cssLineHeightPx / cssFontSizePx
text-sm -> 20 / 14 = 1.4285714...
```

Baking the ratio rather than the pixel value is what keeps a component's
intrinsic height correct when a user scales text.

## Tight leading

A few places in the library — Card title, Dialog title, Label — want a line
height of exactly 1, so that a single-line heading occupies precisely its
own font size and sits optically centred against the controls beside it.
Flutter's default when [height] is null is *not* 1: it is the font's own
metric ascent+descent, typically ~1.2, which drops the glyphs low in their
box. [leadingNone] exists for exactly that case and has to be set
explicitly.

## Font family

Cairn never names a typeface. [CairnTypography] leaves
[TextStyle.fontFamily] null so the ambient font the host app configures
applies throughout, which is what lets Cairn drop into an existing app
without fighting its brand. The golden tests pin a bundled font instead, so
rendering stays deterministic in CI. See `README.md` for the golden-font
setup.

**Static members**

- `TextStyle xs = TextStyle(fontSize: 12.0, height: 16.0 / 12.0, fontWeight: normal)` — `text-xs` — 0.75rem / 1rem (12px on a 16px line). Badge, Kbd, Tooltip content, menu shortcuts and Select group labels.
- `TextStyle sm = TextStyle(fontSize: 14.0, height: 20.0 / 14.0, fontWeight: normal)` — `text-sm` — 0.875rem / 1.25rem (14px on a 20px line). The library's workhorse size: Button, Input, Label, menu items, Table.
- `TextStyle base = TextStyle(fontSize: 16.0, height: 24.0 / 16.0, fontWeight: normal)` — `text-base` — 1rem / 1.5rem (16px on a 24px line).
- `TextStyle lg = TextStyle(fontSize: 18.0, height: 28.0 / 18.0, fontWeight: normal)` — `text-lg` — 1.125rem / 1.75rem (18px on a 28px line). Dialog and Alert Dialog titles.
- `TextStyle xl = TextStyle(fontSize: 20.0, height: 28.0 / 20.0, fontWeight: normal)` — `text-xl` — 1.25rem / 1.75rem (20px on a 28px line).
- `TextStyle xl2 = TextStyle(fontSize: 24.0, height: 32.0 / 24.0, fontWeight: normal)` — `text-2xl` — 1.5rem / 2rem (24px on a 32px line).
- `TextStyle xl3 = TextStyle(fontSize: 30.0, height: 36.0 / 30.0, fontWeight: normal)` — `text-3xl` — 1.875rem / 2.25rem (30px on a 36px line).
- `TextStyle xl4 = TextStyle(fontSize: 36.0, height: 40.0 / 36.0, fontWeight: normal)` — `text-4xl` — 2.25rem / 2.5rem (36px on a 40px line).
- `FontWeight normal = FontWeight.w400` — `font-normal` — CSS weight 400.
- `FontWeight medium = FontWeight.w500` — `font-medium` — CSS weight 500. Button labels, Label, Alert titles, menu group labels.
- `FontWeight semibold = FontWeight.w600` — `font-semibold` — CSS weight 600. Card, Dialog and Sheet titles.
- `FontWeight bold = FontWeight.w700` — `font-bold` — CSS weight 700.
- `double leadingNone = 1.0` — `leading-none` — `line-height: 1`. Must be applied explicitly; Flutter's default line height comes from font metrics (~1.2), not 1.0.
- `double leadingRelaxed = 1.625` — `leading-relaxed` — `line-height: 1.625`.
- `double trackingTight(double fontSize)` — `tracking-tight` — `letter-spacing: -0.025em`. Returns an absolute value in logical pixels, because Flutter's [TextStyle.letterSpacing] is absolute where CSS's `em` is relative.
- `double trackingWidest(double fontSize)` — `tracking-widest` — `letter-spacing: 0.1em`. Used by menu shortcuts.
