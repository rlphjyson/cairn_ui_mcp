# Design tokens

Seven token files, each recording where its numbers came from. No component hardcodes a value that should come from one of these.

### The files

| File | Contents |
| --- | --- |
| tokens/oklch.dart | oklch() → Color conversion, following Björn Ottosson's OKLab specification |
| tokens/colors.dart | All 19 semantic slots plus the 5-step chart ramp, light and dark, each annotated with its source oklch() string |
| tokens/spacing.dart | Tailwind's 0.25rem scale |
| tokens/radius.dart | The --radius scale and CairnRadiusScale for custom bases |
| tokens/typography.dart | Font sizes, line-height ratios, weights, tracking |
| tokens/shadows.dart | The shadow scale plus the CSS-blur conversion |
| tokens/motion.dart | Durations and Tailwind's easing curves |


### Spacing

Tailwind v4 defines a single base — --spacing: 0.25rem — and every numeric spacing utility is a multiple of it. At the browser default 16px root, that is 4px, and a Flutter logical pixel is the same unit as a CSS px at devicePixelRatio 1. The conversion is 1:1 with no scaling factor.

```dart
CairnSpacing.s1;   //  4 — gap-1
CairnSpacing.s3;   // 12 — px-3
CairnSpacing.s6;   // 24 — p-6
CairnSpacing.step(3.5); // 14 — p-3.5
```


### Typography

Tailwind pairs a font size with an absolute line height: text-sm is 0.875rem / 1.25rem. Flutter's TextStyle.height is a multiple of the font size, not a length, so the conversion is 20 / 14 = 1.4286. Baking the ratio rather than the pixel value is what keeps a component's intrinsic height correct when a user scales text.

> **leading-none is not Flutter's default** Card, Dialog and Label titles use line-height: 1. Flutter's default when height is null comes from the font's own metrics, typically around 1.2, so these have to set height: 1.0 explicitly or titles sit visibly low in their box.

```dart
CairnTypography.sm;       // 14px on a 20px line
CairnTypography.xl2;      // 24px on a 32px line
CairnTypography.semibold; // FontWeight.w600
CairnTypography.leadingNone;          // 1.0
CairnTypography.trackingTight(24);    // -0.6, because em is relative
```


### Shadows and the blur conversion

This is the conversion that is wrong if you copy the numbers across literally. CSS defines a shadow's blur as a Gaussian whose standard deviation is half the stated radius, so 0 1px 3px means sigma 1.5. Flutter converts BoxShadow.blurRadius to a sigma with radius × 0.57735 + 0.5, inherited from Skia's convertRadiusToSigma. Pasting CSS's 3 into blurRadius yields sigma 2.23 — roughly 50% wider than the browser draws.

```dart
// Inverts Flutter's formula so the rendered sigma matches CSS's.
static double cssBlur(double cssBlurPx) {
  final double targetSigma = cssBlurPx / 2.0;
  if (targetSigma <= 0.5) return 0.0;
  return (targetSigma - 0.5) / 0.57735;
}
```

> **Outer shadows are clipped in CSS and not in Flutter** CSS never paints an outer box-shadow through its element; Flutter paints a blurred filled copy of the shape behind the box with no clip. On Cairn's transparent-backed form controls that turns shadow-xs into a grey wash across the field — and turns focus-visible:ring-[3px], which compiles to box-shadow: 0 0 0 3px, into a solid fill over the entire control instead of a 3px outline. CairnShadowed paints shadows through a clip that removes the shape's interior.


### Motion

Tailwind's transition utilities default to 150ms with cubic-bezier(0.4, 0, 0.2, 1) — the curve Tailwind calls ease-in-out, which is not the CSS keyword ease-in-out (that is 0.42, 0, 0.58, 1). Flutter has no built-in Curve for it, so CairnMotion.standard constructs it with the exact control points.

```dart
CairnMotion.d150;     // Tailwind's transition default
CairnMotion.d200;     // Dialog, Accordion, Popover
CairnMotion.d500;     // Sheet and Drawer opening (closing is d300)
CairnMotion.standard; // Cubic(0.4, 0.0, 0.2, 1.0)
CairnMotion.easeOut;  // Cubic(0.0, 0.0, 0.2, 1.0)
```

The hover lift on this site's cards, the theme toggle's icon rotation and the preview/code crossfade all read their duration and curve from these constants rather than picking numbers.


### The chart ramp

colors.dart also carries --chart-1 through --chart-5. In the Neutral base these are achromatic — #D4D4D4 through #262626 — which is why the Charts page on this site is monochrome by default rather than reaching for a palette Cairn does not define.