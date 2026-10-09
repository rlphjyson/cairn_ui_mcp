# Introduction

Cairn is a modern, accessible component library for Flutter, built on one design-token layer: spacing, radii, OKLCH colour, a type scale, shadows and a focus-ring treatment, all specified once and held in place by golden tests.

### What this is

Sixty-five components, no runtime dependencies beyond Flutter itself, and a token layer where every value records the source string it was converted from. It is a widget package: no backend, no network layer, no platform channels, no native code.

The site you are reading is built with it. The navigation bar, the search trigger, the code block copy buttons, the preview/code tabs, the mobile navigation sheet and the command palette behind Ctrl+K are all Cairn widgets doing a real job, not demonstrations sitting in a grid. If a component regresses upstream, this site breaks.


### What "token-driven" means here

Plenty of libraries describe themselves as token-driven and still hardcode a 13 somewhere inside a widget. Cairn treats that as a bug, and the claim it makes is narrow enough to be checkable:

1. No component hardcodes a value that belongs in a token file. Padding, height, gap, radius, font size, shadow, ring width and transition all resolve to a named token.
2. Every conversion between CSS semantics and Flutter semantics is explicit and documented where the two disagree — of which there are more than you would expect.
3. Golden tests lock the rendered result down, so the implementation cannot drift once it is right.


### How the values are specified

The design system is written in CSS terms — the notation this kind of system is normally expressed in — and converted into Flutter once, in the token layer, rather than ad hoc at each call site.

| Written as | Becomes |
| --- | --- |
| Tailwind-style utility strings (h-9, px-4, gap-2, text-sm) | Per-component padding, height, gap, font size, shadow, ring and transition constants |
| oklch() custom properties, light and dark | The nineteen semantic colour slots plus the five-step chart ramp |
| A multiplier formula over a single --radius base | The rounded-* radius scale, rescalable from one number |
| Tailwind CSS v4's published scales | The 0.25rem spacing base, the type scale and the box-shadow values |

Each token file records the source string next to the converted value, so the provenance of any number is one click away in the source:

`lib/src/tokens/colors.dart`
```dart
/// `--primary: oklch(0.205 0 0)` — `#171717` (neutral-900).
static const Color lightPrimary = Color(0xFF171717);
```


### Four conversions that are easy to get wrong

CSS and Flutter agree on far less than they appear to. These are the four places where a literal reading of a value produces something visibly wrong, and they are the reason the conversions live in one documented layer rather than being repeated per component:

- Colour is defined in OKLCH, not HSL. OKLCH is perceptually uniform, so a lightness step means the same thing at every hue — which is what makes an achromatic ramp stay neutral. Anything that round-trips the palette through HSL loses that.
- The radius scale is multiplier-based, not offset-based. Every step is --radius × a factor (0.6, 0.8, 1.0, 1.4, 1.8), so setting one number rescales a whole app proportionally. Fixed ± 4px offsets agree at the default and diverge the moment --radius is customised.
- A CSS blur radius is not a Flutter blur radius. CSS treats it as twice the Gaussian sigma; Flutter feeds it through Skia's radius × 0.57735 + 0.5. Pasting the number across draws a shadow roughly 50% too wide.
- An opacity modifier scales alpha, it does not set it. A token that already carries 15% alpha, taken to /30, lands at 4.5% — not 30%. Six times too strong is very visible on a dark-mode form control.

> **A correctness check fell out of the conversion** Every achromatic step lands exactly on Tailwind's published neutral hex ramp — oklch(0.145 0 0) → #0A0A0A = neutral-950, oklch(0.922 0 0) → #E5E5E5 = neutral-200, and so on. test/tokens/tokens_test.dart asserts this, which means a bug in the OKLCH → sRGB pipeline could not pass CI unnoticed.


### What it deliberately does not do

Cairn does not ship a form-validation engine — Flutter has Form and FormField, and competing with them would fight the framework. It does not ship a theme-builder UI, and it does not ship icon assets: the handful of glyphs components need are drawn from Lucide's geometry with a CustomPainter, so the package stays pure Dart.