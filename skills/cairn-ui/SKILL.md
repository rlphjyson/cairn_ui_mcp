---
name: cairn-ui
description: Build Flutter UI with Cairn UI (the cairn_ui package). Looks up the real components, constructor parameters, design tokens and theme before writing any code, so screens compile first time and follow the design system. Use whenever the user writes or changes Flutter screens, widgets, forms, dialogs, navigation or themes in a project that uses Cairn, mentions cairn_ui, CairnTheme or any Cairn* widget (CairnButton, CairnCard, CairnInput...), or asks for a Flutter UI kit and Cairn is the target.
---

# Cairn UI

Cairn UI is a Flutter component library: 65 component modules on one design-token layer (OKLCH colour, a multiplier-based radius scale, a spacing scale, a type scale), light and dark themes, and golden tests. Everything is exported from one import:

```dart
import 'package:cairn_ui/cairn_ui.dart';
```

## Workflow

1. **Check the project.** Look in `pubspec.yaml` for `cairn_ui`. If it is missing, run `flutter pub add cairn_ui`. Look for a registered theme (step 2).
2. **Check the theme.** Cairn reads `CairnTheme` from `ThemeData.extensions`. If the app has not registered it, add it (see "Theme setup"). Cairn widgets still render without it, but the app then cannot choose light or dark or customise tokens.
3. **Look up every component before using it. Never guess a parameter.**
   - If the `cairn-ui` MCP server is connected, call `search_components` for the need, then `get_component` for each widget you will use. Call `get_tokens` before writing a colour, a radius, a spacing value or a text style.
   - Otherwise read the reference files in this skill: `references/components.md` finds the component, then the matching `references/api-<category>.md` has each component's quick start and exact constructor parameters. `references/tokens.md` has the tokens.
4. **Write the code** following the rules below. Reuse a block (`references/blocks.md`) or a template (see the `cairn-templates` skill) when one already does most of the work.
5. **Verify.** Run `flutter analyze`. Fix every error, especially unknown parameters or enum values: they mean a reference was skipped.

## Rules

- One import: `package:cairn_ui/cairn_ui.dart`. There are no per-component imports.
- Every public widget is prefixed `Cairn`. Do not invent widgets: if `references/components.md` does not list it, it does not exist. Use Flutter's own widgets (`Row`, `Column`, `Padding`, `Text`) for layout around Cairn components.
- **Never hard-code colours, radii, spacing or text styles.** Read the theme and the token classes:
  ```dart
  final CairnTheme theme = CairnTheme.of(context);

  Container(
    padding: const EdgeInsets.all(CairnSpacing.s4),
    decoration: BoxDecoration(
      color: theme.card,
      border: Border.all(color: theme.border),
      borderRadius: BorderRadius.circular(theme.radiusScale.lg),
    ),
    child: Text(
      'Custom surface, Cairn tokens',
      style: theme
          .textStyle(CairnTypography.sm)
          .copyWith(color: theme.mutedForeground),
    ),
  )
  ```
- In app code use `theme.radiusScale.lg` (it follows the theme's radius), not the constant `CairnRadius.lg`.
- Icon-only buttons are `CairnButton.icon(icon: ..., semanticLabel: '...', onPressed: ...)`. The label is required; keep it.
- A null `onPressed` disables a button; do not wrap in `IgnorePointer`.
- `CairnTone` (`neutral`, `primary`, `success`, `warning`, `info`, `destructive`) colours state-bearing components (Status, Steps, Timeline, Radial Progress, Rating). Do not pick raw greens and reds.
- Cairn has no ripple. Interaction feedback is colour and shadow transitions, so do not add `InkWell` around Cairn components.
- Modal surfaces (Dialog, Alert Dialog, Sheet, Drawer) open with a `show...` function and need a `Navigator`. Anchored surfaces (Popover, Dropdown Menu, Tooltip, Hover Card) take a `CairnOverlayController` that you create and dispose. Toasts need a `CairnToaster` above the `Navigator`.
- Support dark mode by only using tokens; never branch on brightness yourself unless a reference says to.
- Every interactive control needs an accessible name: visible text, a `semanticLabel`, or a `CairnLabel`. See `references/guides/accessibility.md`.
- Prefer `const` constructors where the arguments are constant.

## Theme setup

`CairnTheme` is a `ThemeExtension`. `CairnTheme.materialTheme()` returns a `ThemeData` whose Material defaults agree with the tokens:

```dart
MaterialApp(
  theme: CairnTheme.materialTheme(CairnTheme.light),
  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
  themeMode: ThemeMode.system,
  // The toast host sits above every route, so a toast outlives the screen that fired it.
  builder: (BuildContext context, Widget? child) =>
      CairnToaster(child: child ?? const SizedBox.shrink()),
  home: const HomeScreen(),
)
```

Customise with `copyWith`; every corner follows the single `radius` value:

```dart
final CairnTheme brand = CairnTheme.light.copyWith(
  primary: const Color(0xFF3B82F6),
  primaryForeground: const Color(0xFFFFFFFF),
  radius: 4.0,
  fontFamily: 'Inter',
);
```

Full slot list and guidance: `references/theming.md`, `references/guides/dark-mode.md`.

## Patterns

- **Screens**: compose `CairnCard` (with `CairnCardHeader`, `CairnCardContent`, `CairnCardFooter`), `CairnInput` inside `CairnFormField`, `CairnButton`. See `references/blocks.md` for a login, a dashboard shell, settings, pricing and a team list, all built from Cairn only.
- **Lists and tables**: `CairnList` / `CairnListItem` for simple rows; `CairnTable` for static data; `CairnDataTable<T>` for sorting, search and pagination.
- **Navigation**: `CairnNavbar` (top), `CairnDock` (mobile bottom bar), `CairnTabs`, `CairnBreadcrumb`, `CairnPagination`, `CairnMenubar`, `CairnNavigationMenu`.
- **Feedback**: `CairnToast` via `CairnToaster`, `CairnAlert`, `CairnProgress`, `CairnSpinner`, `CairnSkeleton`, `CairnEmpty`.
- **Overlays**: `showCairnDialog`, `CairnAlertDialog`, `showCairnSheet`, `CairnPopover`, `CairnDropdownMenu`, `CairnTooltip`, `CairnCommand` (command palette).

## References (read on demand, not all at once)

| File | Use it for |
| --- | --- |
| `references/components.md` | Finding the right component; one line each |
| `references/api-forms.md` | Button, Input, Textarea, Label, Checkbox, Switch, Radio Group, Slider, Toggle, Toggle Group, Input OTP, Form Field, Rating, Swap, File Input, Floating Action Button |
| `references/api-display.md` | Card, Badge, Avatar, Alert, Separator, Skeleton, Spinner, Kbd, Aspect Ratio, Empty, Table, Stat, Status, Timeline, Chat Bubble, Indicator, Stack, Hero, Diff, List, Mockup |
| `references/api-overlays.md` | Dialog, Alert Dialog, Sheet, Drawer, Popover, Tooltip, Hover Card, Dropdown Menu, Context Menu, Menu, Select, Combobox, Command |
| `references/api-navigation.md` | Tabs, Accordion, Collapsible, Breadcrumb, Pagination, Menubar, Navigation Menu, Scroll Area, Carousel, Steps, Navbar, Dock, Link |
| `references/api-data.md` | Progress, Toast, Data Table, Calendar, Date Picker, Radial Progress, Countdown |
| `references/tokens.md` | Colours, radius, spacing, typography, shadows, motion, tones |
| `references/theming.md` | The theme API and customising it |
| `references/blocks.md` | Whole composed screens, with source |
| `references/guides/` | Installation, quick start, dark mode, accessibility, testing |
