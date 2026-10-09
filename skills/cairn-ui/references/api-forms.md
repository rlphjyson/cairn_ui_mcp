# Forms components: API

Exact public API for each component, generated from cairn_ui 0.2.0. Import: `import 'package:cairn_ui/cairn_ui.dart';`

# Button

Six variants across eight sizes, with icon and loading forms.

- Category: Forms
- Widgets: `CairnButton`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Heights are h-6 / h-8 / h-9 / h-10 — 24, 32, 36 and 40 logical pixels. The outline variant gains a dark:bg-input/30 fill that has no light-mode counterpart.

## Quick start

```dart
CairnButton(
  variant: CairnButtonVariant.outline,
  size: CairnButtonSize.md,
  onPressed: () => _deploy(),
  child: const Text('Deploy'),
)

CairnButton.icon(
  icon: const CairnIcon(CairnIconData.check),
  semanticLabel: 'Confirm',
  onPressed: _confirm,
)
```

## API

### `CairnButton` (widget)

A button with six variants and eight sizes.

The default size is 36 logical pixels tall with 16px of horizontal padding
(`h-9 px-4`), and its label is 14px at weight 500 (`text-sm font-medium`) —
a scale that keeps a row of buttons in line with 14px body text. Variants
are [CairnButtonVariant], sizes [CairnButtonSize].

```dart
CairnButton(
  onPressed: () => print('tapped'),
  child: const Text('Continue'),
);

CairnButton(
  variant: CairnButtonVariant.outline,
  size: CairnButtonSize.sm,
  leading: const Icon(Icons.add),
  onPressed: () {},
  child: const Text('Add item'),
);
```

## Accessibility

The button is a focusable [Semantics] button, activates on both Space and
Enter, and shows its focus ring only on keyboard focus — see
[CairnInteractive] for how `:focus-visible` is reproduced. Passing null to
[onPressed] disables it, which removes it from focus traversal and drops its
opacity to 50%.

**Constructor** `CairnButton({required Widget child, VoidCallback? onPressed, VoidCallback? onLongPress, CairnButtonVariant variant = CairnButtonVariant.primary, CairnButtonSize size = CairnButtonSize.md, Widget? leading, Widget? trailing, FocusNode? focusNode, bool autofocus = false, String? semanticLabel, bool expand = false})`

Creates a button.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The button's label, or its icon when built with [CairnButton.icon]. |
| `onPressed` | `VoidCallback?` |  |  | Called when the button is activated. Null disables the button. |
| `onLongPress` | `VoidCallback?` |  |  | Called on long press. |
| `variant` | `CairnButtonVariant` |  | `CairnButtonVariant.primary` | The visual style. |
| `size` | `CairnButtonSize` |  | `CairnButtonSize.md` | The size. |
| `leading` | `Widget?` |  |  | An icon placed before [child], separated by the size's `gap`. |
| `trailing` | `Widget?` |  |  | An icon placed after [child], separated by the size's `gap`. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |
| `semanticLabel` | `String?` |  |  | The accessible name. Required for [CairnButton.icon]. |
| `expand` | `bool` |  | `false` | Whether to stretch to the available width. Cairn exposes this as an explicit flag rather than folding it into [CairnButtonSize], since width is orthogonal to height and padding: any of the eight sizes can stretch, and none of them implies it. |

**Constructor** `CairnButton.icon({required Widget icon, required String semanticLabel, VoidCallback? onPressed, VoidCallback? onLongPress, CairnButtonVariant variant = CairnButtonVariant.primary, CairnButtonSize size = CairnButtonSize.iconMd, FocusNode? focusNode, bool autofocus = false})`

Creates an icon-only button.

Uses a square size and applies [semanticLabel] as the accessible name.
The label is a required parameter, not an optional one: an icon-only
button has no visible text for a screen reader to fall back on, and
making it required is the only reliable way to stop that being
forgotten.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `icon` | `Widget` | yes |  |  |
| `semanticLabel` | `String` | yes |  | The accessible name. Required for [CairnButton.icon]. |
| `onPressed` | `VoidCallback?` |  |  | Called when the button is activated. Null disables the button. |
| `onLongPress` | `VoidCallback?` |  |  | Called on long press. |
| `variant` | `CairnButtonVariant` |  | `CairnButtonVariant.primary` | The visual style. |
| `size` | `CairnButtonSize` |  | `CairnButtonSize.iconMd` | The size. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |

### `CairnButtonVariant` (enum)

The visual style of a [CairnButton].

Six deliberate variants, each mapped to a semantic slot in [CairnTheme]
rather than to a fixed colour — so retheming moves all of them together, and
the choice between them stays a statement about emphasis rather than about
paint.

- `CairnButtonVariant.primary` — `bg-primary text-primary-foreground hover:bg-primary/90`.
- `CairnButtonVariant.destructive` — `bg-destructive text-white hover:bg-destructive/90`. The dark theme softens the fill to 60% (`dark:bg-destructive/60`): full-strength red against a dark page reads as an alarm rather than as a button.
- `CairnButtonVariant.outline` — `border bg-background shadow-xs hover:bg-accent`. The dark theme adds a translucent fill (`dark:bg-input/30`) that has no light-mode counterpart.
- `CairnButtonVariant.secondary` — `bg-secondary text-secondary-foreground hover:bg-secondary/80`.
- `CairnButtonVariant.ghost` — `hover:bg-accent hover:text-accent-foreground`, no fill at rest.
- `CairnButtonVariant.link` — `text-primary underline-offset-4 hover:underline`.

### `CairnButtonSize` (enum)

The size of a [CairnButton].

Four sizes for buttons with a label and four square sizes for icon-only
ones. The icon sizes are separate entries rather than a flag on the others,
because a square button is not simply a text button with the label removed
— it drops horizontal padding entirely and takes its width from its
height.

- `CairnButtonSize.xs` — `h-6 gap-1 px-2 text-xs` with 12px icons.
- `CairnButtonSize.sm` — `h-8 gap-1.5 px-3`.
- `CairnButtonSize.md` — `h-9 px-4 py-2` — the default.
- `CairnButtonSize.lg` — `h-10 px-6`.
- `CairnButtonSize.iconXs` — `size-6` — square, icon only.
- `CairnButtonSize.iconSm` — `size-8` — square, icon only.
- `CairnButtonSize.iconMd` — `size-9` — square, icon only.
- `CairnButtonSize.iconLg` — `size-10` — square, icon only.


---

# Input

A single-line text field with leading and trailing slots.

- Category: Forms
- Widgets: `CairnInput`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> h-9, px-3, rounded-md, bg-transparent with a shadow-xs resting elevation. Focus adds a 3px ring at 50% alpha.

## Quick start

```dart
CairnInput(
  controller: _email,
  placeholder: 'name@example.com',
  keyboardType: TextInputType.emailAddress,
  hasError: _error != null,
  onChanged: _validate,
)
```

## API

### `CairnInput` (widget)

A single-line text field.

36 logical pixels tall (`h-9`) with 12px of horizontal padding, an 8px
radius, a 1px outline in the input token and the smallest shadow in the
scale — the same height as the default Button, so the two sit level in a
form row. Focus swaps the border to the ring colour and adds a 3px outset at
50% alpha. The dark theme adds a translucent fill that light mode does not
have, since a hairline alone barely separates a field from a dark page.

## Implementation note

This wraps Flutter's [TextField] with [InputDecoration.collapsed] rather
than rebuilding text editing on [EditableText]. Text input is deceptively
deep — selection handles, the context menu, autofill, IME composition,
spell check and platform-specific caret behaviour — and reimplementing it
would mean losing all of it. Cairn replaces only the *chrome*: the Material
border, fill and floating label are stripped, and the visual shell is drawn
by this widget instead.

```dart
CairnInput(
  controller: controller,
  placeholder: 'name@example.com',
  keyboardType: TextInputType.emailAddress,
);
```

**Constructor** `CairnInput({TextEditingController? controller, FocusNode? focusNode, String? placeholder, bool enabled = true, bool readOnly = false, bool obscureText = false, bool autofocus = false, bool hasError = false, TextInputType? keyboardType, TextInputAction? textInputAction, List<TextInputFormatter>? inputFormatters, int? maxLength, ValueChanged<String>? onChanged, ValueChanged<String>? onSubmitted, Widget? leading, Widget? trailing, String? semanticLabel})`

Creates a text input.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `controller` | `TextEditingController?` |  |  | Controls the text being edited. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `placeholder` | `String?` |  |  | Text shown when the field is empty (`placeholder:text-muted-foreground`). |
| `enabled` | `bool` |  | `true` | Whether the field accepts input. |
| `readOnly` | `bool` |  | `false` | Whether the field is read-only. |
| `obscureText` | `bool` |  | `false` | Whether to hide the text, for passwords. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |
| `hasError` | `bool` |  | `false` | Marks the field invalid (`aria-invalid`), switching the border and ring to the destructive token. |
| `keyboardType` | `TextInputType?` |  |  | The keyboard type. |
| `textInputAction` | `TextInputAction?` |  |  | The keyboard action button. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Input formatters applied as the user types. |
| `maxLength` | `int?` |  |  | The maximum number of characters. |
| `onChanged` | `ValueChanged<String>?` |  |  | Called whenever the text changes. |
| `onSubmitted` | `ValueChanged<String>?` |  |  | Called when the user submits. |
| `leading` | `Widget?` |  |  | A widget before the text, such as a search icon. |
| `trailing` | `Widget?` |  |  | A widget after the text. |
| `semanticLabel` | `String?` |  |  | The accessible name. |


---

# Textarea

A multi-line field that grows with its content.

- Category: Forms
- Widgets: `CairnTextarea`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Auto-growing by default, matching CSS field-sizing: content, which Flutter has no direct equivalent for.

## Quick start

```dart
CairnTextarea(
  controller: _bio,
  placeholder: 'Tell us a little about yourself...',
  minLines: 3,
)
```

## API

### `CairnTextarea` (widget)

A multi-line text field.

`min-h-16 w-full rounded-md border border-input bg-transparent px-3 py-2
text-sm shadow-xs` — a 64 logical pixel minimum height with 12px horizontal
and 8px vertical padding.

The box grows with its content rather than making the user scroll inside a
fixed frame — the web spells that `field-sizing-content`; in Flutter it is
[TextField] with a null `maxLines`, which is what [autoGrow] enables.

```dart
CairnTextarea(
  controller: controller,
  placeholder: 'Tell us what happened...',
  minLines: 3,
);
```

**Constructor** `CairnTextarea({TextEditingController? controller, FocusNode? focusNode, String? placeholder, bool enabled = true, bool readOnly = false, bool autofocus = false, bool hasError = false, bool autoGrow = true, int? minLines, int? maxLines, int? maxLength, List<TextInputFormatter>? inputFormatters, ValueChanged<String>? onChanged, String? semanticLabel})`

Creates a multi-line text field.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `controller` | `TextEditingController?` |  |  | Controls the text being edited. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `placeholder` | `String?` |  |  | Text shown when empty. |
| `enabled` | `bool` |  | `true` | Whether the field accepts input. |
| `readOnly` | `bool` |  | `false` | Whether the field is read-only. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |
| `hasError` | `bool` |  | `false` | Marks the field invalid, switching the border and ring to destructive. |
| `autoGrow` | `bool` |  | `true` | Whether the box grows with its content (`field-sizing-content`). |
| `minLines` | `int?` |  |  | The minimum number of visible lines. |
| `maxLines` | `int?` |  |  | The maximum number of visible lines before scrolling. Ignored when [autoGrow] is true. |
| `maxLength` | `int?` |  |  | The maximum number of characters. |
| `inputFormatters` | `List<TextInputFormatter>?` |  |  | Input formatters applied as the user types. |
| `onChanged` | `ValueChanged<String>?` |  |  | Called whenever the text changes. |
| `semanticLabel` | `String?` |  |  | The accessible name. |


---

# Label

A form label with leading-none and a disabled treatment.

- Category: Forms
- Widgets: `CairnLabel`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> line-height: 1 has to be set explicitly — Flutter defaults to the font metrics (~1.2), which makes labels sit low.

## Quick start

```dart
const CairnLabel('Accept terms and conditions')

CairnLabel.custom(
  child: Row(children: const <Widget>[Text('Email'), Text('*')]),
)
```

## API

### `CairnLabel` (widget)

A form label.

`flex items-center gap-2 text-sm leading-none font-medium select-none`.

Note `leading-none`: the label's line height is exactly 1.0, not the font's
natural metric. Flutter's default line height comes from font metrics
(~1.2), so this must be set explicitly or a label sits a pixel or two low
relative to the control it labels.

Setting [enabled] to false drops the label to 50% opacity, so a disabled
control and its label read as one inert unit rather than a live label above
a dead field.

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  spacing: 8,
  children: [
    const CairnLabel('Email'),
    CairnInput(controller: controller),
  ],
);
```

**Constructor** `CairnLabel(String? text, {bool enabled = true})`

Creates a label from a string.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `text` | `String?` | yes |  | The label text, when built with the default constructor. |
| `enabled` | `bool` |  | `true` | Whether the labelled control is enabled. False dims the label to 50%. |

**Constructor** `CairnLabel.custom({required Widget child, bool enabled = true})`

Creates a label wrapping arbitrary content, such as text plus a badge.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | A custom label body, when built with [CairnLabel.custom]. |
| `enabled` | `bool` |  | `true` | Whether the labelled control is enabled. False dims the label to 50%. |


---

# Checkbox

A checkbox with optional indeterminate state.

- Category: Forms
- Widgets: `CairnCheckbox`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The radius is a literal rounded-[4px], not a step on the --radius scale.

## Quick start

```dart
CairnCheckbox(
  value: _accepted,
  tristate: true,
  onChanged: (bool? v) => setState(() => _accepted = v),
)
```

## API

### `CairnCheckbox` (widget)

A checkbox, optionally with an indeterminate third state.

`size-4 shrink-0 rounded-[4px] border border-input shadow-xs` — 16 logical
pixels square with a 4px radius. That radius is a **literal 4px**, not a
step on the radius scale, so it holds even when a theme retunes its base: at
16px square, a proportionally scaled radius would round the box into a
blob.

Checking swaps to `bg-primary border-primary text-primary-foreground` and
draws a 14px (`size-3.5`) check.

Supports a tristate (indeterminate) value, rendered as a minus instead of a
check — the state a "select all" box needs when only some of the boxes it
governs are ticked.

```dart
CairnCheckbox(
  value: accepted,
  onChanged: (v) => setState(() => accepted = v ?? false),
);
```

**Constructor** `CairnCheckbox({required bool? value, ValueChanged<bool?>? onChanged, bool tristate = false, bool hasError = false, FocusNode? focusNode, bool autofocus = false, String? semanticLabel})`

Creates a checkbox.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `bool?` | yes |  | Whether the box is checked. Null means indeterminate when [tristate] is true. |
| `onChanged` | `ValueChanged<bool?>?` |  |  | Called with the next value when the user toggles the box. Null disables the checkbox. |
| `tristate` | `bool` |  | `false` | Whether the box cycles through an indeterminate state. |
| `hasError` | `bool` |  | `false` | Marks the control invalid (`aria-invalid`). |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |
| `semanticLabel` | `String?` |  |  | The accessible name. |


---

# Switch

A binary toggle with an animated thumb.

- Category: Forms
- Widgets: `CairnSwitch`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The track is h-[1.15rem] w-8 — literally 18.4 x 32 logical pixels. Rounding that to 18 or 20 is exactly the drift Cairn exists to avoid.

## Quick start

```dart
CairnSwitch(
  value: _notifications,
  semanticLabel: 'Email notifications',
  onChanged: (bool v) => setState(() => _notifications = v),
)
```

## API

### `CairnSwitch` (widget)

A switch.

The default track is `h-[1.15rem] w-8` — **18.4 logical pixels** tall, not
a round number, and deliberately so. The height is derived rather than
chosen: a 16px thumb has to clear the 1px transparent border on both sides
with a hair of room, and 18.4 is where that lands. Rounding it to 18 pinches
the thumb; rounding it to 20 leaves it swimming.

The thumb travels `translate-x-[calc(100%-2px)]` when checked — its own
width minus 2px, so 14 logical pixels at the default size.

The dark theme inverts the thumb: unchecked it is `bg-foreground`, checked
it is `bg-primary-foreground`, whereas light mode keeps it `bg-background`
throughout.

```dart
CairnSwitch(
  value: notifications,
  onChanged: (v) => setState(() => notifications = v),
);
```

**Constructor** `CairnSwitch({required bool value, ValueChanged<bool>? onChanged, CairnSwitchSize size = CairnSwitchSize.md, FocusNode? focusNode, bool autofocus = false, String? semanticLabel})`

Creates a switch.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `bool` | yes |  | Whether the switch is on. |
| `onChanged` | `ValueChanged<bool>?` |  |  | Called with the next value. Null disables the switch. |
| `size` | `CairnSwitchSize` |  | `CairnSwitchSize.md` | The size. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnSwitchSize` (enum)

The size of a [CairnSwitch].

- `CairnSwitchSize.sm` — `h-3.5 w-6` with a `size-3` thumb — 14 x 24 with a 12px thumb.
- `CairnSwitchSize.md` — `h-[1.15rem] w-8` with a `size-4` thumb — 18.4 x 32 with a 16px thumb.


---

# Radio Group

Mutually exclusive options with roving focus.

- Category: Forms
- Widgets: `CairnRadioGroup`, `CairnRadioItem`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> One tab stop for the whole group; arrow keys move the selection within it, as the ARIA radio-group pattern requires.

## Quick start

```dart
CairnRadioGroup<String>(
  value: _plan,
  onChanged: (String v) => setState(() => _plan = v),
  children: const <Widget>[
    CairnRadioItem<String>(value: 'free', label: Text('Free')),
    CairnRadioItem<String>(value: 'pro', label: Text('Pro')),
  ],
)
```

## API

### `CairnRadioGroup` (widget)

A group of mutually exclusive radio buttons.

The group itself is `grid gap-3` — a 12 logical pixel gap between items.

## Accessibility

The group uses **roving focus**: it holds a single tab stop, and arrow keys
move the selection within it. Cairn implements that with a
[FocusTraversalGroup] plus arrow-key [Shortcuts], so tabbing lands on the
group once instead of stepping through every option — which is both the
accessible behaviour and what makes a ten-option group survivable from the
keyboard.

```dart
CairnRadioGroup<String>(
  value: plan,
  onChanged: (v) => setState(() => plan = v),
  children: const [
    CairnRadioItem(value: 'free', label: Text('Free')),
    CairnRadioItem(value: 'pro', label: Text('Pro')),
  ],
);
```

**Constructor** `CairnRadioGroup({required T? value, required List<Widget> children, ValueChanged<T>? onChanged, double spacing = CairnSpacing.s3, String? semanticLabel})`

Creates a radio group.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `T?` | yes |  | The currently selected value. |
| `children` | `List<Widget>` | yes |  | The items in this group. Typically [CairnRadioItem]s. |
| `onChanged` | `ValueChanged<T>?` |  |  | Called when the selection changes. Null disables the whole group. |
| `spacing` | `double` |  | `CairnSpacing.s3` | The gap between items (`gap-3`). |
| `semanticLabel` | `String?` |  |  | The accessible name for the group. |

### `CairnRadioItem` (widget)

One option inside a [CairnRadioGroup].

The control is `aspect-square size-4 rounded-full border border-input
shadow-xs` with a `size-2 fill-primary` dot when selected — a 16px circle
containing an 8px filled dot.

**Constructor** `CairnRadioItem({required T value, Widget? label, bool enabled = true, FocusNode? focusNode, String? semanticLabel})`

Creates a radio item.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `T` | yes |  | The value this item selects. |
| `label` | `Widget?` |  |  | An optional label rendered beside the control. |
| `enabled` | `bool` |  | `true` | Whether this individual item is selectable. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `semanticLabel` | `String?` |  |  | The accessible name. Falls back to [label] when that is a [Text]. |


---

# Slider

A range control driven by pointer or keyboard.

- Category: Forms
- Widgets: `CairnSlider`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The thumb is a literal bg-white in both themes, and the focus halo is ring-4 rather than the usual 3px.

## Quick start

```dart
CairnSlider(
  value: _volume,
  min: 0,
  max: 1,
  step: 0.05,
  semanticLabel: 'Volume',
  onChanged: (double v) => setState(() => _volume = v),
)
```

## API

### `CairnSlider` (widget)

A value slider.

The track is `h-1.5 rounded-full bg-muted` (6 logical pixels), the filled
range is `bg-primary`, and the thumb is `size-4 rounded-full border
border-primary bg-white shadow-sm` — 16 logical pixels.

The thumb's fill is a literal white, **not** a token, so it stays white in
dark mode too. Mapping it to the background token would be the reflexive
choice and the wrong one: it would turn the thumb near-black on a dark page,
where it has to read as a control sitting on top of the track rather than a
hole punched through it.

Hover and keyboard focus both grow a `ring-4` (4px) halo at `ring-ring/50`
— note this is 4px, not the 3px ring the rest of the library uses.

## Accessibility

Arrow keys move by [step], Home and End jump to the bounds, and the
[Semantics] node exposes increase/decrease actions so screen readers can
drive it.

```dart
CairnSlider(
  value: volume,
  onChanged: (v) => setState(() => volume = v),
);
```

**Constructor** `CairnSlider({required double value, ValueChanged<double>? onChanged, ValueChanged<double>? onChangeEnd, double min = 0.0, double max = 1.0, double? step, FocusNode? focusNode, String? semanticLabel})`

Creates a slider.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `double` | yes |  | The current value, between [min] and [max]. |
| `onChanged` | `ValueChanged<double>?` |  |  | Called continuously as the user drags. Null disables the slider. |
| `onChangeEnd` | `ValueChanged<double>?` |  |  | Called once when a drag or keyboard interaction finishes. |
| `min` | `double` |  | `0.0` | The lower bound. |
| `max` | `double` |  | `1.0` | The upper bound. |
| `step` | `double?` |  |  | The increment for arrow keys and drag snapping. Null means continuous, with arrow keys moving by 1% of the range. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

**Static members**

- `double trackHeight = 6.0` — `h-1.5`.
- `double thumbSize = 16.0` — `size-4`.
- `double ringWidth = 4.0` — `hover:ring-4` / `focus-visible:ring-4` — wider than the usual 3px.


---

# Toggle

A button that stays pressed.

- Category: Forms
- Widgets: `CairnToggle`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnToggle(
  value: _bold,
  variant: CairnToggleVariant.outline,
  onChanged: (bool v) => setState(() => _bold = v),
  child: const Text('Bold'),
)
```

## API

### `CairnToggle` (widget)

A two-state button.

`rounded-md text-sm font-medium hover:bg-muted hover:text-muted-foreground`,
switching to `bg-accent text-accent-foreground` when on.

Note the sizes use `min-w-*` rather than a fixed width, so a toggle holding
only an icon is square but one holding text grows — reproduced here with
[BoxConstraints.minWidth].

```dart
CairnToggle(
  value: bold,
  onChanged: (v) => setState(() => bold = v),
  child: const Text('B'),
);
```

**Constructor** `CairnToggle({required bool value, required Widget child, ValueChanged<bool>? onChanged, CairnToggleVariant variant = CairnToggleVariant.normal, CairnToggleSize size = CairnToggleSize.md, FocusNode? focusNode, String? semanticLabel})`

Creates a toggle.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `bool` | yes |  | Whether the toggle is on. |
| `child` | `Widget` | yes |  | The toggle's content. |
| `onChanged` | `ValueChanged<bool>?` |  |  | Called with the next value. Null disables the toggle. |
| `variant` | `CairnToggleVariant` |  | `CairnToggleVariant.normal` | The visual style. |
| `size` | `CairnToggleSize` |  | `CairnToggleSize.md` | The size. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnToggleVariant` (enum)

The visual style of a [CairnToggle].

- `CairnToggleVariant.normal` — `bg-transparent` — no border or fill at rest.
- `CairnToggleVariant.outline` — `border border-input bg-transparent shadow-xs`.

### `CairnToggleSize` (enum)

The size of a [CairnToggle].

- `CairnToggleSize.sm` — `h-8 min-w-8 px-1.5`.
- `CairnToggleSize.md` — `h-9 min-w-9 px-2`.
- `CairnToggleSize.lg` — `h-10 min-w-10 px-2.5`.


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

# Input OTP

A grouped one-time-code field.

- Category: Forms
- Widgets: `CairnInputOtp`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> One hidden text field sits behind painted slots, so paste and SMS autofill keep working. Only the first slot draws a left border, which avoids doubled hairlines.

## Quick start

```dart
CairnInputOtp(
  length: 6,
  groupSizes: const <int>[3, 3],
  onCompleted: _verify,
)
```

## API

### `CairnInputOtp` (widget)

A one-time-code field.

Each slot is `h-9 w-9 border-y border-r border-input text-sm shadow-xs`,
with `first:rounded-l-md first:border-l last:rounded-r-md` — so the group
reads as a single joined control with **no doubled borders** between slots,
which is what the `border-r`-only rule achieves.

The active slot gets `border-ring ring-[3px] ring-ring/50` and shows a
blinking caret (`h-4 w-px animate-caret-blink duration-1000`).

## Implementation note

This is a single hidden [EditableText] behind a row of painted slots, not
one field per digit. Per-digit fields break paste, break the platform's SMS
autofill, and make backspace behave strangely — all of which the real
`input-otp` library also avoids by using one input.

```dart
CairnInputOtp(
  length: 6,
  onCompleted: (code) => verify(code),
);
```

**Constructor** `CairnInputOtp({int length = 6, TextEditingController? controller, FocusNode? focusNode, ValueChanged<String>? onChanged, ValueChanged<String>? onCompleted, bool enabled = true, bool hasError = false, List<int>? groupSizes, bool autofocus = false})`

Creates a one-time-code field.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `length` | `int` |  | `6` | How many digits the code has. |
| `controller` | `TextEditingController?` |  |  | Controls the entered value. |
| `focusNode` | `FocusNode?` |  |  | An externally supplied focus node. |
| `onChanged` | `ValueChanged<String>?` |  |  | Called whenever the value changes. |
| `onCompleted` | `ValueChanged<String>?` |  |  | Called once the full code has been entered. |
| `enabled` | `bool` |  | `true` | Whether input is accepted. |
| `hasError` | `bool` |  | `false` | Marks the control invalid. |
| `groupSizes` | `List<int>?` |  |  | Optional slot grouping, e.g. `[3, 3]` renders `123-456` with a gap. Must sum to [length]. Null renders one continuous group. |
| `autofocus` | `bool` |  | `false` | Whether to take focus on first build. |


---

# Form Field

Label, description and error layout around any control.

- Category: Forms
- Widgets: `CairnFormField`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Layout only. Flutter already ships Form and FormField for validation; competing with them would fight the framework.

## Quick start

```dart
CairnFormField(
  label: 'Email',
  description: 'We will never share it.',
  error: _error,
  child: CairnInput(controller: _email, hasError: _error != null),
)
```

## API

### `CairnFormField` (widget)

A labelled form row: label, control, description and error message.

The row is an 8px-gapped stack: a label that turns destructive when the
field is invalid, the control itself, a muted description, and the
validation message in its place.

Cairn deliberately ships the **layout wrapper only** and no validation
engine. Flutter already has [Form] and [FormField] with validators, and a
component library that invented a competing one would be fighting the
framework. [CairnFormField] therefore takes an [error] string that the
caller supplies from whatever state management it already uses.

```dart
CairnFormField(
  label: 'Email',
  description: 'We will never share it.',
  error: emailError,
  child: CairnInput(controller: controller, hasError: emailError != null),
);
```

**Constructor** `CairnFormField({required Widget child, String? label, String? description, String? error, bool enabled = true})`

Creates a form field row.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The control this row wraps. |
| `label` | `String?` |  |  | The field's label. |
| `description` | `String?` |  |  | Helper text shown below the control when there is no [error]. |
| `error` | `String?` |  |  | The validation error. Non-null switches the label to the destructive token and replaces [description]. |
| `enabled` | `bool` |  | `true` | Whether the control is enabled; false dims the label. |


---

# Rating

A star rating with half steps and keyboard control.

- Category: Forms
- Widgets: `CairnRating`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> A null onChanged makes it read-only. Arrow keys, Home and End step the value.

## Quick start

```dart
CairnRating(
  value: _rating,
  allowHalf: true,
  onChanged: (double v) => setState(() => _rating = v),
)
```

## API

### `CairnRating` (widget)

A star rating input and display.

A row of 20px stars with a 2px gap. Filled stars take the [tone] colour
(amber by default, the conventional star colour) and empty ones the
`border` token's stroke. With [onChanged] null the rating is read-only —
no hover, no focus, no cursor change — which is the right default for
showing an aggregate score.

Fractional [value]s (a 3.5 average) paint a half star. The input itself
only produces whole values, or halves when [allowHalf] is set.

Keyboard: arrow keys step the value by one (or a half), Home and End jump
to zero and [count].

```dart
CairnRating(value: _stars, onChanged: (v) => setState(() => _stars = v));
```

**Constructor** `CairnRating({required double value, ValueChanged<double>? onChanged, int count = 5, double size = 20.0, bool allowHalf = false, CairnTone tone = CairnTone.warning, String semanticLabel = 'Rating'})`

Creates a rating.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `double` | yes |  | The current rating, from 0 to [count]. |
| `onChanged` | `ValueChanged<double>?` |  |  | Called with the new rating. Null makes the rating read-only. |
| `count` | `int` |  | `5` | How many stars. |
| `size` | `double` |  | `20.0` | The star size. |
| `allowHalf` | `bool` |  | `false` | Whether the input can produce half-star values. |
| `tone` | `CairnTone` |  | `CairnTone.warning` | The filled-star colour. |
| `semanticLabel` | `String` |  | `'Rating'` | The accessible name. |


---

# Swap

A controlled two-face toggle with fade, rotate and flip.

- Category: Forms
- Widgets: `CairnSwap`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnSwap(
  effect: CairnSwapEffect.rotate,
  value: _on,
  onChanged: (bool v) => setState(() => _on = v),
  on: const CairnIcon(CairnIconData.check),
  off: const CairnIcon(CairnIconData.plus),
)
```

## API

### `CairnSwap` (widget)

A toggle that swaps between two widgets — a hamburger and a close icon, a
sun and a moon, a play and a pause.

Tapping (or pressing Space / Enter when focused) calls [onChanged] with the
opposite of [value]. The control is controlled: it shows [on] when [value] is
true and [off] otherwise, and animates between them at 200ms on the standard
curve using the chosen [effect].

```dart
CairnSwap(
  value: _open,
  onChanged: (v) => setState(() => _open = v),
  effect: CairnSwapEffect.rotate,
  on: const CairnIcon(CairnIconData.close),
  off: const CairnIcon(CairnIconData.moreHorizontal),
  semanticLabel: 'Toggle menu',
);
```

**Constructor** `CairnSwap({required bool value, required Widget on, required Widget off, ValueChanged<bool>? onChanged, CairnSwapEffect effect = CairnSwapEffect.fade, String? semanticLabel})`

Creates a swap.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `bool` | yes |  | Whether [on] is showing. |
| `on` | `Widget` | yes |  | The face shown when [value] is true. |
| `off` | `Widget` | yes |  | The face shown when [value] is false. |
| `onChanged` | `ValueChanged<bool>?` |  |  | Called with the new value on tap. Null makes the swap inert. |
| `effect` | `CairnSwapEffect` |  | `CairnSwapEffect.fade` | The transition style. |
| `semanticLabel` | `String?` |  |  | The accessible name. |

### `CairnSwapEffect` (enum)

How a [CairnSwap] animates between its two faces.

- `CairnSwapEffect.fade` — Cross-fade.
- `CairnSwapEffect.rotate` — Rotate a quarter turn while fading — a menu icon becoming a close icon.
- `CairnSwapEffect.flip` — Flip around the vertical axis.


---

# File Input

A file field that draws the control and leaves picking to you.

- Category: Forms
- Widgets: `CairnFileInput`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Cairn takes no dependencies, so wire onBrowse to file_picker or a web input.

## Quick start

```dart
CairnFileInput(
  fileName: _file,
  onBrowse: _pickFile,
  onClear: () => setState(() => _file = null),
)
```

## API

### `CairnFileInput` (widget)

A file picker control with the same footprint as [CairnInput].

`h-9 w-full rounded-md border border-input px-3 text-sm shadow-xs` with a
"Choose file" segment on the left and the selected [fileName] (or the
[placeholder]) beside it, so it lines up in a form column with every other
field.

Cairn deliberately has no dependencies, so this widget draws the control but
does not open a system picker: [onBrowse] is where you call
`file_picker`, `image_picker` or a web `<input type=file>`. Report the choice
back by setting [fileName]; pass [onClear] to show a clear button once a
file is selected.

```dart
CairnFileInput(
  fileName: _picked?.name,
  onBrowse: () async => _picked = await pickFile(),
  onClear: () => setState(() => _picked = null),
);
```

**Constructor** `CairnFileInput({String? fileName, VoidCallback? onBrowse, VoidCallback? onClear, String placeholder = 'No file chosen', String buttonLabel = 'Choose file', bool invalid = false, String? semanticLabel})`

Creates a file input.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `fileName` | `String?` |  |  | The chosen file's name, or null when nothing is chosen. |
| `onBrowse` | `VoidCallback?` |  |  | Called to open the picker. Null disables the control. |
| `onClear` | `VoidCallback?` |  |  | Called to clear the selection. The clear button only shows when this is non-null and a file is chosen. |
| `placeholder` | `String` |  | `'No file chosen'` | Shown when [fileName] is null. |
| `buttonLabel` | `String` |  | `'Choose file'` | The label on the left-hand segment. |
| `invalid` | `bool` |  | `false` | Whether to draw the destructive outline. |
| `semanticLabel` | `String?` |  |  | The accessible name. |


---

# Floating Action Button

A round action button that can open into a speed dial.

- Category: Forms
- Widgets: `CairnFab`, `CairnFabAction`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Non-empty actions turn it into a speed dial. Position it yourself with Align or Positioned.

## Quick start

```dart
CairnFab(
  icon: const CairnIcon(CairnIconData.plus),
  semanticLabel: 'Create',
  actions: <CairnFabAction>[
    CairnFabAction(
      icon: const CairnIcon(CairnIconData.search),
      label: 'Document',
      onPressed: _newDocument,
    ),
  ],
)
```

## API

### `CairnFab` (widget)

A floating action button, optionally expanding into a speed dial.

A 56px primary-coloured circle with the large shadow, the standard
treatment for a screen's one primary action. Without [actions] it is a plain
button calling [onPressed]. With [actions] it toggles a stack of labelled
40px mini actions above it; the trigger rotates 45 degrees (so a plus
becomes a cross) and closes again after an action is picked.

Place it with `Positioned` or `Align` — it takes only its own size and
leaves placement to the caller, as Cairn's other overlays do.

```dart
CairnFab(
  icon: const CairnIcon(CairnIconData.plus),
  semanticLabel: 'Create',
  actions: [
    CairnFabAction(icon: Icon(...), label: 'Document', onPressed: () {}),
  ],
);
```

**Constructor** `CairnFab({required Widget icon, VoidCallback? onPressed, List<CairnFabAction> actions = const <CairnFabAction>[], String? semanticLabel})`

Creates a floating action button.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `icon` | `Widget` | yes |  | The trigger glyph. Draw it as a plus if you use [actions], so the open rotation reads as a close. |
| `onPressed` | `VoidCallback?` |  |  | Called on tap when there are no [actions]. |
| `actions` | `List<CairnFabAction>` |  | `const <CairnFabAction>[]` | Speed-dial entries, nearest the trigger first. |
| `semanticLabel` | `String?` |  |  | The accessible name of the trigger. |

### `CairnFabAction`

One entry of a [CairnFab] speed dial.

**Constructor** `CairnFabAction({required Widget icon, required String label, required VoidCallback onPressed})`

Creates an action.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `icon` | `Widget` | yes |  | The glyph. |
| `label` | `String` | yes |  | The label shown beside the mini button, also its accessible name. |
| `onPressed` | `VoidCallback` | yes |  | Called when picked. The dial closes afterwards. |


---

