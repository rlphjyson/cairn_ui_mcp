# Data & feedback components: API

Exact public API for each component, generated from cairn_ui 0.2.0. Import: `import 'package:cairn_ui/cairn_ui.dart';`

# Progress

Determinate and indeterminate progress bars.

- Category: Data & feedback
- Widgets: `CairnProgress`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The track is the primary colour at 20% alpha, not the muted token — a detail that is invisible until you put the two side by side.

## Quick start

```dart
CairnProgress(value: _uploaded, semanticLabel: 'Upload')

const CairnProgress(semanticLabel: 'Working')
```

## API

### `CairnProgress` (widget)

A progress bar, determinate or indeterminate.

An 8 logical pixel fully-rounded track carrying a primary-coloured
indicator. The track is the primary colour at 20% alpha rather than the
muted token, so the filled and unfilled halves read as one object at two
strengths instead of two unrelated greys.

Passing null to [value] renders an indeterminate bar, for the very common
case of work whose duration is not known up front.

```dart
const CairnProgress(value: 0.6);
const CairnProgress(); // indeterminate
```

**Constructor** `CairnProgress({double? value, double height = 8.0, String? semanticLabel})`

Creates a progress bar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `double?` |  |  | Progress from 0 to 1, or null for indeterminate. |
| `height` | `double` |  | `8.0` | The track height (`h-2`). |
| `semanticLabel` | `String?` |  |  | The accessible name. |


---

# Toast

Stacked notifications that outlive the route that fired them.

- Category: Data & feedback
- Widgets: `CairnToaster`, `CairnToaster`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> CairnToaster is installed in MaterialApp.builder, above the Navigator, so a toast fired from a screen survives that screen being popped.

## Quick start

```dart
MaterialApp(
  builder: (BuildContext context, Widget? child) =>
      CairnToaster(child: child!),
);

CairnToast.show(
  context,
  const CairnToast(
    variant: CairnToastVariant.success,
    title: 'Changes saved',
    description: 'Your profile is up to date.',
  ),
);
```

## API

### `CairnToast`

A transient notification.

A toast is `rounded-md border bg-popover p-4 text-popover-foreground
shadow-lg`, stacked bottom-right, sliding in from the edge and
auto-dismissing after four seconds — long enough to read a sentence, short
enough that a burst of them clears.

## Where the stack lives

Toasts must outlive the widget that triggered them — a toast fired from a
screen that then pops must still finish showing. [CairnToaster] therefore
owns an [OverlayEntry] on the root overlay, not a widget in the caller's
subtree, and [CairnToast.show] finds it through the [Overlay] rather than an
inherited widget.

**Constructor** `CairnToast({required String title, String? description, CairnToastVariant variant = CairnToastVariant.normal, Duration duration = const Duration(seconds: 4), String? action, VoidCallback? onActionPressed})`

Creates a toast description.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `String` | yes |  | The heading — `text-sm font-medium`. |
| `description` | `String?` |  |  | Optional supporting text — `text-sm text-muted-foreground`. |
| `variant` | `CairnToastVariant` |  | `CairnToastVariant.normal` | The severity. |
| `duration` | `Duration` |  | `const Duration(seconds: 4)` | How long before it dismisses itself. |
| `action` | `String?` |  |  | An optional action label. |
| `onActionPressed` | `VoidCallback?` |  |  | Called when the action is pressed. |

**Static members**

- `void show(BuildContext context, CairnToast toast)` — Shows this toast in the nearest root [Overlay]. Returns once the toast has been queued; it dismisses itself.

### `CairnToaster` (widget)

Hosts the toast stack.

Place once, above the rest of the app:

```dart
MaterialApp(
  builder: (context, child) => CairnToaster(child: child!),
  home: const HomeScreen(),
);
```

**Constructor** `CairnToaster({required Widget child, Alignment alignment = Alignment.bottomRight, int maxVisible = 3, double width = 356.0})`

Creates a toast host.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The app below the toast layer. |
| `alignment` | `Alignment` |  | `Alignment.bottomRight` | Where the stack sits. Sonner defaults to bottom-right. |
| `maxVisible` | `int` |  | `3` | How many toasts are shown at once before the oldest is dropped. |
| `width` | `double` |  | `356.0` | Sonner's toast width. |

### `CairnToastVariant` (enum)

The severity of a [CairnToast].

- `CairnToastVariant.normal` — A neutral message.
- `CairnToastVariant.success` — A success confirmation, with a check icon.
- `CairnToastVariant.error` — An error, styled with the destructive token.
- `CairnToastVariant.info` — An informational note.


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

# Calendar

A month grid on a fixed 7 x 6 layout.

- Category: Data & feedback
- Widgets: `CairnCalendar`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The grid is always 7 x 6, so paging between months never changes the popover height — a jumping calendar is the classic giveaway.

## Quick start

```dart
CairnCalendar(
  selected: _date,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  weekStartsOnMonday: true,
  onChanged: (DateTime d) => setState(() => _date = d),
)
```

## API

### `CairnCalendar` (widget)

A month-grid date picker.

Day cells are 32 logical pixel (`size-8`) ghost buttons. The selected day
takes the primary fill, today takes the accent fill, and days spilling in
from the neighbouring months are muted to 50% opacity so the current month
still reads as a single block.

The grid is a fixed 7 x 6 so the calendar's height never changes as months
with different day counts are paged through — a jumping popover is one of
the more obvious tells of a hand-rolled date picker.

```dart
CairnCalendar(
  selected: date,
  onChanged: (d) => setState(() => date = d),
);
```

**Constructor** `CairnCalendar({DateTime? selected, ValueChanged<DateTime>? onChanged, DateTime? initialMonth, DateTime? firstDate, DateTime? lastDate, bool weekStartsOnMonday = true})`

Creates a calendar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `selected` | `DateTime?` |  |  | The currently selected day. |
| `onChanged` | `ValueChanged<DateTime>?` |  |  | Called when a day is chosen. |
| `initialMonth` | `DateTime?` |  |  | The month shown on first build. Defaults to [selected]'s month, else now. |
| `firstDate` | `DateTime?` |  |  | The earliest selectable day, inclusive. |
| `lastDate` | `DateTime?` |  |  | The latest selectable day, inclusive. |
| `weekStartsOnMonday` | `bool` |  | `true` | Whether weeks start on Monday (ISO) rather than Sunday (US default). |

**Static members**

- `double cellSize = 32.0` — `size-8` — the day cell.


---

# Date Picker

A Calendar inside a Popover, behind a formatted trigger.

- Category: Data & feedback
- Widgets: `CairnDatePicker`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnDatePicker(
  value: _date,
  placeholder: 'Pick a date',
  format: (DateTime d) => DateFormat.yMMMd().format(d),
  onChanged: (DateTime d) => setState(() => _date = d),
)
```

## API

### `CairnDatePicker` (widget)

A date field: a Calendar in a Popover, behind a button-shaped trigger.

A date picker is a composition rather than a primitive: an outline Button
trigger whose label is either the formatted date or a muted placeholder,
opening a Popover that holds a Calendar. Cairn ships it pre-assembled so it
is one widget at the call site, while still being built from
[CairnCalendar] and the popover layer — nothing here is a private
re-implementation of either.

[format] defaults to an unambiguous `D Month YYYY`. Applications with
`intl` available should pass their own formatter rather than relying on it,
which is why this takes a callback instead of a pattern string — the package
stays dependency-free.

```dart
CairnDatePicker(
  value: date,
  onChanged: (d) => setState(() => date = d),
);
```

**Constructor** `CairnDatePicker({DateTime? value, ValueChanged<DateTime>? onChanged, String placeholder = 'Pick a date', String Function(DateTime)? format, DateTime? firstDate, DateTime? lastDate, DateTime? initialMonth, double width = 240.0, bool hasError = false})`

Creates a date picker.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `DateTime?` |  |  | The selected date. |
| `onChanged` | `ValueChanged<DateTime>?` |  |  | Called when a date is chosen. |
| `placeholder` | `String` |  | `'Pick a date'` | Text shown when nothing is selected. |
| `format` | `String Function(DateTime)?` |  |  | Formats the selected date for display. |
| `firstDate` | `DateTime?` |  |  | The earliest selectable date. |
| `lastDate` | `DateTime?` |  |  | The latest selectable date. |
| `initialMonth` | `DateTime?` |  |  | The month the calendar opens on when nothing is selected. Defaults to the current month. Set this to make the picker deterministic in tests, or to open on a business-relevant month. |
| `width` | `double` |  | `240.0` | The trigger width. |
| `hasError` | `bool` |  | `false` | Marks the field invalid. |


---

# Radial Progress

An animated progress ring.

- Category: Data & feedback
- Widgets: `CairnRadialProgress`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
const CairnRadialProgress(
  value: 0.7,
  tone: CairnTone.success,
  showValue: true,
)
```

## API

### `CairnRadialProgress` (widget)

A circular progress indicator with room for a value in the middle.

The ring analogue of [CairnProgress]: the track is the indicator colour at
20% alpha and the arc is the full colour, so the two halves read as one
object at two strengths. The arc starts at twelve o'clock, runs clockwise,
has round caps, and animates between values at 300ms on the standard curve.

[child] is centred inside the ring; when omitted and [showValue] is true the
percentage is drawn there.

```dart
const CairnRadialProgress(value: 0.7, showValue: true);
```

**Constructor** `CairnRadialProgress({required double value, double size = 64.0, double thickness = 6.0, CairnTone tone = CairnTone.primary, bool showValue = false, Widget? child, String? semanticLabel})`

Creates a radial progress indicator.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `double` | yes |  | Progress from 0 to 1. |
| `size` | `double` |  | `64.0` | The outer diameter. |
| `thickness` | `double` |  | `6.0` | The ring thickness. |
| `tone` | `CairnTone` |  | `CairnTone.primary` | The colour intent. |
| `showValue` | `bool` |  | `false` | Whether to draw the percentage in the centre when [child] is null. |
| `child` | `Widget?` |  |  | Centre content. |
| `semanticLabel` | `String?` |  |  | The accessible name. |


---

# Countdown

A ticking countdown that shows only the units it needs.

- Category: Data & feedback
- Widgets: `CairnCountdown`, `CairnCountdownDigits`, `CairnCountdownDigits`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Owns a Timer that ticks once a second. Remove it from the tree to dispose it.

## Quick start

```dart
CairnCountdown(
  duration: const Duration(hours: 26, minutes: 14),
  onComplete: _launch,
)
```

## API

### `CairnCountdown` (widget)

A ticking countdown to zero, shown as labelled digit blocks.

Counts down from [duration] once per second, rendering days (only when the
duration reaches that far), hours, minutes and seconds as two-digit blocks
in tabular figures so the layout does not jitter as digits change. Each
block is a `muted` rounded tile with a small caption beneath it.

[onComplete] fires once, when the count reaches zero. Changing [duration]
restarts the countdown.

For a bare digit with no tile — a single number inside a sentence — use
[CairnCountdownDigits].

```dart
CairnCountdown(
  duration: const Duration(hours: 2, minutes: 30),
  onComplete: () => print('Sale over'),
);
```

**Constructor** `CairnCountdown({required Duration duration, VoidCallback? onComplete})`

Creates a countdown.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `duration` | `Duration` | yes |  | How long to count down for. |
| `onComplete` | `VoidCallback?` |  |  | Called once when the countdown reaches zero. |

### `CairnCountdownDigits` (widget)

A number rendered as zero-padded, tabular digits.

Tabular figures give every digit the same advance, so a ticking value does
not shift the text around it. Inherits its style from the ambient
[DefaultTextStyle] unless [style] is given.

**Constructor** `CairnCountdownDigits({required int value, int minDigits = 2, TextStyle? style})`

Creates a digit run.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `int` | yes |  | The number to show. |
| `minDigits` | `int` |  | `2` | The minimum width, zero-padded. |
| `style` | `TextStyle?` |  |  | The text style. |


---

