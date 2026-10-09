---
name: cairn-dashboard
description: Design dashboards and admin panels in Flutter with Cairn UI: sidebar and top-bar shells, KPI cards, filters, data tables, activity feeds, charts and responsive layouts that collapse to a phone. Use when the user asks for a dashboard, admin panel, analytics screen, back-office or data-heavy Flutter UI built with Cairn (cairn_ui), or wants to start from the Cairn dashboard template.
---

# Cairn dashboards

Build dashboards from Cairn components and tokens only. This skill adds layout recipes on top of the `cairn-ui` skill: read that skill's rules first (look components up, never hard-code colours or spacing, one import).

For a ready-made starting point use the **dashboard template** (`cairn_template_dashboard`, `templates/dashboard` in the cairn_site repository). It has a sidebar, a period picker, KPI cards, five chart types and a sortable, searchable, paged orders table, and it is documented in `references/dashboard-template.md`. Copy or extend it before writing a dashboard from scratch. For the charts see the `cairn-charts` skill.

## Anatomy

```
Row
├─ Sidebar (fixed 224px, hidden below 760px)       brand, page buttons, user
└─ Expanded Column
   ├─ Top bar (64px)                                title, period/filters, actions
   └─ Expanded page (ListView, 24px padding)
       ├─ KPI grid
       ├─ Charts row
       └─ Table / list
```

- **Sidebar**: `DecoratedBox` with `theme.card` fill and a `theme.border` right edge; nav items are `CairnButton` (`secondary` when active, `ghost` otherwise) with a leading icon; the user block sits at the bottom after a `CairnSeparator`.
- **Top bar**: a 64px `SizedBox` with a bottom `theme.border` line; title in `CairnTypography.lg` semibold; filters as `CairnToggleGroup` (single, `CairnToggleVariant.outline`, `CairnToggleSize.sm`) or `CairnSelect`; notifications as `CairnIndicator` over an icon.
- **Narrow screens**: below ~760px drop the sidebar and show page buttons in a row under the top bar. Check width with `LayoutBuilder`, not `MediaQuery`, so the dashboard also works inside a smaller frame.

## KPI cards

A `CairnCard` with a `CairnCardHeader` (title + a delta badge in `action`) and a big number in `CairnCardContent`. Show the delta in an outline `CairnBadge` with a trending icon; colour the icon with `CairnToneColors.resolve(theme, CairnTone.success)` (or `destructive`), and invert for metrics where falling is good (refund rate). Lay the cards out with `Wrap` and a `LayoutBuilder`: 4 per row from 860px, 2 from 520px, otherwise 1. For a joined strip use `CairnStats` with `CairnStat` children.

## Tables

- `CairnDataTable<T>`: `rows`, `columns` (`CairnColumn<T>` with `label`, `flex`, `cell`, `sortKey`), `pageSize`, `searchBy`, `searchPlaceholder`. It gives sorting, search and pagination.
- Put status in an outline `CairnBadge` with a `CairnStatus` dot (`CairnTone.success`/`warning`/`destructive`/`info`).
- Give the table a minimum width (about 720px) and wrap it in a horizontal `SingleChildScrollView` on narrow screens rather than squashing columns.
- Filter chips above the table are `CairnButton`s: `primary` when selected, `outline` otherwise.

## States every data screen needs

- **Loading**: `CairnSpinner` for a page, `CairnSkeleton` for a card or row.
- **Empty**: `CairnEmpty` with a clear next action.
- **Error**: a destructive `CairnAlert` with a retry `CairnButton`. Keep the old data visible if a refresh fails.
- Reload per screen when a shared filter (period) changes; do not flash an empty state while reloading.

## Architecture for real data

Keep widgets dumb. The template uses clean architecture by layer and feature (`domain/<feature>/{models,mappers,repositories,use_cases}`, `data/<feature>/{remote,repositories}`, `presentation/<feature>/{bloc,view_models,views,widgets}`), `flutter_bloc` cubits and `get_it`. Data sources return decoded JSON that mappers turn into models, so swapping in an API changes one class. See `references/dashboard-template.md`.

## Checklist

- [ ] Only Cairn components and tokens; no raw colours, no magic padding numbers (use `CairnSpacing`).
- [ ] KPI grid, chart cards and table reflow at 390, 768 and 1280px without overflow.
- [ ] Loading, empty and error states exist.
- [ ] Numbers are formatted (thousands separators, compact axis labels, signed percentages).
- [ ] Icon-only buttons have a `semanticLabel`; charts have a text summary nearby.
- [ ] `flutter analyze` is clean.
