# Dashboard shell block

A complete application frame: a sidebar with grouped navigation, a top bar with breadcrumbs and a range filter, a row of stat cards and a sortable, filterable, paginated table.

Built from: Menu, Avatar, Separator, Breadcrumb, Input, Select, Card, Badge, Progress, Data Table, Scroll Area

```dart
Row(
  children: <Widget>[
    // Sidebar — menu primitives, not a bespoke nav widget.
    Container(
      width: 228,
      decoration: BoxDecoration(
        color: theme.subtleSurface,
        border: Border(right: BorderSide(color: theme.border)),
      ),
      child: Column(
        children: <Widget>[
          const CairnMenuLabel('Workspace'),
          for (final NavItem item in items)
            CairnMenuItem(
              onPressed: () => setState(() => _nav = item.value),
              trailing: _nav == item.value
                  ? const CairnIcon(CairnIconData.check, size: 14)
                  : null,
              child: Text(item.label),
            ),
        ],
      ),
    ),
    Expanded(
      child: Column(
        children: <Widget>[
          _TopBar(range: _range, onRangeChanged: _setRange),
          Expanded(
            child: CairnScrollArea(
              padding: const EdgeInsets.all(CairnSpacing.s5),
              child: Column(
                spacing: CairnSpacing.s5,
                children: <Widget>[
                  const Row(
                    spacing: CairnSpacing.s4,
                    children: <Widget>[
                      Expanded(child: StatCard(label: 'Total revenue')),
                      Expanded(child: StatCard(label: 'Subscriptions')),
                    ],
                  ),
                  CairnCard(
                    children: <Widget>[
                      const CairnCardHeader(title: Text('Recent orders')),
                      CairnCardContent(
                        child: CairnDataTable<Order>(
                          rows: orders,
                          pageSize: 4,
                          searchBy: (Order o) => o.customer,
                          columns: columns,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ],
)
```
