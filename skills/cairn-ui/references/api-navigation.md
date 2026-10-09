# Navigation components: API

Exact public API for each component, generated from cairn_ui 0.2.0. Import: `import 'package:cairn_ui/cairn_ui.dart';`

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

# Accordion

Single or multiple disclosure sections.

- Category: Navigation
- Widgets: `CairnAccordion`, `CairnCollapsible`, `CairnCollapsible`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The body animates its height over 200ms on Tailwind's default ease.

## Quick start

```dart
CairnAccordion(
  expanded: _open,
  multiple: false,
  onChanged: (Set<String> v) => setState(() => _open = v),
  items: const <CairnAccordionItem>[
    CairnAccordionItem(
      value: 'a',
      title: Text('Is it accessible?'),
      content: Text('Yes. It follows the WAI-ARIA disclosure pattern.'),
    ),
  ],
)
```

## API

### `CairnAccordionItem`

One section of a [CairnAccordion].

**Constructor** `CairnAccordionItem({required String value, required Widget title, required Widget content, bool enabled = true})`

Creates an accordion section.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `String` | yes |  | A unique identifier for this section. |
| `title` | `Widget` | yes |  | The always-visible header. |
| `content` | `Widget` | yes |  | The collapsible body. |
| `enabled` | `bool` |  | `true` | Whether the section can be toggled. |

### `CairnAccordion` (widget)

A vertical stack of collapsible sections.

Each item is separated by `border-b last:border-b-0`. The trigger is
`flex flex-1 items-start justify-between gap-4 py-4 text-sm font-medium`
with a `size-4 text-muted-foreground` chevron that rotates 180 degrees over
200ms when open. The body is `pt-0 pb-4`.

Note the trigger uses `items-start`, not `items-center` — with a wrapping
multi-line title the chevron stays aligned to the first line rather than
drifting to the vertical middle. The chevron also carries
`translate-y-0.5` for optical alignment.

```dart
CairnAccordion(
  expanded: openSections,
  onChanged: (v) => setState(() => openSections = v),
  items: const [
    CairnAccordionItem(
      value: 'a',
      title: Text('Is it accessible?'),
      content: Text('Yes. It follows the WAI-ARIA pattern.'),
    ),
  ],
);
```

**Constructor** `CairnAccordion({required List<CairnAccordionItem> items, required Set<String> expanded, ValueChanged<Set<String>>? onChanged, bool multiple = false})`

Creates an accordion.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnAccordionItem>` | yes |  | The sections. |
| `expanded` | `Set<String>` | yes |  | The values of the currently open sections. |
| `onChanged` | `ValueChanged<Set<String>>?` |  |  | Called with the next open set. |
| `multiple` | `bool` |  | `false` | Whether more than one section may be open at once. Single mode closes the open section when another is opened, which keeps the control's height predictable; multiple mode lets any number of sections stand open at once. |

### `CairnCollapsible` (widget)

A single show/hide region.

This is the primitive the Accordion is built on. It carries no chrome of its
own — it only animates its child's height over the same 200ms curve — so it
drops into whatever surface the caller already has.

**Constructor** `CairnCollapsible({required bool open, required Widget child, Widget? trigger, VoidCallback? onToggle})`

Creates a collapsible region.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `open` | `bool` | yes |  | Whether the region is expanded. |
| `child` | `Widget` | yes |  | The collapsible content. |
| `trigger` | `Widget?` |  |  | An optional always-visible trigger. |
| `onToggle` | `VoidCallback?` |  |  | Called when the trigger is activated. |


---

# Collapsible

The single-section primitive underneath Accordion.

- Category: Navigation
- Widgets: `CairnAccordion`, `CairnCollapsible`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnCollapsible(
  open: _open,
  onToggle: () => setState(() => _open = !_open),
  trigger: const Text('Starred repositories'),
  child: const Text('@rlphjyson/cairn_ui'),
)
```

## API

### `CairnAccordionItem`

One section of a [CairnAccordion].

**Constructor** `CairnAccordionItem({required String value, required Widget title, required Widget content, bool enabled = true})`

Creates an accordion section.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `value` | `String` | yes |  | A unique identifier for this section. |
| `title` | `Widget` | yes |  | The always-visible header. |
| `content` | `Widget` | yes |  | The collapsible body. |
| `enabled` | `bool` |  | `true` | Whether the section can be toggled. |

### `CairnAccordion` (widget)

A vertical stack of collapsible sections.

Each item is separated by `border-b last:border-b-0`. The trigger is
`flex flex-1 items-start justify-between gap-4 py-4 text-sm font-medium`
with a `size-4 text-muted-foreground` chevron that rotates 180 degrees over
200ms when open. The body is `pt-0 pb-4`.

Note the trigger uses `items-start`, not `items-center` — with a wrapping
multi-line title the chevron stays aligned to the first line rather than
drifting to the vertical middle. The chevron also carries
`translate-y-0.5` for optical alignment.

```dart
CairnAccordion(
  expanded: openSections,
  onChanged: (v) => setState(() => openSections = v),
  items: const [
    CairnAccordionItem(
      value: 'a',
      title: Text('Is it accessible?'),
      content: Text('Yes. It follows the WAI-ARIA pattern.'),
    ),
  ],
);
```

**Constructor** `CairnAccordion({required List<CairnAccordionItem> items, required Set<String> expanded, ValueChanged<Set<String>>? onChanged, bool multiple = false})`

Creates an accordion.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnAccordionItem>` | yes |  | The sections. |
| `expanded` | `Set<String>` | yes |  | The values of the currently open sections. |
| `onChanged` | `ValueChanged<Set<String>>?` |  |  | Called with the next open set. |
| `multiple` | `bool` |  | `false` | Whether more than one section may be open at once. Single mode closes the open section when another is opened, which keeps the control's height predictable; multiple mode lets any number of sections stand open at once. |

### `CairnCollapsible` (widget)

A single show/hide region.

This is the primitive the Accordion is built on. It carries no chrome of its
own — it only animates its child's height over the same 200ms curve — so it
drops into whatever surface the caller already has.

**Constructor** `CairnCollapsible({required bool open, required Widget child, Widget? trigger, VoidCallback? onToggle})`

Creates a collapsible region.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `open` | `bool` | yes |  | Whether the region is expanded. |
| `child` | `Widget` | yes |  | The collapsible content. |
| `trigger` | `Widget?` |  |  | An optional always-visible trigger. |
| `onToggle` | `VoidCallback?` |  |  | Called when the trigger is activated. |


---

# Breadcrumb

A trail with a current-page crumb and an ellipsis form.

- Category: Navigation
- Widgets: `CairnBreadcrumb`, `CairnBreadcrumbEllipsis`, `CairnBreadcrumbEllipsis`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The current crumb is announced as the current page rather than rendered as a dead link.

## Quick start

```dart
CairnBreadcrumb(
  crumbs: <CairnCrumb>[
    CairnCrumb(label: 'Home', onTap: () => context.go('/')),
    CairnCrumb(label: 'Components', onTap: _components),
    const CairnCrumb.current(label: 'Breadcrumb'),
  ],
)
```

## API

### `CairnCrumb`

One crumb in a [CairnBreadcrumb].

**Constructor** `CairnCrumb({required String label, VoidCallback? onTap, Widget? icon})`

Creates a navigable crumb.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The crumb's text. |
| `onTap` | `VoidCallback?` |  |  | Called when the crumb is activated. Null marks it as the current page. |
| `icon` | `Widget?` |  |  | An optional leading icon. |

**Constructor** `CairnCrumb.current({required String label, Widget? icon})`

Creates the non-navigable current-page crumb.

Rendered `font-normal text-foreground` and marked `aria-current="page"`.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The crumb's text. |
| `icon` | `Widget?` |  |  | An optional leading icon. |

### `CairnBreadcrumb` (widget)

A navigation trail showing the path to the current page.

`flex flex-wrap items-center gap-1.5 text-sm text-muted-foreground
sm:gap-2.5` — crumbs are muted, the current page is `text-foreground`, and
separators are `size-3.5` chevrons.

The gap widens from 6 to 10 logical pixels at Tailwind's `sm` breakpoint
(640px), which is reproduced here from the ambient [MediaQuery].

```dart
CairnBreadcrumb(
  crumbs: [
    CairnCrumb(label: 'Home', onTap: () {}),
    CairnCrumb(label: 'Settings', onTap: () {}),
    const CairnCrumb.current(label: 'Profile'),
  ],
);
```

**Constructor** `CairnBreadcrumb({required List<CairnCrumb> crumbs, Widget? separator})`

Creates a breadcrumb trail.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `crumbs` | `List<CairnCrumb>` | yes |  | The crumbs, root first. |
| `separator` | `Widget?` |  |  | Overrides the default chevron separator. |

### `CairnBreadcrumbEllipsis` (widget)

The truncation marker for a long trail — `flex size-9 items-center`.

**Constructor** `CairnBreadcrumbEllipsis()`

Creates a breadcrumb ellipsis.


---

# Pagination

A windowed page range with ellipses.

- Category: Navigation
- Widgets: `CairnPagination`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnPagination(
  page: _page,
  pageCount: 12,
  siblingCount: 1,
  onChanged: (int p) => setState(() => _page = p),
)
```

## API

### `CairnPagination` (widget)

A page navigator.

`flex flex-row items-center gap-1` — page links reuse the Button styles:
the current page is the `outline` variant and the rest are `ghost`, all at
the `size-9` icon size. Previous and Next are wider (`px-2.5`) because they
carry a label alongside the chevron.

Renders a windowed range with ellipses so the control stays a fixed width
regardless of page count.

```dart
CairnPagination(
  page: page,
  pageCount: 20,
  onChanged: (p) => setState(() => page = p),
);
```

**Constructor** `CairnPagination({required int page, required int pageCount, ValueChanged<int>? onChanged, int siblingCount = 1, bool showLabels = true})`

Creates a pagination control.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `page` | `int` | yes |  | The current page, 1-based. |
| `pageCount` | `int` | yes |  | The total number of pages. |
| `onChanged` | `ValueChanged<int>?` |  |  | Called with the requested page. |
| `siblingCount` | `int` |  | `1` | How many pages to show either side of the current one. |
| `showLabels` | `bool` |  | `true` | Whether Previous and Next show text labels. |


---

# Menubar

A desktop menu bar with hover-to-switch behaviour.

- Category: Navigation
- Widgets: `CairnMenubar`, `CairnNavigationMenu`, `CairnNavigationMenu`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Once one menu is open, hovering a sibling switches to it without a click — as every native menu bar does.

## Quick start

```dart
CairnMenubar(
  menus: <CairnMenubarMenu>[
    CairnMenubarMenu(
      label: 'File',
      items: <Widget>[
        CairnMenuItem(
          onPressed: _newTab,
          shortcut: 'Ctrl+N',
          child: const Text('New tab'),
        ),
      ],
    ),
  ],
)
```

## API

### `CairnMenubarMenu`

One top-level menu in a [CairnMenubar].

**Constructor** `CairnMenubarMenu({required String label, required List<Widget> items, bool enabled = true})`

Creates a menubar menu.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The trigger's text, e.g. `File`. |
| `items` | `List<Widget>` | yes |  | The menu's rows, typically [CairnMenuItem]s. |
| `enabled` | `bool` |  | `true` | Whether the menu can be opened. |

### `CairnMenubar` (widget)

A desktop-style menu bar.

The bar is `flex h-9 items-center gap-1 rounded-md border bg-background p-1
shadow-xs`; triggers are `rounded-sm px-2 py-1 text-sm font-medium` and
highlight with `data-[state=open]:bg-accent`. Panels are `min-w-[12rem]`
(192 logical pixels) — wider than a Dropdown Menu's `min-w-[8rem]`.

## The hover-to-switch behaviour

Once any menu in the bar is open, hovering a sibling trigger switches to it
without a click — the behaviour every native menu bar has. That requires
the open state to live in the *bar*, not in each menu, so Cairn keeps a
single active index in the parent rather than one controller per menu.
Per-menu state would make "close that one and open this one" a coordination
problem with a visible flicker in the middle of it.

```dart
CairnMenubar(
  menus: [
    CairnMenubarMenu(
      label: 'File',
      items: [CairnMenuItem(onPressed: () {}, child: const Text('New'))],
    ),
  ],
);
```

**Constructor** `CairnMenubar({required List<CairnMenubarMenu> menus, double minPanelWidth = 192.0})`

Creates a menu bar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `menus` | `List<CairnMenubarMenu>` | yes |  | The top-level menus. |
| `minPanelWidth` | `double` |  | `192.0` | `min-w-[12rem]`. |

### `CairnNavigationMenu` (widget)

A horizontal navigation bar.

Triggers are `h-9 w-max rounded-md bg-background px-4 py-2 text-sm
font-medium` with `hover:bg-accent`, and the open state is
`data-[state=open]:bg-accent/50`. Content panels are `rounded-md border
bg-popover p-2 shadow`.

Distinct from [CairnMenubar]: a navigation menu's panels hold arbitrary
content (link grids, promos), not just menu rows, and it is a site-navigation
pattern rather than an application menu bar.

**Constructor** `CairnNavigationMenu({required List<CairnNavigationItem> items})`

Creates a navigation menu.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnNavigationItem>` | yes |  | The top-level entries. |

### `CairnNavigationItem`

One entry in a [CairnNavigationMenu].

**Constructor** `CairnNavigationItem({required String label, VoidCallback? onPressed, Widget? content})`

Creates a plain link that fires [onPressed].

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The trigger's text. |
| `onPressed` | `VoidCallback?` |  |  | Called when a link-style entry is activated. |
| `content` | `Widget?` |  |  | A panel shown on activation. Non-null makes this a disclosure trigger rather than a link. |


---

# Navigation Menu

A top-level nav with arbitrary dropdown panels.

- Category: Navigation
- Widgets: `CairnMenubar`, `CairnNavigationMenu`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnNavigationMenu(
  items: <CairnNavigationItem>[
    CairnNavigationItem(
      label: 'Getting started',
      content: const SizedBox(width: 300, child: Text('Introduction')),
    ),
    CairnNavigationItem(label: 'Docs', onPressed: _docs),
  ],
)
```

## API

### `CairnMenubarMenu`

One top-level menu in a [CairnMenubar].

**Constructor** `CairnMenubarMenu({required String label, required List<Widget> items, bool enabled = true})`

Creates a menubar menu.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The trigger's text, e.g. `File`. |
| `items` | `List<Widget>` | yes |  | The menu's rows, typically [CairnMenuItem]s. |
| `enabled` | `bool` |  | `true` | Whether the menu can be opened. |

### `CairnMenubar` (widget)

A desktop-style menu bar.

The bar is `flex h-9 items-center gap-1 rounded-md border bg-background p-1
shadow-xs`; triggers are `rounded-sm px-2 py-1 text-sm font-medium` and
highlight with `data-[state=open]:bg-accent`. Panels are `min-w-[12rem]`
(192 logical pixels) — wider than a Dropdown Menu's `min-w-[8rem]`.

## The hover-to-switch behaviour

Once any menu in the bar is open, hovering a sibling trigger switches to it
without a click — the behaviour every native menu bar has. That requires
the open state to live in the *bar*, not in each menu, so Cairn keeps a
single active index in the parent rather than one controller per menu.
Per-menu state would make "close that one and open this one" a coordination
problem with a visible flicker in the middle of it.

```dart
CairnMenubar(
  menus: [
    CairnMenubarMenu(
      label: 'File',
      items: [CairnMenuItem(onPressed: () {}, child: const Text('New'))],
    ),
  ],
);
```

**Constructor** `CairnMenubar({required List<CairnMenubarMenu> menus, double minPanelWidth = 192.0})`

Creates a menu bar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `menus` | `List<CairnMenubarMenu>` | yes |  | The top-level menus. |
| `minPanelWidth` | `double` |  | `192.0` | `min-w-[12rem]`. |

### `CairnNavigationMenu` (widget)

A horizontal navigation bar.

Triggers are `h-9 w-max rounded-md bg-background px-4 py-2 text-sm
font-medium` with `hover:bg-accent`, and the open state is
`data-[state=open]:bg-accent/50`. Content panels are `rounded-md border
bg-popover p-2 shadow`.

Distinct from [CairnMenubar]: a navigation menu's panels hold arbitrary
content (link grids, promos), not just menu rows, and it is a site-navigation
pattern rather than an application menu bar.

**Constructor** `CairnNavigationMenu({required List<CairnNavigationItem> items})`

Creates a navigation menu.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnNavigationItem>` | yes |  | The top-level entries. |

### `CairnNavigationItem`

One entry in a [CairnNavigationMenu].

**Constructor** `CairnNavigationItem({required String label, VoidCallback? onPressed, Widget? content})`

Creates a plain link that fires [onPressed].

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The trigger's text. |
| `onPressed` | `VoidCallback?` |  |  | Called when a link-style entry is activated. |
| `content` | `Widget?` |  |  | A panel shown on activation. Non-null makes this a disclosure trigger rather than a link. |


---

# Scroll Area

A scroller with a thumb drawn from the theme's tokens.

- Category: Navigation
- Widgets: `CairnScrollArea`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Configures Flutter's own Scrollbar rather than reimplementing scrolling: the thumb is bg-border on a w-2.5 track.

## Quick start

```dart
CairnScrollArea(
  height: 200,
  alwaysVisible: true,
  child: Column(children: tags),
)
```

## API

### `CairnScrollArea` (widget)

A scroll container with a slim, quiet scrollbar.

The scrollbar track is `w-2.5` (10 logical pixels) with `p-px` padding and
the thumb is `rounded-full bg-border` — noticeably slimmer and quieter than
a platform scrollbar, which is the point of the component.

This configures Flutter's [Scrollbar] rather than reimplementing scrolling.
The web has to hand-roll a scrollbar to restyle one; Flutter does not, and
reimplementing here would give up momentum physics, trackpad handling and
accessibility for no visual gain whatsoever.

```dart
CairnScrollArea(
  height: 200,
  child: Column(children: items),
);
```

**Constructor** `CairnScrollArea({required Widget child, double? height, double? width, Axis axis = Axis.vertical, EdgeInsetsGeometry? padding, bool alwaysVisible = false})`

Creates a scroll area.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The scrollable content. |
| `height` | `double?` |  |  | An optional fixed height. |
| `width` | `double?` |  |  | An optional fixed width. |
| `axis` | `Axis` |  | `Axis.vertical` | The scroll direction. |
| `padding` | `EdgeInsetsGeometry?` |  |  | Padding applied inside the scroll view. |
| `alwaysVisible` | `bool` |  | `false` | Whether the scrollbar stays visible rather than fading out. |


---

# Carousel

A paged viewport with controls and indicators.

- Category: Navigation
- Widgets: `CairnCarousel`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

## Quick start

```dart
CairnCarousel(
  height: 200,
  viewportFraction: 0.8,
  items: slides,
  onPageChanged: (int i) => setState(() => _page = i),
)
```

## API

### `CairnCarousel` (widget)

A horizontally paged content strip.

The previous/next controls are 32 logical pixel round outline buttons that
sit *outside* the viewport edges rather than floating over the content, so
they never cover part of a slide. The trade-off is worth stating plainly:
the carousel needs horizontal room around it.

The strip itself is a [PageView]. Flutter's scroll physics, drag handling
and page snapping are already right, and anything hand-rolled would only be
a worse version of them — so the component's substance is its chrome, its
metrics and its keyboard behaviour.

```dart
CairnCarousel(
  height: 200,
  items: [for (final image in images) Image.network(image)],
);
```

**Constructor** `CairnCarousel({required List<Widget> items, double height = 200.0, double viewportFraction = 1.0, double spacing = CairnSpacing.s4, bool showControls = true, bool showIndicators = true, ValueChanged<int>? onPageChanged})`

Creates a carousel.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<Widget>` | yes |  | The slides. |
| `height` | `double` |  | `200.0` | The strip height. |
| `viewportFraction` | `double` |  | `1.0` | How much of the viewport one slide occupies. Below 1.0 the neighbouring slides peek in at the edges, hinting that the strip continues. |
| `spacing` | `double` |  | `CairnSpacing.s4` | The gap between slides, in logical pixels. |
| `showControls` | `bool` |  | `true` | Whether to show the previous/next buttons. |
| `showIndicators` | `bool` |  | `true` | Whether to show the dot indicators. |
| `onPageChanged` | `ValueChanged<int>?` |  |  | Called when the visible page changes. |


---

# Steps

A progress rail for multi-step flows.

- Category: Navigation
- Widgets: `CairnSteps`, `CairnStep`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Only completed steps are tappable.

## Quick start

```dart
CairnSteps(
  current: 1,
  onStepTap: (int i) => setState(() => _step = i),
  steps: const <CairnStep>[
    CairnStep(label: 'Cart'),
    CairnStep(label: 'Shipping'),
    CairnStep(label: 'Done'),
  ],
)
```

## API

### `CairnStep`

One step of a [CairnSteps] indicator.

**Constructor** `CairnStep({required String label, String? description, Widget? marker})`

Creates a step.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `label` | `String` | yes |  | The step's name. |
| `description` | `String?` |  |  | An optional second line. |
| `marker` | `Widget?` |  |  | Replaces the step number inside the circle — an icon or an emoji. |

### `CairnSteps` (widget)

A progress-through-a-process indicator — checkout, onboarding, a wizard.

A row (or column) of 28px circles joined by a 2px line. Steps before
[current] are complete (filled, with a check), [current] is filled and
numbered, and later steps are outlined and muted. The connecting line fills
in as the index advances, animated at 300ms on the standard curve like
[CairnProgress].

Set [tone] to tint the completed portion, for example
[CairnTone.success].

```dart
const CairnSteps(
  current: 1,
  steps: [
    CairnStep(label: 'Cart'),
    CairnStep(label: 'Shipping'),
    CairnStep(label: 'Payment'),
  ],
);
```

**Constructor** `CairnSteps({required List<CairnStep> steps, int current = 0, Axis direction = Axis.horizontal, CairnTone tone = CairnTone.primary, ValueChanged<int>? onStepTap})`

Creates a steps indicator.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `steps` | `List<CairnStep>` | yes |  | The steps, in order. |
| `current` | `int` |  | `0` | The zero-based index of the active step. A value past the last step marks every step complete. |
| `direction` | `Axis` |  | `Axis.horizontal` | Whether the steps run across or down. |
| `tone` | `CairnTone` |  | `CairnTone.primary` | The colour of completed and current steps. |
| `onStepTap` | `ValueChanged<int>?` |  |  | Called with a step's index when a *completed* step is tapped, so a wizard can navigate back. Later steps are not tappable. |


---

# Navbar

A top bar with start, centre and end slots.

- Category: Navigation
- Widgets: `CairnNavbar`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> The centre slot is centred on the bar itself, not on the space left over.

## Quick start

```dart
CairnNavbar(
  start: const Text('Cairn'),
  end: CairnButton(
    size: CairnButtonSize.sm,
    onPressed: _signIn,
    child: const Text('Sign in'),
  ),
)
```

## API

### `CairnNavbar` (widget)

A top application bar with start, centre and end regions.

A 56px bar on the `background` surface with a 1px bottom [CairnTheme.border]
hairline and 16px side padding — the shell most apps put a logo, primary
navigation and an account menu into. Regions are optional: with only
[start] and [end] the bar justifies them to the edges; a [center] is truly
centred on the bar, not merely between its neighbours, so a logo does not
drift when the two sides have different widths.

Wrap with `SafeArea` yourself on mobile; the navbar draws only its own box.

```dart
CairnNavbar(
  start: Text('Cairn'),
  center: CairnTabs(...),
  end: CairnAvatar(...),
);
```

**Constructor** `CairnNavbar({Widget? start, Widget? center, Widget? end, double height = 56.0, bool bordered = true, Color? color})`

Creates a navbar.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `start` | `Widget?` |  |  | Leading content — logo, back button, menu toggle. |
| `center` | `Widget?` |  |  | Centred content. |
| `end` | `Widget?` |  |  | Trailing content — actions, account menu. |
| `height` | `double` |  | `56.0` | The bar height (`h-14`). |
| `bordered` | `bool` |  | `true` | Whether to draw the bottom hairline. |
| `color` | `Color?` |  |  | Overrides the `background` fill — for example `theme.card` for a raised bar. |


---

# Dock

A 64px bottom navigation bar for mobile.

- Category: Navigation
- Widgets: `CairnDock`, `CairnDockItem`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Needs at least two items.

## Quick start

```dart
CairnDock(
  index: _tab,
  onChanged: (int i) => setState(() => _tab = i),
  items: const <CairnDockItem>[
    CairnDockItem(icon: CairnIcon(CairnIconData.search), label: 'Search'),
    CairnDockItem(icon: CairnIcon(CairnIconData.info), label: 'Inbox'),
  ],
)
```

## API

### `CairnDockItem`

One destination in a [CairnDock].

**Constructor** `CairnDockItem({required Widget icon, required String label, Widget? badge})`

Creates a dock item.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `icon` | `Widget` | yes |  | The glyph. Sized to 20px by the dock. |
| `label` | `String` | yes |  | The caption, also used as the accessible name. |
| `badge` | `Widget?` |  |  | An optional [CairnBadge] / [CairnStatus] pinned to the icon. |

### `CairnDock` (widget)

A bottom navigation bar for mobile layouts.

A 64px bar on the `background` surface with a 1px top hairline. Each item is
an icon above a 12px label; the selected item takes `foreground` colour and
semibold weight with a 2px primary bar above it, while the rest stay
`mutedForeground`. Items share the width equally and the whole item is the
tap target, which keeps them above the 48px touch minimum.

Pair with `SafeArea` so the bar clears the home indicator.

```dart
CairnDock(
  index: _tab,
  onChanged: (i) => setState(() => _tab = i),
  items: const [
    CairnDockItem(icon: Icon(Icons.home), label: 'Home'),
    CairnDockItem(icon: Icon(Icons.search), label: 'Search'),
  ],
);
```

**Constructor** `CairnDock({required List<CairnDockItem> items, required int index, required ValueChanged<int> onChanged, double height = 64.0})`

Creates a dock.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `items` | `List<CairnDockItem>` | yes |  | The destinations. |
| `index` | `int` | yes |  | The selected item. |
| `onChanged` | `ValueChanged<int>` | yes |  | Called with the tapped item's index. |
| `height` | `double` |  | `64.0` | The bar height (`h-16`). |


---

# Link

A text link with muted and underline options.

- Category: Navigation
- Widgets: `CairnLink`
- Import: `import 'package:cairn_ui/cairn_ui.dart';`

> Does not navigate. Call your router or url_launcher from onPressed.

## Quick start

```dart
CairnLink(
  onPressed: () => context.go('/docs'),
  child: const Text('Read the docs'),
)
```

## API

### `CairnLink` (widget)

A text link.

`text-primary font-medium underline-offset-4 hover:underline` — primary
coloured, underlined on hover and on keyboard focus, and drawing the same
3px ring other controls draw when focused so it is findable by keyboard.

Cairn does not navigate: [onPressed] is where you call your router or
`url_launcher`. Set [muted] for the quieter `mutedForeground` variant used
in footers, and [underline] to underline at rest.

```dart
CairnLink(onPressed: () => context.go('/docs'), child: Text('Read the docs'));
```

**Constructor** `CairnLink({required Widget child, required VoidCallback? onPressed, bool muted = false, bool underline = false})`

Creates a link.

| Parameter | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `child` | `Widget` | yes |  | The link text. |
| `onPressed` | `VoidCallback?` | yes |  | Called on activation. Null renders it disabled. |
| `muted` | `bool` |  | `false` | Whether to use the muted colour. |
| `underline` | `bool` |  | `false` | Whether to underline when not hovered or focused. |


---

