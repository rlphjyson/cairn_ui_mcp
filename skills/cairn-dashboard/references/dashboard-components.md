# Components used by dashboards

Exact API for the components dashboards are built from.

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

## Variants and examples

### Header · content · footer

```dart
CairnCard(
  width: 360,
  children: <Widget>[
    const CairnCardHeader(
      title: Text('Deploy your project'),
      description: Text('Ship to production in one click.'),
    ),
    const CairnCardContent(
      child: Text(
        'Your changes have been reviewed and are ready to go live.',
      ),
    ),
    CairnCardFooter(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CairnButton(
          variant: CairnButtonVariant.outline,
          onPressed: () {},
          child: const Text('Cancel'),
        ),
        CairnButton(onPressed: () {}, child: const Text('Deploy')),
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

## Variants and examples

### Stats group

```dart
const CairnStats(
  children: <Widget>[
    CairnStat(
      title: Text('Total revenue'),
      value: Text(r'$31,200'),
      description: Text('+12% from last month'),
    ),
    CairnStat(
      title: Text('Active users'),
      value: Text('4,200'),
      description: Text('+180 this week'),
    ),
    CairnStat(
      title: Text('Error rate'),
      value: Text('0.4%'),
      description: Text('Within budget'),
    ),
  ],
)
```

### Single stat

```dart
const CairnStat(
  title: Text('Active users'),
  value: Text('4,200'),
  description: Text('+180 this week'),
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

## Variants and examples

### Primary

```dart
const CairnBadge(label: Text('Default'))
```

### Secondary

```dart
const CairnBadge(
  variant: CairnBadgeVariant.secondary,
  label: Text('Secondary'),
)
```

### Destructive

```dart
const CairnBadge(
  variant: CairnBadgeVariant.destructive,
  label: Text('Destructive'),
)
```

### Outline

```dart
const CairnBadge(
  variant: CairnBadgeVariant.outline,
  label: Text('Outline'),
)
```

### Ghost

```dart
const CairnBadge(
  variant: CairnBadgeVariant.ghost,
  label: Text('Ghost'),
)
```

### With icon

```dart
const CairnBadge(
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

## Variants and examples

### Neutral

```dart
const CairnStatus(tone: CairnTone.neutral)
```

### Success · ping

```dart
const CairnStatus(tone: CairnTone.success, ping: true)
```

### Warning

```dart
const CairnStatus(tone: CairnTone.warning)
```

### Info

```dart
const CairnStatus(tone: CairnTone.info)
```

### Destructive

```dart
const CairnStatus(tone: CairnTone.destructive)
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

## Variants and examples

### Badge

```dart
const CairnIndicator(
  indicator: CairnBadge(label: Text('3')),
  child: CairnAvatar(fallback: Text('RB')),
)
```

### Status dot

```dart
const CairnIndicator(
  placement: CairnIndicatorPlacement.bottomEnd,
  offset: Offset(-4, -4),
  indicator: CairnStatus(tone: CairnTone.success, size: 10),
  child: CairnAvatar(fallback: Text('AL')),
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

# Data Table

Sorting, filtering and pagination on top of Table.

- Category: Data & feedback
- Widgets: `CairnDataTable`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Sorting copies the list instead of mutating the caller's, so the rows you passed in are never reordered behind your back.

## Quick start

```dart
CairnDataTable<Payment>(
  rows: payments,
  pageSize: 10,
  searchBy: (Payment p) => p.email,
  searchPlaceholder: 'Filter emails...',
  columns: <CairnColumn<Payment>>[
    CairnColumn<Payment>(
      label: 'Email',
      flex: 3,
      cell: (Payment p) => Text(p.email),
      sortKey: (Payment p) => p.email,
    ),
  ],
)
```

## Variants and examples

### Payments

```dart
class Payment {
  const Payment(this.email, this.status, this.amount);
  final String email;
  final String status;
  final double amount;
}

CairnDataTable<Payment>(
  rows: payments,
  pageSize: 4,
  searchBy: (Payment p) => p.email,
  searchPlaceholder: 'Filter emails...',
  columns: <CairnColumn<Payment>>[
    CairnColumn<Payment>(
      label: 'Email',
      flex: 3,
      cell: (Payment p) => Text(p.email),
      sortKey: (Payment p) => p.email,
    ),
    CairnColumn<Payment>(
      label: 'Status',
      flex: 2,
      cell: (Payment p) => CairnBadge(
        variant: switch (p.status) {
          'Success' => CairnBadgeVariant.primary,
          'Failed' => CairnBadgeVariant.destructive,
          _ => CairnBadgeVariant.secondary,
        },
        label: Text(p.status),
      ),
      sortKey: (Payment p) => p.status,
    ),
    CairnColumn<Payment>(
      label: 'Amount',
      flex: 2,
      alignment: Alignment.centerRight,
      cell: (Payment p) => Text('\$${p.amount.toStringAsFixed(2)}'),
      sortKey: (Payment p) => p.amount,
    ),
  ],
)
```

## API

### `CairnDataTable` (widget)

A sortable, filterable, paginated table built on [CairnTable].

This is behaviour layered onto [CairnTable], not a second rendering path:
sorting, filtering and pagination are added *above* the primitive rather
than reimplemented alongside it, so a plain table and a data table can never
drift apart visually.

Sorting is opt-in per column, enabled by giving a [CairnColumn] a `sortKey`.
Sortable headers become interactive and show a directional arrow.

```dart
CairnDataTable<Payment>(
  rows: payments,
  columns: [
    CairnColumn(
      label: 'Email',
      cell: (p) => Text(p.email),
      sortKey: (p) => p.email,
    ),
    CairnColumn(
      label: 'Amount',
      cell: (p) => Text(p.amount.toStringAsFixed(2)),
      sortKey: (p) => p.amount,
    ),
  ],
  searchBy: (p) => p.email,
);
```

**Constructor** `CairnDataTable({required List<CairnColumn<T>> columns, required List<T> rows, String Function(T row)? searchBy, String searchPlaceholder = 'Filter...', int? pageSize, void Function(int index, T row)? onRowTap, String emptyMessage = 'No results.'})`

Creates a data table.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `columns` | `List<CairnColumn<T>>` | yes |  | The columns. Any with a `sortKey` becomes sortable. |
| `rows` | `List<T>` | yes |  | The full row set, before filtering, sorting and pagination. |
| `searchBy` | `String Function(T row)?` |  |  | Extracts the text a row is matched against by the filter field. Null hides the filter field entirely. |
| `searchPlaceholder` | `String` |  | `'Filter...'` | The filter field's placeholder. |
| `pageSize` | `int?` |  |  | Rows per page. Null disables pagination. |
| `onRowTap` | `void Function(int index, T row)?` |  |  | Called when a row is tapped. |
| `emptyMessage` | `String` |  | `'No results.'` | Shown when no rows survive filtering. |

### `CairnSortDirection` (enum)

The sort direction of a [CairnDataTable] column.

- `CairnSortDirection.ascending` — Smallest first.
- `CairnSortDirection.descending` — Largest first.


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

## Variants and examples

### Invoices

```dart
class Invoice {
  const Invoice(this.id, this.status, this.amount);
  final String id;
  final String status;
  final String amount;
}

CairnTable<Invoice>(
  caption: const Text('A list of recent invoices.'),
  rows: const <Invoice>[
    Invoice('INV001', 'Paid', r'$250.00'),
    Invoice('INV002', 'Pending', r'$150.00'),
    Invoice('INV003', 'Unpaid', r'$350.00'),
  ],
  columns: <CairnColumn<Invoice>>[
    CairnColumn<Invoice>(
      label: 'Invoice',
      cell: (Invoice i) => Text(i.id),
    ),
    CairnColumn<Invoice>(
      label: 'Status',
      cell: (Invoice i) => CairnBadge(
        variant: i.status == 'Paid'
            ? CairnBadgeVariant.primary
            : CairnBadgeVariant.secondary,
        label: Text(i.status),
      ),
    ),
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

# Toggle Group

Joined or spaced toggles, single- or multi-select.

- Category: Forms
- Widgets: `CairnToggleGroup`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnToggleGroup<String>(
  values: _alignment,
  type: CairnToggleGroupType.single,
  variant: CairnToggleVariant.outline,
  onChanged: (Set<String> v) => setState(() => _alignment = v),
  items: const <CairnToggleGroupItem<String>>[
    CairnToggleGroupItem<String>(value: 'left', child: Text('Left')),
    CairnToggleGroupItem<String>(value: 'center', child: Text('Center')),
  ],
)
```

## Variants and examples

### Single · outline

```dart
Set<String> _alignment = <String>{'center'};

CairnToggleGroup<String>(
  values: _alignment,
  variant: CairnToggleVariant.outline,
  onChanged: (Set<String> v) => setState(() => _alignment = v),
  items: const <CairnToggleGroupItem<String>>[
    CairnToggleGroupItem<String>(value: 'left', child: Text('Left')),
    CairnToggleGroupItem<String>(value: 'center', child: Text('Center')),
    CairnToggleGroupItem<String>(value: 'right', child: Text('Right')),
  ],
)
```

### Multiple

```dart
Set<String> _marks = <String>{'bold'};

CairnToggleGroup<String>(
  values: _marks,
  type: CairnToggleGroupType.multiple,
  onChanged: (Set<String> v) => setState(() => _marks = v),
  items: const <CairnToggleGroupItem<String>>[
    CairnToggleGroupItem<String>(value: 'bold', child: Text('B')),
    CairnToggleGroupItem<String>(value: 'italic', child: Text('I')),
    CairnToggleGroupItem<String>(value: 'underline', child: Text('U')),
  ],
)
```

## API

### `CairnToggleGroup` (widget)

A set of related toggles, joined or spaced.

`flex w-fit items-center rounded-md`, with the joined (`data-[spacing=0]`)
presentation squaring off inner corners so the group reads as one control:
`first:rounded-l-md last:rounded-r-md` plus `border-l-0` on all but the
first item, which prevents the doubled 2px seam you would otherwise get
where two 1px borders meet.

```dart
CairnToggleGroup<String>(
  type: CairnToggleGroupType.single,
  values: {alignment},
  onChanged: (v) => setState(() => alignment = v.firstOrNull ?? 'left'),
  items: const [
    CairnToggleGroupItem(value: 'left', child: Text('Left')),
    CairnToggleGroupItem(value: 'center', child: Text('Center')),
  ],
);
```

**Constructor** `CairnToggleGroup({required Set<T> values, required List<CairnToggleGroupItem<T>> items, ValueChanged<Set<T>>? onChanged, CairnToggleGroupType type = CairnToggleGroupType.single, CairnToggleVariant variant = CairnToggleVariant.normal, CairnToggleSize size = CairnToggleSize.md, bool joined = true, double spacing = 0.0, String? semanticLabel})`

Creates a toggle group.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `values` | `Set<T>` | yes |  | The currently selected values. |
| `items` | `List<CairnToggleGroupItem<T>>` | yes |  | The items in this group. |
| `onChanged` | `ValueChanged<Set<T>>?` |  |  | Called with the next selection set. |
| `type` | `CairnToggleGroupType` |  | `CairnToggleGroupType.single` | Whether one or many items may be selected. |
| `variant` | `CairnToggleVariant` |  | `CairnToggleVariant.normal` | The visual style applied to every item. |
| `size` | `CairnToggleSize` |  | `CairnToggleSize.md` | The size applied to every item. |
| `joined` | `bool` |  | `true` | Whether items are visually joined into one control. |
| `spacing` | `double` |  | `0.0` | The gap between items when not [joined]. |
| `semanticLabel` | `String?` |  |  | The accessible name for the group. |

### `CairnToggleGroupItem`

One option inside a [CairnToggleGroup].

**Constructor** `CairnToggleGroupItem({required T value, required Widget child, bool enabled = true, String? semanticLabel})`

Creates a toggle group item.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `T` | yes |  | The value this item represents. |
| `child` | `Widget` | yes |  | The item's content. |
| `enabled` | `bool` |  | `true` | Whether this item is selectable. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnToggleGroupType` (enum)

Whether a [CairnToggleGroup] allows one or many selections.

- `CairnToggleGroupType.single` — At most one item may be selected, like a radio group.
- `CairnToggleGroupType.multiple` — Any number of items may be selected.


---

# Select

A trigger whose menu matches its width.

- Category: Overlays
- Widgets: `CairnSelect`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The menu is never narrower than the trigger: the trigger is measured and the menu constrained to at least that width.

## Quick start

```dart
CairnSelect<String>(
  value: _framework,
  width: 260,
  placeholder: 'Select a framework',
  options: const <CairnSelectOption<String>>[
    CairnSelectOption<String>(value: 'flutter', label: 'Flutter'),
    CairnSelectOption<String>(value: 'react', label: 'React'),
  ],
  onChanged: (String v) => setState(() => _framework = v),
)
```

## Variants and examples

### Default

```dart
String? _framework;

CairnSelect<String>(
  value: _framework,
  width: 260,
  placeholder: 'Select a framework',
  options: const <CairnSelectOption<String>>[
    CairnSelectOption<String>(value: 'flutter', label: 'Flutter'),
    CairnSelectOption<String>(value: 'react', label: 'React'),
    CairnSelectOption<String>(value: 'svelte', label: 'Svelte'),
    CairnSelectOption<String>(value: 'vue', label: 'Vue'),
    CairnSelectOption<String>(
      value: 'ember',
      label: 'Ember (unavailable)',
      enabled: false,
    ),
  ],
  onChanged: (String v) => setState(() => _framework = v),
)
```

### Small

```dart
String? _framework;

CairnSelect<String>(
  value: _framework,
  size: CairnSelectSize.sm,
  width: 220,
  placeholder: 'Select a framework',
  options: frameworks,
  onChanged: (String v) => setState(() => _framework = v),
)
```

## API

### `CairnSelectOption`

One option in a [CairnSelect].

**Constructor** `CairnSelectOption({required T value, required String label, Widget? leading, bool enabled = true})`

Creates a select option.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `T` | yes |  | The value this option carries. |
| `label` | `String` | yes |  | The text shown in the trigger and the menu. |
| `leading` | `Widget?` |  |  | An optional leading icon. |
| `enabled` | `bool` |  | `true` | Whether the option can be chosen. |

### `CairnSelect` (widget)

A dropdown value picker.

The trigger is `flex w-fit items-center justify-between gap-2 rounded-md
border border-input bg-transparent px-3 py-2 text-sm shadow-xs` at `h-9`,
with a `size-4 opacity-50` chevron.

The menu is `min-w-[8rem] rounded-md border bg-popover p-1 shadow-md`, and
is always at least as wide as its trigger — a menu narrower than the control
that opened it reads as a misplaced tooltip. That is [CairnPopoverLayout]'s
`matchAnchorWidth`.

The placeholder renders in the muted foreground so an unset field is
distinguishable from a chosen value at a glance, and the selected row
carries a trailing check at `size-3.5`.

```dart
CairnSelect<String>(
  value: framework,
  placeholder: 'Select a framework',
  options: const [
    CairnSelectOption(value: 'flutter', label: 'Flutter'),
    CairnSelectOption(value: 'react', label: 'React'),
  ],
  onChanged: (v) => setState(() => framework = v),
);
```

**Constructor** `CairnSelect({required List<CairnSelectOption<T>> options, T? value, ValueChanged<T>? onChanged, String placeholder = 'Select...', CairnSelectSize size = CairnSelectSize.md, double? width, double maxMenuHeight = 320.0, bool hasError = false, FocusNode? focusNode, String? semanticLabel})`

Creates a select.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `options` | `List<CairnSelectOption<T>>` | yes |  | The available options. |
| `value` | `T?` |  |  | The currently selected value. |
| `onChanged` | `ValueChanged<T>?` |  |  | Called when the user picks an option. Null disables the select. |
| `placeholder` | `String` |  | `'Select...'` | Text shown when nothing is selected. |
| `size` | `CairnSelectSize` |  | `CairnSelectSize.md` | The trigger height. |
| `width` | `double?` |  |  | An optional fixed trigger width. Null sizes to content (`w-fit`). |
| `maxMenuHeight` | `double` |  | `320.0` | How tall the menu may grow before scrolling. |
| `hasError` | `bool` |  | `false` | Marks the control invalid. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnSelectSize` (enum)

The size of a [CairnSelect] trigger.

- `CairnSelectSize.sm` — `data-[size=sm]:h-8`.
- `CairnSelectSize.md` — `data-[size=default]:h-9`.


---

# Tabs

Filled and line variants with roving focus.

- Category: Navigation
- Widgets: `CairnTabs`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The filled track is p-[3px] — an arbitrary value, not a step on the spacing scale. The line variant underlines 5px below the trigger.

## Quick start

```dart
CairnTabs<String>(
  value: _tab,
  variant: CairnTabsVariant.line,
  onChanged: (String v) => setState(() => _tab = v),
  tabs: const <CairnTab<String>>[
    CairnTab<String>(value: 'overview', label: Text('Overview')),
    CairnTab<String>(value: 'analytics', label: Text('Analytics')),
  ],
)
```

## Variants and examples

### Filled

```dart
String _tab = 'account';

CairnTabs<String>(
  value: _tab,
  onChanged: (String v) => setState(() => _tab = v),
  tabs: const <CairnTab<String>>[
    CairnTab<String>(value: 'account', label: Text('Account')),
    CairnTab<String>(value: 'password', label: Text('Password')),
    CairnTab<String>(value: 'team', label: Text('Team')),
  ],
)
```

### Line

```dart
String _tab = 'overview';

CairnTabs<String>(
  value: _tab,
  variant: CairnTabsVariant.line,
  onChanged: (String v) => setState(() => _tab = v),
  tabs: const <CairnTab<String>>[
    CairnTab<String>(value: 'overview', label: Text('Overview')),
    CairnTab<String>(value: 'analytics', label: Text('Analytics')),
    CairnTab<String>(value: 'reports', label: Text('Reports')),
  ],
)
```

## API

### `CairnTab`

One tab in a [CairnTabs].

**Constructor** `CairnTab({required T value, required Widget label, Widget? icon, bool enabled = true})`

Creates a tab.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `T` | yes |  | The value this tab selects. |
| `label` | `Widget` | yes |  | The tab's label. |
| `icon` | `Widget?` |  |  | An optional leading icon, forced to `size-4`. |
| `enabled` | `bool` |  | `true` | Whether the tab can be selected. |

### `CairnTabs` (widget)

A tab bar, in a filled or an underlined variant.

The filled variant's track is `h-9 rounded-lg bg-muted p-[3px]` — note the
**3px** padding, an arbitrary value rather than a spacing step, which is
what makes the active tab sit flush inside the track. Each trigger is
`h-[calc(100%-1px)] rounded-md px-2 py-1 text-sm font-medium`, and the
inactive label colour is `text-foreground/60` in light mode but
`text-muted-foreground` in dark.

The line variant drops the track and instead draws a 2px underline
(`after:h-0.5`) 5 pixels below the trigger (`after:bottom-[-5px]`).

## Accessibility

Arrow keys move between tabs and the bar holds a single tab stop, which is
the WAI-ARIA tabs pattern: Tab reaches the tab bar, then the panel, rather
than stepping through every tab on the way past.

```dart
CairnTabs<String>(
  value: tab,
  onChanged: (v) => setState(() => tab = v),
  tabs: const [
    CairnTab(value: 'account', label: Text('Account')),
    CairnTab(value: 'password', label: Text('Password')),
  ],
);
```

**Constructor** `CairnTabs({required T value, required List<CairnTab<T>> tabs, ValueChanged<T>? onChanged, CairnTabsVariant variant = CairnTabsVariant.filled, bool expand = false})`

Creates a tab bar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `T` | yes |  | The selected tab's value. |
| `tabs` | `List<CairnTab<T>>` | yes |  | The tabs. |
| `onChanged` | `ValueChanged<T>?` |  |  | Called when a tab is chosen. |
| `variant` | `CairnTabsVariant` |  | `CairnTabsVariant.filled` | The visual style. |
| `expand` | `bool` |  | `false` | Whether tabs share the available width equally. |

### `CairnTabsVariant` (enum)

The visual style of a [CairnTabs] bar.

- `CairnTabsVariant.filled` — `bg-muted` — a filled pill track with a raised active tab.
- `CairnTabsVariant.line` — `gap-1 bg-transparent` — no track; the active tab gets a 2px underline.


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

## Variants and examples

### Default

```dart
const CairnAlert(
  icon: CairnIcon(CairnIconData.info),
  title: Text('Heads up'),
  description: Text('Your trial ends in three days.'),
)
```

### Destructive

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

## Variants and examples

### No results

```dart
CairnEmpty(
  media: const CairnIcon(CairnIconData.search, size: 32),
  title: 'No results',
  description: 'Try adjusting your filters, or clear them to start over.',
  actions: <Widget>[
    CairnButton(
      variant: CairnButtonVariant.outline,
      onPressed: () {},
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

## Variants and examples

### Circle

```dart
const CairnSkeleton.circle(size: 44)
```

### Text lines

```dart
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  spacing: CairnSpacing.s2,
  children: <Widget>[
    CairnSkeleton(width: 220, height: 12),
    CairnSkeleton(width: 160, height: 12),
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

## Variants and examples

### 16px (default)

```dart
const CairnSpinner()
```

### 24px

```dart
const CairnSpinner(size: 24)
```

### 32px · 3px stroke

```dart
const CairnSpinner(size: 32, strokeWidth: 3)
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

## Variants and examples

### Bordered

```dart
CairnList(
  bordered: true,
  children: <Widget>[
    CairnListItem(
      leading: const CairnAvatar(fallback: Text('RB')),
      title: const Text('Ralph'),
      subtitle: const Text('Owner'),
      trailing: const CairnBadge(label: Text('Admin')),
      onTap: () {},
    ),
    CairnListItem(
      leading: const CairnAvatar(fallback: Text('AL')),
      title: const Text('Ada'),
      subtitle: const Text('Maintainer'),
      trailing: const CairnBadge(
        variant: CairnBadgeVariant.secondary,
        label: Text('Member'),
      ),
      onTap: () {},
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

## Variants and examples

### Small

```dart
const CairnAvatar(
  size: CairnAvatarSize.sm,
  fallback: Text('RJ'),
)
```

### Medium

```dart
const CairnAvatar(fallback: Text('CA'))
```

### Large

```dart
const CairnAvatar(
  size: CairnAvatarSize.lg,
  fallback: Text('UI'),
)
```

### Group

```dart
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

