# Overlays components: API

Exact public API for each component, generated from cairn_ui 0.2.0. Import: `import 'package:cairn_ui/cairn_ui.dart';`

# Dialog

A focus-trapped modal, dismissible by Escape or barrier.

- Category: Overlays
- Widgets: `CairnDialog`, `CairnDialogHeader`, `CairnDialogFooter`, `CairnAlertDialog`, `CairnAlertDialog`, `CairnDialogHeader`, `CairnDialogFooter`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Pushes a PopupRoute, so Flutter supplies focus trapping, focus restore and back-gesture dismissal rather than each being hand-wired.

## Quick start

```dart
showCairnDialog<void>(
  context: context,
  builder: (BuildContext context) => CairnDialog(
    title: const Text('Edit profile'),
    description: const Text('Save when you are done.'),
    content: const CairnFormField(label: 'Name', child: CairnInput()),
    actions: <Widget>[
      CairnButton(onPressed: _save, child: const Text('Save changes')),
    ],
  ),
)
```

## API

### `CairnDialog` (widget)

The panel shown by [showCairnDialog].

Three slots — header (title + description), body and footer — separated by
`gap-4` (16 logical pixels) inside `p-6` padding. Slots rather than a free
child list, so that every dialog in an app spaces its parts the same way
without each call site re-deciding.

**Constructor** `CairnDialog({Widget? title, Widget? description, Widget? content, List<Widget> actions = const <Widget>[], bool showCloseButton = true, double maxWidth = 512.0})`

Creates a dialog panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The dialog heading — `text-lg leading-none font-semibold`. |
| `description` | `Widget?` |  |  | The supporting text — `text-sm text-muted-foreground`. |
| `content` | `Widget?` |  |  | The dialog body. |
| `actions` | `List<Widget>` |  | `const <Widget>[]` | Footer buttons, right-aligned on wide layouts. |
| `showCloseButton` | `bool` |  | `true` | Whether to show the `top-4 right-4` close affordance. |
| `maxWidth` | `double` |  | `512.0` | `sm:max-w-lg` — 32rem. |

### `CairnDialogHeader` (widget)

The title and description block of a [CairnDialog] — `flex flex-col gap-2`.

**Constructor** `CairnDialogHeader({Widget? title, Widget? description})`

Creates a dialog header.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading. |
| `description` | `Widget?` |  |  | The supporting text. |

### `CairnDialogFooter` (widget)

The action row of a [CairnDialog].

`flex flex-col-reverse gap-2 sm:flex-row sm:justify-end` — stacked and
reversed on narrow screens so the primary action sits at the bottom under a
thumb, and a right-aligned row on wide ones. The breakpoint is Tailwind's
`sm` (640px).

**Constructor** `CairnDialogFooter({required List<Widget> children})`

Creates a dialog footer.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The actions, in logical order (primary last). |

### `CairnAlertDialog` (widget)

A confirmation dialog.

Differs from [CairnDialog] in three ways that matter: there is no close
button, the scrim is not dismissible, and Escape does not close it — an
alert dialog exists precisely to demand an explicit choice, and every
accidental way out of it undermines that.

**Constructor** `CairnAlertDialog({Widget? title, Widget? description, List<Widget> actions = const <Widget>[], double maxWidth = 512.0})`

Creates an alert dialog panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading. |
| `description` | `Widget?` |  |  | The supporting text. |
| `actions` | `List<Widget>` |  | `const <Widget>[]` | The actions — typically a cancel and a confirm button. |
| `maxWidth` | `double` |  | `512.0` | `sm:max-w-lg`. |

### `showCairnDialog()` (function)

`Future<T?> showCairnDialog({required BuildContext context, required WidgetBuilder builder, bool barrierDismissible = true, String barrierLabel = 'Dismiss'})`

Shows a modal dialog.

The panel is `w-full max-w-[calc(100%-2rem)] sm:max-w-lg gap-4 rounded-lg
border bg-background p-6 shadow-lg` over a `bg-black/50` scrim, animating in
over 200ms with `fade-in-0 zoom-in-95`.

## Why this pushes a route

A modal dialog owes the keyboard three things: focus moves into it on open,
cannot escape it while it is up, and returns to the trigger on close. Escape
dismisses. Flutter gives all three for free to anything pushed as a
[ModalRoute] — [Navigator] installs a [FocusScope] per route and restores
focus on pop. Reimplementing that on an [OverlayEntry] would mean
hand-rolling a focus trap, so modal surfaces use a route while *anchored*
surfaces (Popover, Dropdown Menu) use an overlay.

It also buys something the web has no equivalent of: the platform back
gesture and Android's back button dismiss the dialog, which is what a mobile
user will try first.

```dart
await showCairnDialog<void>(
  context: context,
  builder: (context) => CairnDialog(
    title: const Text('Delete project'),
    description: const Text('This cannot be undone.'),
    content: const SizedBox.shrink(),
    actions: [
      CairnButton(
        variant: CairnButtonVariant.outline,
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  ),
);
```

### `showCairnAlertDialog()` (function)

`Future<T?> showCairnAlertDialog({required BuildContext context, required WidgetBuilder builder})`

Shows a [CairnAlertDialog].

Unlike [showCairnDialog] this is not barrier-dismissible and swallows the
back gesture, so the user must pick one of [CairnAlertDialog.actions].


---

# Alert Dialog

A modal that demands an explicit choice.

- Category: Overlays
- Widgets: `CairnDialog`, `CairnDialogHeader`, `CairnDialogFooter`, `CairnAlertDialog`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Deliberately not dismissible by Escape or by tapping the barrier. Every other Cairn overlay closes on Escape; this one does not.

## Quick start

```dart
showCairnAlertDialog<void>(
  context: context,
  builder: (BuildContext context) => CairnAlertDialog(
    title: const Text('Are you absolutely sure?'),
    description: const Text('This cannot be undone.'),
    actions: <Widget>[
      CairnButton(
        variant: CairnButtonVariant.outline,
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      CairnButton(
        variant: CairnButtonVariant.destructive,
        onPressed: _delete,
        child: const Text('Delete'),
      ),
    ],
  ),
)
```

## API

### `CairnDialog` (widget)

The panel shown by [showCairnDialog].

Three slots — header (title + description), body and footer — separated by
`gap-4` (16 logical pixels) inside `p-6` padding. Slots rather than a free
child list, so that every dialog in an app spaces its parts the same way
without each call site re-deciding.

**Constructor** `CairnDialog({Widget? title, Widget? description, Widget? content, List<Widget> actions = const <Widget>[], bool showCloseButton = true, double maxWidth = 512.0})`

Creates a dialog panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The dialog heading — `text-lg leading-none font-semibold`. |
| `description` | `Widget?` |  |  | The supporting text — `text-sm text-muted-foreground`. |
| `content` | `Widget?` |  |  | The dialog body. |
| `actions` | `List<Widget>` |  | `const <Widget>[]` | Footer buttons, right-aligned on wide layouts. |
| `showCloseButton` | `bool` |  | `true` | Whether to show the `top-4 right-4` close affordance. |
| `maxWidth` | `double` |  | `512.0` | `sm:max-w-lg` — 32rem. |

### `CairnDialogHeader` (widget)

The title and description block of a [CairnDialog] — `flex flex-col gap-2`.

**Constructor** `CairnDialogHeader({Widget? title, Widget? description})`

Creates a dialog header.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading. |
| `description` | `Widget?` |  |  | The supporting text. |

### `CairnDialogFooter` (widget)

The action row of a [CairnDialog].

`flex flex-col-reverse gap-2 sm:flex-row sm:justify-end` — stacked and
reversed on narrow screens so the primary action sits at the bottom under a
thumb, and a right-aligned row on wide ones. The breakpoint is Tailwind's
`sm` (640px).

**Constructor** `CairnDialogFooter({required List<Widget> children})`

Creates a dialog footer.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The actions, in logical order (primary last). |

### `CairnAlertDialog` (widget)

A confirmation dialog.

Differs from [CairnDialog] in three ways that matter: there is no close
button, the scrim is not dismissible, and Escape does not close it — an
alert dialog exists precisely to demand an explicit choice, and every
accidental way out of it undermines that.

**Constructor** `CairnAlertDialog({Widget? title, Widget? description, List<Widget> actions = const <Widget>[], double maxWidth = 512.0})`

Creates an alert dialog panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading. |
| `description` | `Widget?` |  |  | The supporting text. |
| `actions` | `List<Widget>` |  | `const <Widget>[]` | The actions — typically a cancel and a confirm button. |
| `maxWidth` | `double` |  | `512.0` | `sm:max-w-lg`. |

### `showCairnDialog()` (function)

`Future<T?> showCairnDialog({required BuildContext context, required WidgetBuilder builder, bool barrierDismissible = true, String barrierLabel = 'Dismiss'})`

Shows a modal dialog.

The panel is `w-full max-w-[calc(100%-2rem)] sm:max-w-lg gap-4 rounded-lg
border bg-background p-6 shadow-lg` over a `bg-black/50` scrim, animating in
over 200ms with `fade-in-0 zoom-in-95`.

## Why this pushes a route

A modal dialog owes the keyboard three things: focus moves into it on open,
cannot escape it while it is up, and returns to the trigger on close. Escape
dismisses. Flutter gives all three for free to anything pushed as a
[ModalRoute] — [Navigator] installs a [FocusScope] per route and restores
focus on pop. Reimplementing that on an [OverlayEntry] would mean
hand-rolling a focus trap, so modal surfaces use a route while *anchored*
surfaces (Popover, Dropdown Menu) use an overlay.

It also buys something the web has no equivalent of: the platform back
gesture and Android's back button dismiss the dialog, which is what a mobile
user will try first.

```dart
await showCairnDialog<void>(
  context: context,
  builder: (context) => CairnDialog(
    title: const Text('Delete project'),
    description: const Text('This cannot be undone.'),
    content: const SizedBox.shrink(),
    actions: [
      CairnButton(
        variant: CairnButtonVariant.outline,
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
    ],
  ),
);
```

### `showCairnAlertDialog()` (function)

`Future<T?> showCairnAlertDialog({required BuildContext context, required WidgetBuilder builder})`

Shows a [CairnAlertDialog].

Unlike [showCairnDialog] this is not barrier-dismissible and swallows the
back gesture, so the user must pick one of [CairnAlertDialog.actions].


---

# Sheet

A panel that slides in from any of the four edges.

- Category: Overlays
- Widgets: `CairnSheet`, `CairnDrawer`, `CairnDrawer`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Asymmetric motion: 500ms to open, 300ms to close, matching data-[state=open]:duration-500 / data-[state=closed]:duration-300.

## Quick start

```dart
showCairnSheet<void>(
  context: context,
  side: CairnSheetSide.right,
  builder: (BuildContext context) => CairnSheet(
    side: CairnSheetSide.right,
    title: const Text('Filters'),
    content: const CairnFormField(label: 'Query', child: CairnInput()),
    footer: <Widget>[
      CairnButton(expand: true, onPressed: _apply, child: const Text('Apply')),
    ],
  ),
)
```

## API

### `CairnSheet` (widget)

The panel shown by [showCairnSheet].

**Constructor** `CairnSheet({Widget? title, Widget? description, Widget? content, List<Widget> footer = const <Widget>[], CairnSheetSide side = CairnSheetSide.right, bool showCloseButton = true, double maxExtent = 384.0, double widthFactor = 0.75})`

Creates a sheet panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading — `font-semibold text-foreground`. |
| `description` | `Widget?` |  |  | The supporting text — `text-sm text-muted-foreground`. |
| `content` | `Widget?` |  |  | The body. |
| `footer` | `List<Widget>` |  | `const <Widget>[]` | Footer actions, pinned to the bottom (`mt-auto`). |
| `side` | `CairnSheetSide` |  | `CairnSheetSide.right` | Which edge this sheet is attached to. |
| `showCloseButton` | `bool` |  | `true` | Whether to show the `top-4 right-4` close affordance. |
| `maxExtent` | `double` |  | `384.0` | `sm:max-w-sm` — 24rem. |
| `widthFactor` | `double` |  | `0.75` | `w-3/4`. |

### `CairnDrawer` (widget)

A bottom sheet with a drag handle.

A drawer is a [CairnSheet] pinned to the bottom edge plus a grab handle and
a drag-to-dismiss gesture, not a separate system. Building it on the sheet
means the two share their scrim, their focus handling and their dismissal
semantics, and cannot drift apart.

**Constructor** `CairnDrawer({Widget? title, Widget? description, Widget? content, List<Widget> footer = const <Widget>[]})`

Creates a drawer panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading. |
| `description` | `Widget?` |  |  | The supporting text. |
| `content` | `Widget?` |  |  | The body. |
| `footer` | `List<Widget>` |  | `const <Widget>[]` | Footer actions. |

### `CairnSheetSide` (enum)

Which edge a [CairnSheet] slides in from.

- `CairnSheetSide.top` — `inset-x-0 top-0 h-auto border-b`.
- `CairnSheetSide.right` — `inset-y-0 right-0 h-full w-3/4 sm:max-w-sm border-l`.
- `CairnSheetSide.bottom` — `inset-x-0 bottom-0 h-auto border-t`.
- `CairnSheetSide.left` — `inset-y-0 left-0 h-full w-3/4 sm:max-w-sm border-r`.

### `showCairnSheet()` (function)

`Future<T?> showCairnSheet({required BuildContext context, required WidgetBuilder builder, CairnSheetSide side = CairnSheetSide.right, bool barrierDismissible = true})`

Shows an edge-anchored panel.

Side sheets are `w-3/4 sm:max-w-sm` — three quarters of the viewport, capped
at 384 logical pixels — with a `shadow-lg` and a border on the inner edge.

The animation is deliberately **asymmetric**: 500ms to open and 300ms to
close. A panel travelling most of the screen's width needs the slower
entrance to stay legible as motion rather than a jump cut, but on the way
out the user has already decided and any extra time is just waiting. The
route's separate forward and reverse durations carry that.

```dart
await showCairnSheet<void>(
  context: context,
  side: CairnSheetSide.right,
  builder: (context) => const CairnSheet(
    title: Text('Filters'),
    content: SizedBox.shrink(),
  ),
);
```

### `showCairnDrawer()` (function)

`Future<T?> showCairnDrawer({required BuildContext context, required WidgetBuilder builder, bool barrierDismissible = true})`

Shows a [CairnDrawer] from the bottom edge.


---

# Drawer

A bottom sheet with a grab handle and drag-to-dismiss.

- Category: Overlays
- Widgets: `CairnSheet`, `CairnDrawer`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
showCairnDrawer<void>(
  context: context,
  builder: (BuildContext context) => CairnDrawer(
    title: const Text('Move goal'),
    description: const Text('Set your daily activity goal.'),
    content: const Text('Drag down to dismiss.'),
  ),
)
```

## API

### `CairnSheet` (widget)

The panel shown by [showCairnSheet].

**Constructor** `CairnSheet({Widget? title, Widget? description, Widget? content, List<Widget> footer = const <Widget>[], CairnSheetSide side = CairnSheetSide.right, bool showCloseButton = true, double maxExtent = 384.0, double widthFactor = 0.75})`

Creates a sheet panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading — `font-semibold text-foreground`. |
| `description` | `Widget?` |  |  | The supporting text — `text-sm text-muted-foreground`. |
| `content` | `Widget?` |  |  | The body. |
| `footer` | `List<Widget>` |  | `const <Widget>[]` | Footer actions, pinned to the bottom (`mt-auto`). |
| `side` | `CairnSheetSide` |  | `CairnSheetSide.right` | Which edge this sheet is attached to. |
| `showCloseButton` | `bool` |  | `true` | Whether to show the `top-4 right-4` close affordance. |
| `maxExtent` | `double` |  | `384.0` | `sm:max-w-sm` — 24rem. |
| `widthFactor` | `double` |  | `0.75` | `w-3/4`. |

### `CairnDrawer` (widget)

A bottom sheet with a drag handle.

A drawer is a [CairnSheet] pinned to the bottom edge plus a grab handle and
a drag-to-dismiss gesture, not a separate system. Building it on the sheet
means the two share their scrim, their focus handling and their dismissal
semantics, and cannot drift apart.

**Constructor** `CairnDrawer({Widget? title, Widget? description, Widget? content, List<Widget> footer = const <Widget>[]})`

Creates a drawer panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | `Widget?` |  |  | The heading. |
| `description` | `Widget?` |  |  | The supporting text. |
| `content` | `Widget?` |  |  | The body. |
| `footer` | `List<Widget>` |  | `const <Widget>[]` | Footer actions. |

### `CairnSheetSide` (enum)

Which edge a [CairnSheet] slides in from.

- `CairnSheetSide.top` — `inset-x-0 top-0 h-auto border-b`.
- `CairnSheetSide.right` — `inset-y-0 right-0 h-full w-3/4 sm:max-w-sm border-l`.
- `CairnSheetSide.bottom` — `inset-x-0 bottom-0 h-auto border-t`.
- `CairnSheetSide.left` — `inset-y-0 left-0 h-full w-3/4 sm:max-w-sm border-r`.

### `showCairnSheet()` (function)

`Future<T?> showCairnSheet({required BuildContext context, required WidgetBuilder builder, CairnSheetSide side = CairnSheetSide.right, bool barrierDismissible = true})`

Shows an edge-anchored panel.

Side sheets are `w-3/4 sm:max-w-sm` — three quarters of the viewport, capped
at 384 logical pixels — with a `shadow-lg` and a border on the inner edge.

The animation is deliberately **asymmetric**: 500ms to open and 300ms to
close. A panel travelling most of the screen's width needs the slower
entrance to stay legible as motion rather than a jump cut, but on the way
out the user has already decided and any extra time is just waiting. The
route's separate forward and reverse durations carry that.

```dart
await showCairnSheet<void>(
  context: context,
  side: CairnSheetSide.right,
  builder: (context) => const CairnSheet(
    title: Text('Filters'),
    content: SizedBox.shrink(),
  ),
);
```

### `showCairnDrawer()` (function)

`Future<T?> showCairnDrawer({required BuildContext context, required WidgetBuilder builder, bool barrierDismissible = true})`

Shows a [CairnDrawer] from the bottom edge.


---

# Popover

An anchored surface that flips and shifts to stay on screen.

- Category: Overlays
- Widgets: `CairnSurface`, `CairnPopover`, `CairnPopoverTitle`, `CairnPopoverDescription`, `CairnSurface`, `CairnPopoverTitle`, `CairnPopoverDescription`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Uses OverlayPortal rather than a route, so it stays out of the navigation stack and the back gesture does not close it.

## Quick start

```dart
final CairnOverlayController controller = CairnOverlayController();

CairnPopover(
  controller: controller,
  side: CairnSide.bottom,
  align: CairnAlign.start,
  content: const CairnPopoverTitle('Dimensions'),
  child: CairnButton(
    variant: CairnButtonVariant.outline,
    onPressed: controller.toggle,
    child: const Text('Open popover'),
  ),
)
```

## API

### `CairnSurface` (widget)

The floating panel shared by Popover, Dropdown Menu, Select and friends.

`rounded-md border bg-popover text-popover-foreground shadow-md`. Padding
varies by component — Popover and Hover Card use `p-4`, menus use `p-1` —
so it is a parameter rather than baked in.

Exposed publicly so applications can build their own floating surfaces that
match the rest of the library.

**Constructor** `CairnSurface({required Widget child, EdgeInsetsGeometry padding = const EdgeInsets.all(CairnSpacing.s4), double? width, BoxConstraints? constraints, bool elevated = false})`

Creates a floating surface.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The panel's contents. |
| `padding` | `EdgeInsetsGeometry` |  | `const EdgeInsets.all(CairnSpacing.s4)` | Inner padding. |
| `width` | `double?` |  |  | An optional fixed width. |
| `constraints` | `BoxConstraints?` |  |  | Optional size constraints. |
| `elevated` | `bool` |  | `false` | Whether to use `shadow-lg` instead of `shadow-md`. Submenus and Context Menus sit at `shadow-lg`; top-level Popovers and Dropdown Menus at `shadow-md`. |

### `CairnPopover` (widget)

A floating panel anchored to a trigger.

The content is `w-72` (288 logical pixels) with `p-4` padding, `rounded-md`,
a 1px border and `shadow-md`, offset 4px from the trigger.

```dart
final controller = CairnOverlayController();

CairnPopover(
  controller: controller,
  content: const Text('Anchored content'),
  child: CairnButton(
    onPressed: controller.toggle,
    child: const Text('Open'),
  ),
);
```

**Constructor** `CairnPopover({required CairnOverlayController controller, required Widget child, required Widget content, CairnSide side = CairnSide.bottom, CairnAlign align = CairnAlign.center, double offset = 4.0, double? width = 288.0, EdgeInsetsGeometry padding = const EdgeInsets.all(CairnSpacing.s4)})`

Creates a popover.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `controller` | `CairnOverlayController` | yes |  | Drives the open state. |
| `child` | `Widget` | yes |  | The trigger. |
| `content` | `Widget` | yes |  | The panel's contents. |
| `side` | `CairnSide` |  | `CairnSide.bottom` | The preferred side. |
| `align` | `CairnAlign` |  | `CairnAlign.center` | The cross-axis alignment. |
| `offset` | `double` |  | `4.0` | The gap between trigger and panel. |
| `width` | `double?` |  | `288.0` | The panel width (`w-72`). |
| `padding` | `EdgeInsetsGeometry` |  | `const EdgeInsets.all(CairnSpacing.s4)` | The panel's inner padding (`p-4`). |

### `CairnPopoverTitle` (widget)

The title slot of a [CairnPopover] — `font-medium`.

**Constructor** `CairnPopoverTitle(String text)`

Creates a popover title.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `text` | `String` | yes |  | The title text. |

### `CairnPopoverDescription` (widget)

The description slot of a [CairnPopover] — `text-muted-foreground`.

**Constructor** `CairnPopoverDescription(String text)`

Creates a popover description.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `text` | `String` | yes |  | The description text. |


---

# Tooltip

A hint that opens on hover and on keyboard focus.

- Category: Overlays
- Widgets: `CairnTooltip`, `CairnHoverCard`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Keyboard focus opens it too — a tooltip that only responds to a mouse is invisible to anyone tabbing through the page.

## Quick start

```dart
CairnTooltip(
  message: 'Copy to clipboard',
  side: CairnSide.top,
  openDelay: const Duration(milliseconds: 700),
  child: CairnButton.icon(
    icon: const CairnIcon(CairnIconData.check),
    semanticLabel: 'Copy',
    onPressed: _copy,
  ),
)
```

## API

### `CairnTooltip` (widget)

A hover/focus hint.

`w-fit rounded-md bg-foreground px-3 py-1.5 text-xs text-background` — note
the **inverted** colours: a tooltip is the foreground colour filled with
background-coloured text, so it reads as a dark chip in light mode and a
light chip in dark mode. It carries no border and no shadow.

## Behaviour

The tooltip opens after a 700ms delay and closes immediately on pointer
exit: the delay is what stops a row of icon buttons flashing tooltips as the
pointer crosses them, and there is no reason to linger once the pointer has
left. It also opens on keyboard focus, without which a tooltip is invisible
to anyone not using a mouse.

```dart
CairnTooltip(
  message: 'Copy to clipboard',
  child: CairnButton.icon(
    icon: const CairnIcon(CairnIconData.check),
    semanticLabel: 'Copy',
    onPressed: () {},
  ),
);
```

**Constructor** `CairnTooltip({required String message, required Widget child, CairnSide side = CairnSide.top, CairnAlign align = CairnAlign.center, double offset = 4.0, Duration openDelay = const Duration(milliseconds: 700)})`

Creates a tooltip.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `message` | `String` | yes |  | The hint text. |
| `child` | `Widget` | yes |  | The widget the tooltip describes. |
| `side` | `CairnSide` |  | `CairnSide.top` | The preferred side. |
| `align` | `CairnAlign` |  | `CairnAlign.center` | The cross-axis alignment. |
| `offset` | `double` |  | `4.0` | The gap between trigger and tooltip. |
| `openDelay` | `Duration` |  | `const Duration(milliseconds: 700)` | How long the pointer must rest before the tooltip opens. |

### `CairnHoverCard` (widget)

A richer hover panel.

`w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md` —
256 logical pixels wide, and unlike [CairnTooltip] it is a normal popover
surface rather than an inverted chip.

It opens after 700ms and closes after a 300ms grace period. The grace
period is the difference between a usable hover card and an infuriating one:
the card holds interactive content, so the pointer has to be able to travel
from the trigger to the card without it vanishing in the gap between
them.

**Constructor** `CairnHoverCard({required Widget child, required Widget content, CairnSide side = CairnSide.bottom, CairnAlign align = CairnAlign.center, double offset = 4.0, double width = 256.0, Duration openDelay = const Duration(milliseconds: 700), Duration closeDelay = const Duration(milliseconds: 300)})`

Creates a hover card.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The trigger. |
| `content` | `Widget` | yes |  | The card's contents. |
| `side` | `CairnSide` |  | `CairnSide.bottom` | The preferred side. |
| `align` | `CairnAlign` |  | `CairnAlign.center` | The cross-axis alignment. |
| `offset` | `double` |  | `4.0` | The gap between trigger and card. |
| `width` | `double` |  | `256.0` | The card width (`w-64`). |
| `openDelay` | `Duration` |  | `const Duration(milliseconds: 700)` | How long the pointer must rest before opening. |
| `closeDelay` | `Duration` |  | `const Duration(milliseconds: 300)` | The grace period before closing, so the pointer can reach the card. |


---

# Hover Card

A rich preview with open and close grace periods.

- Category: Overlays
- Widgets: `CairnTooltip`, `CairnHoverCard`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The close delay is what makes it usable: without it, moving the pointer from the trigger into the card dismisses the card.

## Quick start

```dart
CairnHoverCard(
  openDelay: const Duration(milliseconds: 700),
  closeDelay: const Duration(milliseconds: 300),
  content: const Text('A modern, accessible component library for Flutter.'),
  child: CairnButton(
    variant: CairnButtonVariant.link,
    onPressed: _open,
    child: const Text('@cairn_ui'),
  ),
)
```

## API

### `CairnTooltip` (widget)

A hover/focus hint.

`w-fit rounded-md bg-foreground px-3 py-1.5 text-xs text-background` — note
the **inverted** colours: a tooltip is the foreground colour filled with
background-coloured text, so it reads as a dark chip in light mode and a
light chip in dark mode. It carries no border and no shadow.

## Behaviour

The tooltip opens after a 700ms delay and closes immediately on pointer
exit: the delay is what stops a row of icon buttons flashing tooltips as the
pointer crosses them, and there is no reason to linger once the pointer has
left. It also opens on keyboard focus, without which a tooltip is invisible
to anyone not using a mouse.

```dart
CairnTooltip(
  message: 'Copy to clipboard',
  child: CairnButton.icon(
    icon: const CairnIcon(CairnIconData.check),
    semanticLabel: 'Copy',
    onPressed: () {},
  ),
);
```

**Constructor** `CairnTooltip({required String message, required Widget child, CairnSide side = CairnSide.top, CairnAlign align = CairnAlign.center, double offset = 4.0, Duration openDelay = const Duration(milliseconds: 700)})`

Creates a tooltip.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `message` | `String` | yes |  | The hint text. |
| `child` | `Widget` | yes |  | The widget the tooltip describes. |
| `side` | `CairnSide` |  | `CairnSide.top` | The preferred side. |
| `align` | `CairnAlign` |  | `CairnAlign.center` | The cross-axis alignment. |
| `offset` | `double` |  | `4.0` | The gap between trigger and tooltip. |
| `openDelay` | `Duration` |  | `const Duration(milliseconds: 700)` | How long the pointer must rest before the tooltip opens. |

### `CairnHoverCard` (widget)

A richer hover panel.

`w-64 rounded-md border bg-popover p-4 text-popover-foreground shadow-md` —
256 logical pixels wide, and unlike [CairnTooltip] it is a normal popover
surface rather than an inverted chip.

It opens after 700ms and closes after a 300ms grace period. The grace
period is the difference between a usable hover card and an infuriating one:
the card holds interactive content, so the pointer has to be able to travel
from the trigger to the card without it vanishing in the gap between
them.

**Constructor** `CairnHoverCard({required Widget child, required Widget content, CairnSide side = CairnSide.bottom, CairnAlign align = CairnAlign.center, double offset = 4.0, double width = 256.0, Duration openDelay = const Duration(milliseconds: 700), Duration closeDelay = const Duration(milliseconds: 300)})`

Creates a hover card.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The trigger. |
| `content` | `Widget` | yes |  | The card's contents. |
| `side` | `CairnSide` |  | `CairnSide.bottom` | The preferred side. |
| `align` | `CairnAlign` |  | `CairnAlign.center` | The cross-axis alignment. |
| `offset` | `double` |  | `4.0` | The gap between trigger and card. |
| `width` | `double` |  | `256.0` | The card width (`w-64`). |
| `openDelay` | `Duration` |  | `const Duration(milliseconds: 700)` | How long the pointer must rest before opening. |
| `closeDelay` | `Duration` |  | `const Duration(milliseconds: 300)` | The grace period before closing, so the pointer can reach the card. |


---

# Dropdown Menu

An anchored menu with labels, shortcuts and separators.

- Category: Overlays
- Widgets: `CairnDropdownMenu`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnDropdownMenu(
  controller: controller,
  align: CairnAlign.end,
  items: <Widget>[
    const CairnMenuLabel('My account'),
    const CairnMenuSeparator(),
    CairnMenuItem(
      onPressed: _profile,
      shortcut: 'Ctrl+P',
      child: const Text('Profile'),
    ),
  ],
  child: CairnButton(onPressed: controller.toggle, child: const Text('Open')),
)
```

## API

### `CairnDropdownMenu` (widget)

A menu anchored to a trigger.

The panel is a [CairnMenuPanel] — `min-w-[8rem] rounded-md border bg-popover
p-1 shadow-md` — positioned 4px from the trigger and aligned to its start
edge rather than centred on it, so a wide menu under a narrow trigger still
lines up with the text the user was reading.

Choosing an item dismisses the menu automatically. A menu that stayed open
after a selection would leave the user to close it themselves, which is a
step nobody wants.

```dart
final menu = CairnOverlayController();

CairnDropdownMenu(
  controller: menu,
  items: [
    CairnMenuLabel('My account'),
    const CairnMenuSeparator(),
    CairnMenuItem(onPressed: () {}, shortcut: 'Ctrl+P', child: const Text('Profile')),
    CairnMenuItem(
      variant: CairnMenuItemVariant.destructive,
      onPressed: () {},
      child: const Text('Sign out'),
    ),
  ],
  child: CairnButton(onPressed: menu.toggle, child: const Text('Open')),
);
```

**Constructor** `CairnDropdownMenu({required CairnOverlayController controller, required Widget child, required List<Widget> items, CairnSide side = CairnSide.bottom, CairnAlign align = CairnAlign.start, double offset = 4.0, double minWidth = 128.0, double? maxHeight, bool closeOnSelect = true})`

Creates a dropdown menu.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `controller` | `CairnOverlayController` | yes |  | Drives the open state. |
| `child` | `Widget` | yes |  | The trigger. |
| `items` | `List<Widget>` | yes |  | The menu's rows. |
| `side` | `CairnSide` |  | `CairnSide.bottom` | The preferred side. |
| `align` | `CairnAlign` |  | `CairnAlign.start` | The cross-axis alignment. Dropdowns default to `start`. |
| `offset` | `double` |  | `4.0` | The gap between trigger and panel. |
| `minWidth` | `double` |  | `128.0` | `min-w-[8rem]`. |
| `maxHeight` | `double?` |  |  | An optional scroll cap. |
| `closeOnSelect` | `bool` |  | `true` | Whether choosing an item dismisses the menu. |


---

# Context Menu

A menu anchored to the pointer on right-click or long-press.

- Category: Overlays
- Widgets: `CairnContextMenu`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Anchors to the pointer position, not the widget, so the menu appears where the user actually clicked.

## Quick start

```dart
CairnContextMenu(
  items: <Widget>[
    CairnMenuItem(onPressed: _back, child: const Text('Back')),
    const CairnMenuSeparator(),
    CairnMenuItem(
      onPressed: _reload,
      shortcut: 'Ctrl+R',
      child: const Text('Reload'),
    ),
  ],
  child: const Placeholder(),
)
```

## API

### `CairnContextMenu` (widget)

A menu opened by right-click or long-press.

Unlike a Dropdown Menu, a context menu is anchored to the **pointer**, not
to a widget — so the layout anchor is a zero-size rect at the click point.
It also sits at `shadow-lg` rather than `shadow-md`.

Opens on secondary (right) click on desktop and on long-press on touch,
which are the two platform-native gestures for this.

```dart
CairnContextMenu(
  items: [
    CairnMenuItem(onPressed: () {}, child: const Text('Back')),
    const CairnMenuSeparator(),
    CairnMenuItem(onPressed: () {}, child: const Text('Reload')),
  ],
  child: const CairnCard(children: [/* ... */]),
);
```

**Constructor** `CairnContextMenu({required Widget child, required List<Widget> items, double minWidth = 128.0})`

Creates a context menu.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The region that responds to right-click and long-press. |
| `items` | `List<Widget>` | yes |  | The menu's rows. |
| `minWidth` | `double` |  | `128.0` | `min-w-[8rem]`. |


---

# Menu

The panel, item, checkbox item, label and separator primitives.

- Category: Overlays
- Widgets: `CairnMenuPanel`, `CairnMenuItem`, `CairnMenuCheckboxItem`, `CairnMenuLabel`, `CairnMenuSeparator`, `CairnMenuPanel`, `CairnMenuItem`, `CairnMenuCheckboxItem`, `CairnMenuLabel`, `CairnMenuSeparator`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Panels are p-1 with min-w-[8rem]. Menu items use cursor-default, not a pointer — a menu row is not a link.

## Quick start

```dart
CairnMenuPanel(
  minWidth: 240,
  children: <Widget>[
    const CairnMenuLabel('Appearance'),
    const CairnMenuSeparator(),
    CairnMenuCheckboxItem(
      value: _statusBar,
      onChanged: (bool v) => setState(() => _statusBar = v),
      child: const Text('Status bar'),
    ),
  ],
)
```

## API

### `CairnMenuPanel` (widget)

The panel that holds menu items.

`min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1
text-popover-foreground shadow-md` — a 128 logical pixel minimum width and,
importantly, only **4px** of padding (`p-1`), unlike a Popover's 16px.

Shared by Dropdown Menu, Context Menu, Menubar and Select so their metrics
cannot drift apart.

**Constructor** `CairnMenuPanel({required List<Widget> children, double minWidth = 128.0, double? maxHeight, bool elevated = false})`

Creates a menu panel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `children` | `List<Widget>` | yes |  | The menu's items. |
| `minWidth` | `double` |  | `128.0` | `min-w-[8rem]`. |
| `maxHeight` | `double?` |  |  | An optional scroll cap for long menus. |
| `elevated` | `bool` |  | `false` | Whether to use `shadow-lg` (submenus, context menus) over `shadow-md`. |

### `CairnMenuItem` (widget)

A selectable row in a menu.

`relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5
text-sm select-none focus:bg-accent focus:text-accent-foreground` — 8px
horizontal and 6px vertical padding with a `rounded-sm` (6px) highlight.

Note the cursor stays the default arrow rather than becoming a pointing
hand. Inside an open menu every row is clickable, so a hand cursor
distinguishes nothing — and its absence is one of those details that reads
as wrong only when it is missing.

Highlighting follows the pointer *and* the keyboard through one shared
highlight index, rather than letting hover and arrow keys each maintain
their own. That is how a native menu behaves: moving the mouse takes the
highlight away from where the arrow keys left it, instead of lighting up two
rows at once.

**Constructor** `CairnMenuItem({required Widget child, VoidCallback? onPressed, Widget? leading, Widget? trailing, String? shortcut, CairnMenuItemVariant variant = CairnMenuItemVariant.normal, bool inset = false, bool enabled = true, String? semanticLabel})`

Creates a menu item.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The item's label. |
| `onPressed` | `VoidCallback?` |  |  | Called when the item is chosen. Null disables it. |
| `leading` | `Widget?` |  |  | An icon before the label, forced to `size-4`. |
| `trailing` | `Widget?` |  |  | A widget after the label, before any [shortcut]. |
| `shortcut` | `String?` |  |  | A keyboard hint pinned to the trailing edge (`ml-auto text-xs tracking-widest text-muted-foreground`). |
| `variant` | `CairnMenuItemVariant` |  | `CairnMenuItemVariant.normal` | The visual style. |
| `inset` | `bool` |  | `false` | `data-[inset]:pl-8` — indents to line up with items that have icons. |
| `enabled` | `bool` |  | `true` | Whether the item can be chosen. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnMenuCheckboxItem` (widget)

A menu row with a check indicator, matching `DropdownMenuCheckboxItem`.

`py-1.5 pr-2 pl-8` with the indicator absolutely positioned at `left-2` in
a `size-3.5` box — the 32px left padding is what reserves room for it.

**Constructor** `CairnMenuCheckboxItem({required bool value, required Widget child, ValueChanged<bool>? onChanged, String? shortcut, bool enabled = true})`

Creates a checkable menu item.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `bool` | yes |  | Whether the item is checked. |
| `child` | `Widget` | yes |  | The item's label. |
| `onChanged` | `ValueChanged<bool>?` |  |  | Called with the next value. |
| `shortcut` | `String?` |  |  | A trailing keyboard hint. |
| `enabled` | `bool` |  | `true` | Whether the item can be chosen. |

### `CairnMenuLabel` (widget)

A non-interactive heading in a menu.

`px-2 py-1.5 text-sm font-medium`.

**Constructor** `CairnMenuLabel(String text, {bool inset = false})`

Creates a menu label.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `text` | `String` | yes |  | The heading text. |
| `inset` | `bool` |  | `false` | Whether to indent to align with items that have icons. |

### `CairnMenuSeparator` (widget)

A divider between menu groups.

`-mx-1 my-1 h-px bg-border` — the negative horizontal margin cancels the
panel's `p-1` so the rule spans the full panel width.

**Constructor** `CairnMenuSeparator()`

Creates a menu separator.

### `CairnMenuItemVariant` (enum)

The visual style of a [CairnMenuItem].

- `CairnMenuItemVariant.normal` — The default appearance.
- `CairnMenuItemVariant.destructive` — `text-destructive`, with a `bg-destructive/10` highlight on focus (`/20` in dark mode).


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

# Combobox

A select with a search field over the options.

- Category: Overlays
- Widgets: `CairnCombobox`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnCombobox<String>(
  value: _value,
  placeholder: 'Select a framework',
  searchPlaceholder: 'Search frameworks...',
  options: frameworks,
  onChanged: (String v) => setState(() => _value = v),
)
```

## API

### `CairnCombobox` (widget)

A searchable select: a Popover holding a filterable command list.

Like the Date Picker, this is a composition rather than a new primitive: a
Popover holding a Command list, triggered by an outline Button that shows
the chosen label and a `chevrons-up-down` glyph at 50% opacity. Cairn ships
it assembled, because the real work is the focus and dismissal handoff
between the three parts, not the parts themselves.

Filtering, highlight-follows-keyboard and Enter-to-choose all behave as in
[CairnCommand], because a combobox is really a command palette bound to a
value.

```dart
CairnCombobox<String>(
  value: framework,
  options: const [
    CairnSelectOption(value: 'flutter', label: 'Flutter'),
    CairnSelectOption(value: 'svelte', label: 'Svelte'),
  ],
  onChanged: (v) => setState(() => framework = v),
);
```

**Constructor** `CairnCombobox({required List<CairnSelectOption<T>> options, T? value, ValueChanged<T>? onChanged, String placeholder = 'Select...', String searchPlaceholder = 'Search...', String emptyMessage = 'No results found.', double width = 240.0, double maxMenuHeight = 280.0, bool hasError = false})`

Creates a combobox.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `options` | `List<CairnSelectOption<T>>` | yes |  | The available options. |
| `value` | `T?` |  |  | The selected value. |
| `onChanged` | `ValueChanged<T>?` |  |  | Called when an option is chosen. |
| `placeholder` | `String` |  | `'Select...'` | The trigger's text when nothing is selected. |
| `searchPlaceholder` | `String` |  | `'Search...'` | The search field's placeholder. |
| `emptyMessage` | `String` |  | `'No results found.'` | Shown when the filter matches nothing. |
| `width` | `double` |  | `240.0` | The trigger width. The menu matches it. |
| `maxMenuHeight` | `double` |  | `280.0` | How tall the option list may grow. |
| `hasError` | `bool` |  | `false` | Marks the control invalid. |


---

# Command

A Ctrl+K palette with grouping and keyword matching.

- Category: Overlays
- Widgets: `CairnCommand`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Focus stays in the input while arrow keys move a highlight through the list — the list itself is never focused, so typing and navigating never compete for the same keystrokes.

## Quick start

```dart
showCairnCommandPalette(
  context: context,
  items: <CairnCommandItem>[
    CairnCommandItem(
      label: 'New project',
      group: 'Actions',
      shortcut: 'Ctrl+N',
      onSelected: _newProject,
    ),
    CairnCommandItem(
      label: 'Sign out',
      group: 'Account',
      keywords: const <String>['logout'],
      onSelected: _signOut,
    ),
  ],
)
```

## API

### `CairnCommandItem`

One entry in a [CairnCommand] palette.

**Constructor** `CairnCommandItem({required String label, required VoidCallback onSelected, String? group, Widget? icon, String? shortcut, List<String> keywords = const <String>[]})`

Creates a command item.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The item's visible label. |
| `onSelected` | `VoidCallback` | yes |  | Invoked when the item is chosen. |
| `group` | `String?` |  |  | An optional group heading this item belongs under. |
| `icon` | `Widget?` |  |  | An optional leading icon. |
| `shortcut` | `String?` |  |  | A trailing keyboard hint. |
| `keywords` | `List<String>` |  | `const <String>[]` | Extra terms that should match this item during filtering. Lets an item be found by a synonym it doesn't display — "Sign out" can be found by typing "logout". |

**Members**

- `bool matches(String query)` — Whether this item matches [query].

### `CairnCommand` (widget)

A searchable command palette.

The shell is `flex h-full w-full flex-col overflow-hidden rounded-md
bg-popover text-popover-foreground`. The search row is `flex h-9 items-center
gap-2 border-b px-3` with a `size-4 opacity-50` magnifier, the list is
`max-h-[300px] overflow-y-auto`, and the empty state is `py-6 text-center
text-sm`.

## Keyboard model

Focus stays in the input at all times; arrow keys move a *highlight*
through the list instead of moving focus itself, so typing and
navigating never fight each other. Arrow keys and Enter are intercepted
above the text field to make this work.

```dart
showCairnCommandPalette(
  context: context,
  items: [
    CairnCommandItem(
      label: 'New file',
      group: 'Actions',
      shortcut: 'Ctrl+N',
      onSelected: () {},
    ),
  ],
);
```

**Constructor** `CairnCommand({required List<CairnCommandItem> items, String placeholder = 'Type a command or search...', String emptyMessage = 'No results found.', double maxListHeight = 300.0, VoidCallback? onDismiss, bool autofocus = true})`

Creates a command palette body.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnCommandItem>` | yes |  | The available commands. |
| `placeholder` | `String` |  | `'Type a command or search...'` | The search field's placeholder. |
| `emptyMessage` | `String` |  | `'No results found.'` | Shown when nothing matches. |
| `maxListHeight` | `double` |  | `300.0` | `max-h-[300px]`. |
| `onDismiss` | `VoidCallback?` |  |  | Called after an item is chosen, or on Escape. |
| `autofocus` | `bool` |  | `true` | Whether the search field takes focus immediately. |

### `showCairnCommandPalette()` (function)

`Future<void> showCairnCommandPalette({required BuildContext context, required List<CairnCommandItem> items, String placeholder = 'Type a command or search...', String emptyMessage = 'No results found.'})`

Shows a [CairnCommand] as a centred modal.

The palette already carries its own chrome — border, radius, popover
surface — so the dialog around it contributes only the scrim and the
centring, with no padding of its own.


---

