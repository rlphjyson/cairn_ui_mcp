# Dashboard template (web)

An analytics dashboard with a sidebar, a period picker and three pages: an overview with KPI cards and a revenue chart, an analytics page with traffic, device, visitor and conversion charts, and a sortable, searchable, paged orders table. Every chart is fl_chart restyled through Cairn tokens, and the layout collapses to a phone below 760 pixels.

Package: `cairn_template_dashboard` (in `templates/dashboard` of the cairn_site repository).

## Screens
- **Overview** — Four KPIs with trends, revenue against last period.
- **Analytics** — Traffic donut, device bars, visitor lines, conversion.
- **Orders** — Status filters, search, sorting and pagination.
- **Period picker** — 7 days, 30 days or 12 months, applied to every chart.

Built from: Card, Badge, Button, Toggle Group, Data Table, Alert, List, Avatar, Indicator, Status, Separator, Spinner

## Use it

```yaml
dependencies:
  cairn_ui: ^0.2.0
  cairn_template_dashboard:
    git:
      url: https://github.com/rlphjyson/cairn_site.git
      path: templates/dashboard
```

```dart
import 'package:cairn_template_dashboard/cairn_template_dashboard.dart';

MaterialApp(
  theme: CairnTheme.materialTheme(CairnTheme.light),
  darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
  home: const Scaffold(body: DashboardApp()),
);
```

Each template is a standalone package with its own assets, tests and an HTML tutorial (`doc/index.html`) covering content changes, theming, connecting a backend and migration.


---

# Dashboard template

An analytics dashboard built from `cairn_ui`, with `fl_chart` restyled through
Cairn tokens. A sidebar, a period picker, KPI cards, revenue / traffic / device /
visitor / conversion charts and a sortable, searchable, paged orders table.
Clean architecture by layer and then by feature, `flutter_bloc` for state and
`get_it` for dependency injection.

Full documentation, with a tutorial for changing the data, branding, connecting
a backend and migrating, is in [`doc/index.html`](doc/index.html).

## Use it

```yaml
dependencies:
  cairn_template_dashboard:
    path: ../templates/dashboard   # or a git dependency
  cairn_ui: ^0.2.0
```

```dart
import 'package:cairn_template_dashboard/cairn_template_dashboard.dart';
import 'package:cairn_ui/cairn_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(extensions: <ThemeExtension<dynamic>>[CairnTheme.light]),
    darkTheme: ThemeData(extensions: <ThemeExtension<dynamic>>[CairnTheme.dark]),
    home: const Scaffold(body: DashboardApp()),
  ),
);
```

`DashboardApp` fills the space its parent gives it. Below 760 logical pixels
the sidebar gives way to a row of page buttons.

## Layout

```
lib/
├── dashboard_app.dart            # entry point
├── cairn_template_dashboard.dart # barrel
├── core/
│   ├── infrastructure/di/        # get_it container
│   └── presentation/
│       ├── charts/chart_theme.dart   # Cairn tokens for fl_chart
│       ├── navigation/           # page cubit
│       ├── widgets/              # legend row
│       └── view_model.dart       # ViewModel, ViewModelBuilder, scope
├── common/
│   ├── constants/dashboard_brand.dart  # product name, user (change these first)
│   └── utils/                    # number formatting, chart axis scale
├── data/<feature>/
│   ├── remote/                   # data sources (in-memory stand-ins)
│   └── repositories/
├── domain/<feature>/
│   ├── models/  mappers/  repositories/  use_cases/
└── presentation/<feature>/
    ├── bloc/  view_models/  views/  widgets/
    └── shell/                    # providers, sidebar, top bar, frame
```

Features: `filters` (the period), `overview`, `analytics`, `orders`.

## Rules

1. **Dependencies point inwards.** Presentation → domain ← data. The domain
   knows nothing about Flutter widgets or the network.
2. **Views never touch the container.** A screen-scoped cubit comes from
   `ViewModelBuilder<T>`; session cubits are read with `context.read`.
3. **Two kinds of cubit.** Session cubits (navigation, period) are lazy
   singletons provided once by `DashboardProviders` and never closed by a view
   model. Screen cubits (overview, analytics, orders) are created by a view
   model and closed with it. Screens reload themselves when the period changes.
4. **Data sources return decoded JSON.** Mappers in `domain/<feature>/mappers`
   turn it into models, so swapping in a real API changes one class.
5. **No code generation.** Registrations are written out in
   `core/infrastructure/di/dashboard_injection.dart`.

## Develop

```bash
flutter pub get
flutter analyze --fatal-infos --fatal-warnings
flutter test
```

Tests load the Geist font from the Cairn site checkout this package lives in
(`../../fonts`) when it exists, so text metrics match production.
