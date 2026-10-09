---
name: cairn-charts
description: Draw charts in Flutter that match Cairn UI's design tokens, using fl_chart restyled through a small theme adapter: area, line, bar, donut, radial gauge and sparkline charts with Cairn colours, grid, axes and tooltips in light and dark. Use when the user asks for charts, graphs, plots or data visualisation in a Flutter app that uses Cairn (cairn_ui). Cairn itself has no chart widgets by design.
---

# Cairn charts

Cairn UI deliberately ships **no chart widgets**: a chart engine is a large, opinionated dependency, and Cairn takes none. Charts are drawn with [`fl_chart`](https://pub.dev/packages/fl_chart) and restyled so every colour, grid line, label and tooltip comes from Cairn tokens. Follow the `cairn-ui` skill's rules for everything around the chart (cards, legends, filters).

## Setup

```yaml
dependencies:
  cairn_ui: ^0.2.0
  fl_chart: ^1.2.0
```

Copy `references/chart_theme.dart` into the project (for example `lib/charts/chart_theme.dart`). It is a thin adapter, `ChartTheme`, with:

| Member | Gives |
| --- | --- |
| `ChartTheme.series(theme)` / `seriesColor(theme, i)` | The five-step series ramp from the library's chart tokens, ordered so the primary series has the most contrast in light and dark |
| `ChartTheme.grid(theme, interval:)` | Horizontal hairlines only |
| `ChartTheme.categoryAxis(theme, labels)` | Bottom axis with one label per integer x |
| `ChartTheme.valueAxis(theme, format:, interval:)` | Left axis |
| `ChartTheme.hidden` | Turns an unused axis off |
| `ChartTheme.border` | No chart border (the card around it draws one) |
| `ChartTheme.lineTooltip` / `barTooltip` | Tooltips on the popover surface |
| `ChartTheme.dots(theme, color, show:)` | Point markers |

## Rules

- Take colours from `ChartTheme.seriesColor(theme, index)`; never hard-code hex values. The default ramp is monochrome on purpose; reach for tones (`CairnToneColors.resolve(theme, CairnTone.success)`) only when colour carries meaning (good/bad), not to decorate series.
- Wrap a chart in a `CairnCard` (`CairnCardHeader` for title and description, the chart in `CairnCardContent`), and give it an explicit height with a `SizedBox`: charts need bounded height.
- Always show a legend when there is more than one series (a colour swatch with the series name), and label axes with short formatted values (`2.5k`, not `2500`).
- Choose the axis maximum with a "nice number" helper (round up to 1, 2, 2.5, 5 or 10 times a power of ten) so grid lines land on readable values.
- Put the previous period or comparison series in a dashed line (`dashArray: [6, 4]`) and the main series solid.
- Provide a text alternative near the chart (a total, a trend sentence, or a table) for screen readers.
- Avoid infinite animations; `fl_chart`'s own tween on data change is fine.

## Recipes

The files in `references/recipes/` are complete, working widgets from the Cairn dashboard template. Copy and adapt them rather than writing a chart from scratch:

| Recipe | Chart |
| --- | --- |
| `references/recipes/revenue_chart.md` | Area chart with a dashed comparison line and a legend |
| `references/recipes/visits_line.md` | Two-series line chart with point markers |
| `references/recipes/device_bars.md` | Bar chart with rounded tops |
| `references/recipes/traffic_donut.md` | Donut with a centre readout and a legend that moves below on narrow cards |
| `references/recipes/conversion_gauge.md` | Radial gauge against a target |

## Checklist

- [ ] `ChartTheme` copied; no raw colours in chart code.
- [ ] Fixed height, legend, formatted axes, tooltips.
- [ ] Looks right in light and dark.
- [ ] Narrow card: legend wraps below; labels do not collide.
- [ ] `flutter analyze` is clean.
