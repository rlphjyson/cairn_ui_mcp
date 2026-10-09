# Display components: API

Exact public API for each component, generated from cairn_ui 0.2.0. Import: `import 'package:cairn_ui/cairn_ui.dart';`

# Card

A surface with header, content and footer slots.

- Category: Display
- Widgets: `CairnCard`, `CairnCardHeader`, `CairnCardContent`, `CairnCardFooter`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> rounded-xl (14px) with py-6 on the card and px-6 on each slot, so a full-bleed child can still span edge to edge.

## Quick start

```dart
CairnCard(
  width: 360,
  children: <Widget>[
    const CairnCardHeader(
      title: Text('Deploy your project'),
      description: Text('Ship to production in one click.'),
    ),
    const CairnCardContent(child: Text('Ready to go live.')),
    CairnCardFooter(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CairnButton(onPressed: _deploy, child: const Text('Deploy')),
      ],
    ),
  ],
)
```

## API

### `CairnCard` (widget)

A content container with header, content and footer slots.

`flex flex-col gap-6 rounded-xl border bg-card py-6 text-card-foreground
shadow-sm` — a `rounded-xl` (14 logical pixel) radius, 24px of vertical
padding on the card itself, and a 24px gap between its slots.

The horizontal padding lives on the *children* (`px-6` on header, content
and footer), not the card, which is what lets a full-bleed element such as
an image or a [CairnSeparator] span edge to edge. Cairn preserves that
structure rather than collapsing it into one padded box.

```dart
CairnCard(
  children: [
    const CairnCardHeader(
      title: Text('Deploy'),
      description: Text('Push to production.'),
    ),
    const CairnCardContent(child: Text('Body')),
    CairnCardFooter(
      children: [CairnButton(onPressed: () {}, child: const Text('Go'))],
    ),
  ],
);
```

**Constructor** `CairnCard({required List<Widget> children, double gap = CairnSpacing.s6, double? width})`

Creates a card.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The card's slots, typically [CairnCardHeader], [CairnCardContent] and [CairnCardFooter]. |
| `gap` | `double` |  | `CairnSpacing.s6` | The gap between slots (`gap-6`). |
| `width` | `double?` |  |  | An optional fixed width. |

### `CairnCardHeader` (widget)

The title and description slot of a [CairnCard].

`grid auto-rows-min items-start gap-2 px-6`, with an optional [action]
pinned to the trailing edge (`col-start-2 row-span-2 justify-self-end`).

**Constructor** `CairnCardHeader({Widget? title, Widget? description, Widget? action})`

Creates a card header.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The card title — `leading-none font-semibold`. |
| `description` | `Widget?` |  |  | The supporting description — `text-sm text-muted-foreground`. |
| `action` | `Widget?` |  |  | An optional trailing action, such as a menu button. |

### `CairnCardContent` (widget)

The main body slot of a [CairnCard] — `px-6`.

**Constructor** `CairnCardContent({required Widget child})`

Creates a card content slot.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The body. |

### `CairnCardFooter` (widget)

The footer slot of a [CairnCard] — `flex items-center px-6`.

**Constructor** `CairnCardFooter({required List<Widget> children, double spacing = CairnSpacing.s2, MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start})`

Creates a card footer.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The footer's children, typically buttons. |
| `spacing` | `double` |  | `CairnSpacing.s2` | The gap between children. |
| `mainAxisAlignment` | `MainAxisAlignment` |  | `MainAxisAlignment.start` | How to align the children horizontally. |


---

# Badge

A small status pill in five variants.

- Category: Display
- Widgets: `CairnBadge`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Filled variants carry a transparent 1px border so their outer size is identical to the outline variant.

## Quick start

```dart
const CairnBadge(
  variant: CairnBadgeVariant.secondary,
  leading: CairnIcon(CairnIconData.check, size: 12),
  label: Text('Verified'),
)
```

## API

### `CairnBadge` (widget)

A small status pill.

`inline-flex w-fit items-center gap-1 rounded-full border border-transparent
px-2 py-0.5 text-xs font-medium` — a fully rounded pill with 8px horizontal
and 2px vertical padding and 12px medium text.

The transparent 1px border on filled variants is deliberate: it keeps the
outer dimensions identical between the filled and [CairnBadgeVariant.outline]
variants, so badges of different variants line up in a row.

```dart
const CairnBadge(label: Text('Beta'));
const CairnBadge(
  variant: CairnBadgeVariant.destructive,
  label: Text('Failed'),
);
```

**Constructor** `CairnBadge({required Widget label, CairnBadgeVariant variant = CairnBadgeVariant.primary, Widget? leading, Widget? trailing})`

Creates a badge.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `Widget` | yes |  | The badge's content. |
| `variant` | `CairnBadgeVariant` |  | `CairnBadgeVariant.primary` | The visual style. |
| `leading` | `Widget?` |  |  | An icon before the label. Forced to `size-3` (12px). |
| `trailing` | `Widget?` |  |  | An icon after the label. Forced to `size-3` (12px). |

### `CairnBadgeVariant` (enum)

The visual style of a [CairnBadge].

- `CairnBadgeVariant.primary` — `bg-primary text-primary-foreground`.
- `CairnBadgeVariant.secondary` — `bg-secondary text-secondary-foreground`.
- `CairnBadgeVariant.destructive` — `bg-destructive text-white`.
- `CairnBadgeVariant.outline` — `border-border text-foreground` with no fill.
- `CairnBadgeVariant.ghost` — No fill and no border.


---

# Avatar

A user image with a persistent fallback, plus a stack group.

- Category: Display
- Widgets: `CairnAvatar`, `CairnAvatarGroup`, `CairnAvatarGroup`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The fallback survives an image error rather than leaving a hole, which is the case naive implementations miss.

## Quick start

```dart
const CairnAvatar(fallback: Text('CA'), size: CairnAvatarSize.lg)

const CairnAvatarGroup(
  children: <Widget>[
    CairnAvatar(fallback: Text('A')),
    CairnAvatar(fallback: Text('B')),
    CairnAvatar(fallback: Text('+7')),
  ],
)
```

## API

### `CairnAvatar` (widget)

A user avatar with an image and a text fallback.

`relative flex size-8 shrink-0 overflow-hidden rounded-full select-none`,
with a `bg-muted text-sm text-muted-foreground` fallback.

[fallback] stays visible until the image has actually loaded, and the swap
happens only on success — so a broken URL leaves the initials in place
rather than collapsing to a broken-image box, and a slow one never flashes
an empty circle. That is why the image runs through [Image.errorBuilder] and
[Image.frameBuilder] instead of simply being stacked over the fallback.

```dart
CairnAvatar(
  image: const NetworkImage('https://example.com/me.jpg'),
  fallback: const Text('RJ'),
);
```

**Constructor** `CairnAvatar({ImageProvider<Object>? image, Widget? fallback, CairnAvatarSize size = CairnAvatarSize.md, String? semanticLabel})`

Creates an avatar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `image` | `ImageProvider<Object>?` |  |  | The avatar image. Falls back to [fallback] while loading or on error. |
| `fallback` | `Widget?` |  |  | Shown when [image] is null, still loading, or failed. |
| `size` | `CairnAvatarSize` |  | `CairnAvatarSize.md` | The size. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnAvatarGroup` (widget)

A row of overlapping avatars.

`flex -space-x-2 *:ring-2 *:ring-background` — each avatar overlaps the
previous by 8 logical pixels and carries a 2px ring in the page background
colour, which is what separates them visually.

CSS achieves the overlap with a negative margin. Flutter's [Padding] asserts
non-negative insets, so this lays the avatars out in a [Stack] with computed
offsets instead and sizes the box explicitly — which also lets the first
avatar paint on top, matching the CSS stacking order.

```dart
const CairnAvatarGroup(
  size: CairnAvatarSize.md,
  children: [
    CairnAvatar(fallback: Text('RJ')),
    CairnAvatar(fallback: Text('AB')),
    CairnAvatar(fallback: Text('+3')),
  ],
);
```

**Constructor** `CairnAvatarGroup({required List<Widget> children, CairnAvatarSize size = CairnAvatarSize.md, double overlap = 8.0, double ringWidth = 2.0})`

Creates an avatar group.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The avatars, drawn left to right with the first on top. |
| `size` | `CairnAvatarSize` |  | `CairnAvatarSize.md` | The size of every avatar in the group. |
| `overlap` | `double` |  | `8.0` | How far each avatar overlaps the previous (`-space-x-2`). |
| `ringWidth` | `double` |  | `2.0` | The separating ring width (`ring-2`). |

### `CairnAvatarSize` (enum)

The size of a [CairnAvatar].

- `CairnAvatarSize.sm` — `size-6` — 24 logical pixels, with `text-xs` fallback text.
- `CairnAvatarSize.md` — `size-8` — 32 logical pixels.
- `CairnAvatarSize.lg` — `size-10` — 40 logical pixels.


---

# Alert

An inline banner, default or destructive.

- Category: Display
- Widgets: `CairnAlert`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The icon is nudged down 2px (translate-y-0.5) so it aligns to the title cap height rather than its line box.

## Quick start

```dart
const CairnAlert(
  variant: CairnAlertVariant.destructive,
  icon: CairnIcon(CairnIconData.alert),
  title: Text('Payment failed'),
  description: Text('Update your billing details to continue.'),
)
```

## API

### `CairnAlert` (widget)

A callout for a short, prominent message.

`relative grid w-full items-start rounded-lg border px-4 py-3 text-sm`.

The layout is a CSS grid whose first column collapses to zero width when
there is no icon (`grid-cols-[0_1fr]`) and becomes 16px wide with a 12px
gap when there is (`has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr]
has-[>svg]:gap-x-3`). The icon is also nudged down 2px
(`[&>svg]:translate-y-0.5`) so it optically aligns with the title's cap
height rather than its line box. Both details are reproduced here.

```dart
const CairnAlert(
  icon: CairnIcon(CairnIconData.alert),
  title: Text('Heads up!'),
  description: Text('Your trial ends in three days.'),
);
```

**Constructor** `CairnAlert({Widget? title, Widget? description, Widget? icon, CairnAlertVariant variant = CairnAlertVariant.normal})`

Creates an alert.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The alert heading — `font-medium tracking-tight`. |
| `description` | `Widget?` |  |  | The supporting body — `text-sm text-muted-foreground`. |
| `icon` | `Widget?` |  |  | An optional leading icon, forced to `size-4` (16px). |
| `variant` | `CairnAlertVariant` |  | `CairnAlertVariant.normal` | The visual style. |

### `CairnAlertVariant` (enum)

The visual style of a [CairnAlert].

- `CairnAlertVariant.normal` — `bg-card text-card-foreground`.
- `CairnAlertVariant.destructive` — `bg-card text-destructive`, with the description at `text-destructive/90`.


---

# Separator

A hairline rule, horizontal or vertical.

- Category: Display
- Widgets: `CairnSeparator`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Decorative by default, so screen readers skip it; pass decorative: false when the rule carries meaning.

## Quick start

```dart
const CairnSeparator()

const CairnSeparator(axis: Axis.vertical, decorative: false)
```

## API

### `CairnSeparator` (widget)

A one-pixel rule.

`shrink-0 bg-border`, `h-px w-full` when horizontal and `h-full w-px` when
vertical.

The thickness is a literal CSS `1px`, which is one *logical* pixel in
Flutter — so on a 3x device it rasterises to three physical pixels, exactly
as a browser would on the same display.

[decorative] decides whether the rule is announced. Most separators are
pure visual rhythm and should be hidden from assistive technology; one that
genuinely divides two sections of content is a semantic boundary and is
announced as such.

```dart
const CairnSeparator();
const CairnSeparator(axis: Axis.vertical);
```

**Constructor** `CairnSeparator({Axis axis = Axis.horizontal, bool decorative = true, double thickness = 1.0, Color? color})`

Creates a separator.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `axis` | `Axis` |  | `Axis.horizontal` | The orientation. Horizontal fills width; vertical fills height. |
| `decorative` | `bool` |  | `true` | Whether to hide this from assistive technology. |
| `thickness` | `double` |  | `1.0` | The rule thickness in logical pixels (`h-px` / `w-px`). |
| `color` | `Color?` |  |  | Overrides the `--border` token. |


---

# Skeleton

A pulsing placeholder for loading content.

- Category: Display
- Widgets: `CairnSkeleton`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Uses Tailwind's animate-pulse curve and honours MediaQuery.disableAnimations.

## Quick start

```dart
const Row(
  children: <Widget>[
    CairnSkeleton.circle(size: 44),
    SizedBox(width: 16),
    CairnSkeleton(width: 220, height: 12),
  ],
)
```

## API

### `CairnSkeleton` (widget)

A loading placeholder.

`animate-pulse rounded-md bg-accent`.

Tailwind's `animate-pulse` keyframes run `opacity: 1 -> .5 -> 1` over two
seconds with `cubic-bezier(0.4, 0, 0.6, 1)`. This reproduces that curve
rather than using a shimmer, because a shimmer is a different effect that
would not match.

Respects [MediaQueryData.disableAnimations], so users who have asked their
platform to reduce motion get a static placeholder.

```dart
const CairnSkeleton(width: 200, height: 16);
const CairnSkeleton.circle(size: 40);
```

**Constructor** `CairnSkeleton({double? width, double? height, BorderRadius? borderRadius})`

Creates a rectangular skeleton.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `width` | `double?` |  |  | The width. Null fills the available width. |
| `height` | `double?` |  |  | The height. |
| `borderRadius` | `BorderRadius?` |  |  | Overrides `rounded-md`. |

**Constructor** `CairnSkeleton.circle({required double size})`

Creates a circular skeleton, for avatar placeholders.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `size` | `double` | yes |  |  |


---

# Spinner

An indeterminate activity indicator.

- Category: Display
- Widgets: `CairnSpinner`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> animate-spin at 1s, linear. Respects reduced motion.

## Quick start

```dart
const CairnSpinner(size: 24, strokeWidth: 2)
```

## API

### `CairnSpinner` (widget)

A loading spinner.

`size-4 animate-spin` — a 16 logical pixel arc rotating once per second at
a linear rate, matching Tailwind's `animate-spin` keyframes exactly (a
constant-speed 360-degree rotation, not an eased one).

```dart
const CairnSpinner();
CairnButton(
  onPressed: null,
  leading: const CairnSpinner(),
  child: const Text('Saving'),
);
```

**Constructor** `CairnSpinner({double size = 16.0, Color? color, double strokeWidth = 2.0, String semanticLabel = 'Loading'})`

Creates a spinner.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `size` | `double` |  | `16.0` | The diameter (`size-4`). |
| `color` | `Color?` |  |  | The arc colour. Defaults to the ambient text colour. |
| `strokeWidth` | `double` |  | `2.0` | The arc thickness. |
| `semanticLabel` | `String` |  | `'Loading'` | The accessible name. |


---

# Kbd

Keyboard key hints, single or grouped.

- Category: Display
- Widgets: `CairnKbd`, `CairnKbdGroup`, `CairnKbdGroup`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> font-sans, not monospace — a detail that is easy to get wrong from memory because every other design system uses a mono face here.

## Quick start

```dart
const CairnKbd('Esc')

const CairnKbdGroup(keys: <String>['Ctrl', 'K'])
```

## API

### `CairnKbd` (widget)

A keyboard shortcut chip.

`pointer-events-none inline-flex h-5 w-fit min-w-5 items-center justify-center
gap-1 rounded-sm bg-muted px-1 font-sans text-xs font-medium
text-muted-foreground select-none` — a 20 logical pixel tall chip with a
`min-w-5` so a single character still renders square.

Note the face is the ambient sans, deliberately **not** a monospace one.
A key chip is a label, not code, and monospace digits next to sans-serif
body text read as a mistake at this size.

```dart
const CairnKbdGroup(keys: ['Ctrl', 'K']);
```

**Constructor** `CairnKbd(String label)`

Creates a single key chip.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The key's text, such as `Ctrl` or `K`. |

### `CairnKbdGroup` (widget)

A run of [CairnKbd] chips — `inline-flex items-center gap-1`.

**Constructor** `CairnKbdGroup({required List<String> keys})`

Creates a group of key chips.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `keys` | `List<String>` | yes |  | The keys, in press order. |


---

# Aspect Ratio

Constrains a child to a fixed ratio.

- Category: Display
- Widgets: `CairnAspectRatio`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> A thin wrapper over Flutter's own AspectRatio, with clipping.

## Quick start

```dart
CairnAspectRatio(
  ratio: 16 / 9,
  child: Image.network(url, fit: BoxFit.cover),
)
```

## API

### `CairnAspectRatio` (widget)

Constrains a child to a fixed aspect ratio.

Flutter's own [AspectRatio] already does this correctly, so this is a thin,
documented wrapper rather than a reimplementation — there is nothing here to
improve on. It exists so the Cairn surface stays complete: a
ratio-constrained box inside a Card is reached for by the same name as
everything around it.

```dart
CairnAspectRatio(
  ratio: 16 / 9,
  child: Image.network('https://example.com/cover.jpg', fit: BoxFit.cover),
);
```

**Constructor** `CairnAspectRatio({required double ratio, required Widget child, bool clip = true})`

Creates an aspect-ratio box.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `ratio` | `double` | yes |  | Width divided by height, e.g. `16 / 9`. |
| `child` | `Widget` | yes |  | The constrained child. |
| `clip` | `bool` |  | `true` | Whether to clip the child to the box (`overflow-hidden`). |


---

# Empty

The zero-state panel, with a dashed border.

- Category: Display
- Widgets: `CairnEmpty`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The dashed border is hand-painted — Flutter's Border has no dash support, so a CustomPainter walks the rounded rect.

## Quick start

```dart
CairnEmpty(
  media: const CairnIcon(CairnIconData.search, size: 32),
  title: 'No results',
  description: 'Try adjusting your filters.',
  actions: <Widget>[
    CairnButton(
      variant: CairnButtonVariant.outline,
      onPressed: _clear,
      child: const Text('Clear filters'),
    ),
  ],
)
```

## API

### `CairnEmpty` (widget)

An empty-state placeholder.

`flex flex-col items-center justify-center gap-6 rounded-lg border-dashed
p-6 text-center md:p-12` with a `size-16 rounded-md bg-muted` media slot, a
`text-lg font-medium tracking-tight` title and a
`text-sm/relaxed text-muted-foreground` description.

Note the border is **dashed**, which Flutter's [Border] cannot draw — see
the custom painter below.

```dart
CairnEmpty(
  media: const CairnIcon(CairnIconData.search, size: 32),
  title: 'No results',
  description: 'Try adjusting your filters.',
  actions: [CairnButton(onPressed: () {}, child: const Text('Reset'))],
);
```

**Constructor** `CairnEmpty({String? title, String? description, Widget? media, List<Widget> actions = const <Widget>[], bool bordered = true})`

Creates an empty state.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `String?` |  |  | The heading. |
| `description` | `String?` |  |  | The supporting text. |
| `media` | `Widget?` |  |  | An icon or illustration, shown in a `size-16 bg-muted` tile. |
| `actions` | `List<Widget>` |  | `const <Widget>[]` | Actions below the text. |
| `bordered` | `bool` |  | `true` | Whether to draw the dashed border. |


---

# Table

A typed, column-driven table with an optional caption.

- Category: Display
- Widgets: `CairnTable`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Cells are p-2 and the header row is h-10 — considerably tighter than a Material DataTable.

## Quick start

```dart
CairnTable<Invoice>(
  caption: const Text('A list of recent invoices.'),
  rows: invoices,
  columns: <CairnColumn<Invoice>>[
    CairnColumn<Invoice>(label: 'Invoice', cell: (Invoice i) => Text(i.id)),
    CairnColumn<Invoice>(
      label: 'Amount',
      alignment: Alignment.centerRight,
      cell: (Invoice i) => Text(i.amount),
    ),
  ],
)
```

## API

### `CairnColumn`

One column in a [CairnTable].

**Constructor** `CairnColumn({required String label, required Widget Function(T row) cell, double? width, int flex = 1, Alignment alignment = Alignment.centerLeft, Comparable<Object> Function(T row)? sortKey})`

Creates a column.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The header label. |
| `cell` | `Widget Function(T row)` | yes |  | Builds a cell for one row. |
| `width` | `double?` |  |  | A fixed width. Null uses [flex] instead. |
| `flex` | `int` |  | `1` | The flex factor when [width] is null. |
| `alignment` | `Alignment` |  | `Alignment.centerLeft` | How the cell's content is aligned. |
| `sortKey` | `Comparable<Object> Function(T row)?` |  |  | An optional comparator key, enabling sorting on this column in a [CairnDataTable]. |

### `CairnTable` (widget)

A data table.

Header cells are `h-10 px-2 text-left align-middle font-medium
whitespace-nowrap text-foreground`; body cells are `p-2 align-middle`.
Rows carry `border-b transition-colors hover:bg-muted/50`, and the selected
state is `data-[state=selected]:bg-muted`.

Note the 8px cell padding — considerably tighter than a Material `DataTable`
— and the 40px header row height.

```dart
CairnTable<Invoice>(
  rows: invoices,
  columns: [
    CairnColumn(label: 'Invoice', cell: (r) => Text(r.id)),
    CairnColumn(label: 'Amount', cell: (r) => Text(r.amount)),
  ],
);
```

**Constructor** `CairnTable({required List<CairnColumn<T>> columns, required List<T> rows, Set<int> selected = const <int>{}, void Function(int index, T row)? onRowTap, Widget? caption, bool showHeader = true})`

Creates a table.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `columns` | `List<CairnColumn<T>>` | yes |  | The columns. |
| `rows` | `List<T>` | yes |  | The row data. |
| `selected` | `Set<int>` |  | `const <int>{}` | Indices of selected rows (`data-[state=selected]:bg-muted`). |
| `onRowTap` | `void Function(int index, T row)?` |  |  | Called when a row is tapped. |
| `caption` | `Widget?` |  |  | An optional caption below the table (`mt-4 text-sm text-muted-foreground`). |
| `showHeader` | `bool` |  | `true` | Whether to render the header row. |

**Static members**

- `double headerHeight = 40.0` — `h-10` — the header row height.
- `double cellPadding = CairnSpacing.s2` — `p-2` — cell padding.


---

# Stat

A figure with its label and context, grouped by Stats.

- Category: Display
- Widgets: `CairnStat`, `CairnStats`, `CairnStats`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> CairnStats joins its children with 1px dividers inside one bordered card.

## Quick start

```dart
const CairnStats(
  children: <Widget>[
    CairnStat(
      title: Text('Active users'),
      value: Text('4,200'),
      description: Text('+180 this week'),
    ),
    CairnStat(title: Text('Error rate'), value: Text('0.4%')),
  ],
)
```

## API

### `CairnStat` (widget)

A single headline figure with its label and context.

A [title] in muted small text, a [value] in 30px semibold with tight
tracking, and a [description] in muted extra-small text — the same type
roles a Card uses, stacked at a 4px rhythm. An optional [figure] (an icon or
avatar) sits at the trailing edge, and [actions] below the description.

Put several in a [CairnStats] to get the divided row.

```dart
const CairnStat(
  title: Text('Total revenue'),
  value: Text('\$31,200'),
  description: Text('+12% from last month'),
);
```

**Constructor** `CairnStat({required Widget title, required Widget value, Widget? description, Widget? figure, Widget? actions})`

Creates a stat.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget` | yes |  | The label above the figure. |
| `value` | `Widget` | yes |  | The headline figure. |
| `description` | `Widget?` |  |  | A line of context beneath the figure. |
| `figure` | `Widget?` |  |  | A trailing icon or avatar. |
| `actions` | `Widget?` |  |  | Controls shown under the description. |

### `CairnStats` (widget)

A bordered, divided row (or column) of [CairnStat]s.

`rounded-xl border` with a 1px [CairnTheme.border] hairline between
children, so it reads as one object — the same container treatment as a
Card, minus the shadow.

**Constructor** `CairnStats({required List<Widget> children, Axis direction = Axis.horizontal})`

Creates a stat group.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The stats. |
| `direction` | `Axis` |  | `Axis.horizontal` | Whether stats sit side by side or stacked. |


---

# Status

A small tone dot, optionally pulsing.

- Category: Display
- Widgets: `CairnStatus`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Tones are the CairnTone token: success, warning and info join primary and destructive.

## Quick start

```dart
const CairnStatus(
  tone: CairnTone.success,
  ping: true,
  semanticLabel: 'Online',
)
```

## API

### `CairnStatus` (widget)

A small dot communicating state — online, away, failing.

An 8 logical pixel circle in a [CairnTone] colour with a 1px halo of the
same colour at 30% alpha so it stays legible against any surface. Set
[ping] to pulse a ring outwards, for state that is live right now.

```dart
const CairnStatus(tone: CairnTone.success, semanticLabel: 'Online');
```

**Constructor** `CairnStatus({CairnTone tone = CairnTone.neutral, double size = 8.0, bool ping = false, String? semanticLabel})`

Creates a status dot.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `tone` | `CairnTone` |  | `CairnTone.neutral` | The colour intent. |
| `size` | `double` |  | `8.0` | The dot diameter. |
| `ping` | `bool` |  | `false` | Whether to pulse a ring outwards from the dot. |
| `semanticLabel` | `String?` |  |  | The accessible name. A dot is meaningless to a screen reader without one. |


---

# Timeline

Events on a marker rail with a connecting hairline.

- Category: Display
- Widgets: `CairnTimeline`, `CairnTimelineItem`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
const CairnTimeline(
  items: <CairnTimelineItem>[
    CairnTimelineItem(
      tone: CairnTone.success,
      title: Text('Deployed to production'),
      time: Text('2m ago'),
    ),
  ],
)
```

## API

### `CairnTimelineItem`

One event on a [CairnTimeline].

**Constructor** `CairnTimelineItem({required Widget title, Widget? description, Widget? time, Widget? icon, CairnTone tone = CairnTone.neutral})`

Creates a timeline event.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget` | yes |  | What happened. |
| `description` | `Widget?` |  |  | Detail beneath the title. |
| `time` | `Widget?` |  |  | When it happened — rendered in muted text beside the title. |
| `icon` | `Widget?` |  |  | A glyph inside the marker. Without one the marker is a plain dot. |
| `tone` | `CairnTone` |  | `CairnTone.neutral` | The marker colour. |

### `CairnTimeline` (widget)

A vertical sequence of events joined by a line.

Each event has a marker on a shared left rail with a 1px [CairnTheme.border]
line running through to the next. A marker with an [CairnTimelineItem.icon]
is a 24px filled circle; without one it is an 8px dot centred on the same
rail, so mixed timelines stay aligned.

```dart
const CairnTimeline(items: [
  CairnTimelineItem(
    tone: CairnTone.success,
    title: Text('Deployed'),
    time: Text('2m ago'),
  ),
]);
```

**Constructor** `CairnTimeline({required List<CairnTimelineItem> items})`

Creates a timeline.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnTimelineItem>` | yes |  | The events, top to bottom. |


---

# Chat Bubble

A message bubble that aligns itself by sender.

- Category: Display
- Widgets: `CairnChatBubble`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Capped at 75% of its parent's width.

## Quick start

```dart
const CairnChatBubble(
  side: CairnChatSide.sent,
  footer: Text('Delivered'),
  child: Text('Shipped.'),
)
```

## API

### `CairnChatBubble` (widget)

A message bubble.

`rounded-xl px-3 py-2 text-sm` capped at 75% of the available width. The
corner nearest the sender is squared off to a small radius so the bubble
reads as speaking from that side. [CairnChatSide.sent] uses the `primary`
slot and [CairnChatSide.received] the `secondary` slot, so a chat re-themes
with everything else.

Compose a conversation by stacking bubbles in a [Column]; the bubble aligns
itself within its parent.

```dart
const CairnChatBubble(
  side: CairnChatSide.sent,
  author: Text('You'),
  footer: Text('Delivered'),
  child: Text('Shipped!'),
);
```

**Constructor** `CairnChatBubble({required Widget child, CairnChatSide side = CairnChatSide.received, Widget? avatar, Widget? author, Widget? footer})`

Creates a chat bubble.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The message content. |
| `side` | `CairnChatSide` |  | `CairnChatSide.received` | Which side the bubble speaks from. |
| `avatar` | `Widget?` |  |  | A leading (received) or trailing (sent) avatar, usually a [CairnAvatar]. |
| `author` | `Widget?` |  |  | A small name line above the bubble. |
| `footer` | `Widget?` |  |  | A small line below the bubble — a timestamp or delivery state. |

### `CairnChatSide` (enum)

Which side of the conversation a [CairnChatBubble] belongs to.

- `CairnChatSide.received` — The other party — left-aligned, on a `secondary` fill.
- `CairnChatSide.sent` — The current user — right-aligned, on a `primary` fill.


---

# Indicator

A badge or dot pinned to a corner of its child.

- Category: Display
- Widgets: `CairnIndicator`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The indicator is positioned over the child and does not affect layout.

## Quick start

```dart
const CairnIndicator(
  indicator: CairnBadge(label: Text('3')),
  child: CairnAvatar(fallback: Text('RB')),
)
```

## API

### `CairnIndicator` (widget)

Pins a small badge to a corner of [child] — an unread count on an icon, a
status dot on an avatar.

The [indicator] is centred on the corner of the child's box, so it straddles
the edge rather than sitting inside it. It does not take part in layout: the
indicator can overflow the child without changing the child's size, which is
what you want when the child is already positioned in a row.

Use a [CairnBadge] or [CairnStatus] as the indicator — both are sized for
this.

```dart
CairnIndicator(
  indicator: const CairnBadge(label: Text('3')),
  child: const CairnAvatar(fallback: Text('RB')),
);
```

**Constructor** `CairnIndicator({required Widget child, required Widget indicator, CairnIndicatorPlacement placement = CairnIndicatorPlacement.topEnd, Offset offset = Offset.zero})`

Creates an indicator.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The widget being annotated. |
| `indicator` | `Widget` | yes |  | The badge. |
| `placement` | `CairnIndicatorPlacement` |  | `CairnIndicatorPlacement.topEnd` | Which corner. |
| `offset` | `Offset` |  | `Offset.zero` | A nudge applied after placement, for example to tuck a dot inside the edge of a circular avatar. |

### `CairnIndicatorPlacement` (enum)

Where a [CairnIndicator]'s badge sits on its child.

- `CairnIndicatorPlacement.topStart` — Top-left corner.
- `CairnIndicatorPlacement.topEnd` — Top-right corner.
- `CairnIndicatorPlacement.bottomStart` — Bottom-left corner.
- `CairnIndicatorPlacement.bottomEnd` — Bottom-right corner.


---

# Stack

Overlapping layers, or an avatar pile.

- Category: Display
- Widgets: `CairnStack`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnStack(
  offset: 8,
  children: <Widget>[
    CairnCard(children: <Widget>[CairnCardHeader(title: Text('Top'))]),
    CairnCard(children: <Widget>[CairnCardHeader(title: Text('Behind'))]),
  ],
)
```

## API

### `CairnStack` (widget)

Overlaps its children like a pile of cards.

The first child is on top. Each following child is shifted by [offset] and
shrunk slightly, with a hairline [CairnTheme.border] edge so the layers stay
distinguishable on a matching surface. Pass the same-sized children — the
stack takes the size of the first (top) one.

Also the right tool for an avatar pile: set [offset] to a small negative
horizontal value and let [reverse] put the first avatar on top.

```dart
CairnStack(
  offset: const Offset(0, 8),
  children: [CairnCard(...), CairnCard(...), CairnCard(...)],
);
```

**Constructor** `CairnStack({required List<Widget> children, Offset offset = const Offset(0, 8), double scaleStep = 0.05})`

Creates a stack.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The layers, top first. |
| `offset` | `Offset` |  | `const Offset(0, 8)` | How far each layer moves from the one above it. |
| `scaleStep` | `double` |  | `0.05` | How much each layer shrinks, as a fraction of its size. |


---

# Hero

A landing-page header with eyebrow, actions and a 36rem measure.

- Category: Display
- Widgets: `CairnHero`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnHero(
  eyebrow: const CairnBadge(label: Text('New')),
  title: const Text('Build interfaces that hold together'),
  description: const Text('Tokens first, widgets second.'),
  actions: <Widget>[
    CairnButton(onPressed: _start, child: const Text('Get started')),
  ],
)
```

## API

### `CairnHero` (widget)

A landing-page header block: headline, supporting copy and actions.

A centred column — [title] in 36px semibold with tight tracking (`text-4xl
font-semibold tracking-tight`), [description] in 18px muted text capped at
36rem for a comfortable measure, and [actions] in a wrapping row beneath. An
[eyebrow] (a [CairnBadge], typically) sits above the headline.

By default the hero is transparent so it inherits the page surface. Pass
[muted] for a `muted` filled band, or [background] for any other widget
(an image, a gradient) painted behind the content.

```dart
CairnHero(
  eyebrow: CairnBadge(label: Text('New')),
  title: Text('Build faster'),
  description: Text('Everything you need to ship.'),
  actions: [CairnButton(onPressed: () {}, child: Text('Get started'))],
);
```

**Constructor** `CairnHero({required Widget title, Widget? description, Widget? eyebrow, List<Widget> actions = const <Widget>[], CrossAxisAlignment alignment = CrossAxisAlignment.center, bool muted = false, Widget? background, EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: CairnSpacing.s6, vertical: CairnSpacing.s20)})`

Creates a hero.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget` | yes |  | The headline. |
| `description` | `Widget?` |  |  | Supporting copy. |
| `eyebrow` | `Widget?` |  |  | A small element above the headline. |
| `actions` | `List<Widget>` |  | `const <Widget>[]` | Calls to action. |
| `alignment` | `CrossAxisAlignment` |  | `CrossAxisAlignment.center` | Horizontal alignment of the content. |
| `muted` | `bool` |  | `false` | Whether to fill the band with the `muted` token. |
| `background` | `Widget?` |  |  | A widget painted behind the content. |
| `padding` | `EdgeInsetsGeometry` |  | `const EdgeInsets.symmetric(horizontal: CairnSpacing.s6, vertical: CairnSpacing.s20)` | Space around the content. |


---

# Diff

A draggable before-and-after comparison.

- Category: Display
- Widgets: `CairnDiff`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Drag the grip, or focus it and use the arrow keys, Home and End.

## Quick start

```dart
CairnDiff(
  aspectRatio: 16 / 9,
  before: Image.asset('before.png', fit: BoxFit.cover),
  after: Image.asset('after.png', fit: BoxFit.cover),
)
```

## API

### `CairnDiff` (widget)

A before/after comparison with a draggable divider.

Two widgets are stacked at the same size; [after] is clipped to the right of
a divider that the user drags (or moves with the arrow keys) to reveal more
of [before] or [after]. Useful for image edits, design reviews and theme
comparisons.

The divider is a 1px [CairnTheme.border]-strength line carrying a 32px round
grip with chevrons, and has a 44px-wide hit area so it stays easy to catch
on touch. The comparison fills the width it is given; give it an
[aspectRatio] (or wrap it in a sized box) to fix the height.

```dart
CairnDiff(
  aspectRatio: 16 / 9,
  before: Image.asset('before.png', fit: BoxFit.cover),
  after: Image.asset('after.png', fit: BoxFit.cover),
);
```

**Constructor** `CairnDiff({required Widget before, required Widget after, double initialPosition = 0.5, double? aspectRatio, ValueChanged<double>? onChanged, String semanticLabel = 'Comparison divider'})`

Creates a diff.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `before` | `Widget` | yes |  | Shown on the left of the divider. |
| `after` | `Widget` | yes |  | Shown on the right of the divider. |
| `initialPosition` | `double` |  | `0.5` | The divider's starting position as a fraction of the width. |
| `aspectRatio` | `double?` |  |  | Fixes the height as width / ratio. Null lets the parent decide. |
| `onChanged` | `ValueChanged<double>?` |  |  | Called as the divider moves. |
| `semanticLabel` | `String` |  | `'Comparison divider'` | The accessible name of the divider. |


---

# List

Rows with leading, trailing and selected states.

- Category: Display
- Widgets: `CairnList`, `CairnListItem`, `CairnListItem`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnList(
  bordered: true,
  children: <Widget>[
    CairnListItem(
      leading: const CairnAvatar(fallback: Text('RB')),
      title: const Text('Ralph'),
      subtitle: const Text('Owner'),
      onTap: _open,
    ),
  ],
)
```

## API

### `CairnList` (widget)

A vertical list of rows — contacts, files, settings, a playlist.

Rows are separated by a 1px [CairnTheme.border] hairline (no hairline after
the last), and the list itself is unbordered so it can sit inside a Card or
directly on the page. Set [bordered] to wrap it in the Card-style container.

Use [CairnListItem] for the usual leading / title / subtitle / trailing
shape, or put any widget in [children].

```dart
CairnList(children: [
  CairnListItem(
    leading: CairnAvatar(fallback: Text('RB')),
    title: Text('Ralph'),
    subtitle: Text('Owner'),
    trailing: CairnBadge(label: Text('Admin')),
    onTap: () {},
  ),
]);
```

**Constructor** `CairnList({required List<Widget> children, bool bordered = false})`

Creates a list.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The rows. |
| `bordered` | `bool` |  | `false` | Whether to wrap the list in a `rounded-xl border` container. |

### `CairnListItem` (widget)

A row in a [CairnList].

`px-4 py-3`, a 12px gap between slots, and a [title] in 14px medium over a
[subtitle] in 12px muted. When [onTap] is set the row hovers to the `accent`
fill and takes focus like any other Cairn control; without it the row is
static.

**Constructor** `CairnListItem({required Widget title, Widget? subtitle, Widget? leading, Widget? trailing, VoidCallback? onTap, bool selected = false})`

Creates a list row.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget` | yes |  | The primary line. |
| `subtitle` | `Widget?` |  |  | The secondary line. |
| `leading` | `Widget?` |  |  | A leading avatar or icon. |
| `trailing` | `Widget?` |  |  | A trailing badge, button or value. |
| `onTap` | `VoidCallback?` |  |  | Makes the row tappable. |
| `selected` | `bool` |  | `false` | Whether to fill the row with `accent`, for a current selection. |


---

# Mockup

Window, browser, code and phone frames for showcasing content.

- Category: Display
- Widgets: `CairnMockupWindow`, `CairnMockupBrowser`, `CairnMockupCode`, `CairnMockupPhone`, `CairnMockupWindow`, `CairnMockupBrowser`, `CairnMockupCode`, `CairnMockupPhone`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
const CairnMockupBrowser(
  url: 'https://cairn.dev',
  child: SizedBox(height: 96),
)

const CairnMockupCode(
  lines: <String>['flutter pub add cairn_ui'],
  highlight: <int>{0},
)
```

## API

### `CairnMockupWindow` (widget)

A window frame with three title-bar dots — the base for the other mockups.

`rounded-xl border` with a 40px title bar on a `muted` fill, three 10px
dots (drawn in neutral grey rather than the macOS red/amber/green, so the
frame sits in the theme instead of fighting it) and an optional [title]
centred in the bar. [child] fills the body on the `card` surface.

```dart
const CairnMockupWindow(
  title: Text('Untitled'),
  child: Padding(padding: EdgeInsets.all(16), child: Text('Hello')),
);
```

**Constructor** `CairnMockupWindow({required Widget child, Widget? title})`

Creates a window mockup.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The window body. |
| `title` | `Widget?` |  |  | Text in the title bar. |

### `CairnMockupBrowser` (widget)

A browser frame: window dots plus a pill-shaped address bar.

[url] is shown in the address bar in muted small text. [child] is the
"page" beneath it.

```dart
const CairnMockupBrowser(
  url: 'https://cairn.dev',
  child: SizedBox(height: 160),
);
```

**Constructor** `CairnMockupBrowser({required Widget child, String? url})`

Creates a browser mockup.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The page content. |
| `url` | `String?` |  |  | The address shown in the bar. |

### `CairnMockupCode` (widget)

A terminal-style code block.

Each of [lines] is drawn on its own row with a muted [prefix] gutter
(`$` by default) in the theme's foreground on a `muted` fill, in a
fixed-pitch face. Lines in [highlight] take the `accent` fill and full
foreground colour — for pointing at the line that matters.

This is a mockup, not a syntax highlighter; it displays text as given.

```dart
const CairnMockupCode(lines: ['flutter pub add cairn_ui', 'flutter run']);
```

**Constructor** `CairnMockupCode({required List<String> lines, String prefix = r'$', Set<int> highlight = const <int>{}})`

Creates a code mockup.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `lines` | `List<String>` | yes |  | The code, one entry per line. |
| `prefix` | `String` |  | `r'$'` | The gutter marker, repeated on every line. |
| `highlight` | `Set<int>` |  | `const <int>{}` | Zero-based indexes of lines to emphasise. |

### `CairnMockupPhone` (widget)

A phone frame: a thick rounded bezel with a notch.

A 280px-wide device (override with [width]) at a 9:19.5 aspect ratio with a
10px bezel in the `foreground` colour, a 36px-radius outer corner, and a
small pill notch. [child] fills the screen, clipped to its inner radius.

```dart
const CairnMockupPhone(child: Center(child: Text('Hello')));
```

**Constructor** `CairnMockupPhone({required Widget child, double width = 280.0})`

Creates a phone mockup.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The screen content. |
| `width` | `double` |  | `280.0` | The device width. |


---

