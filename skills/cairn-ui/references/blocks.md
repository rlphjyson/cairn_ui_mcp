# Blocks

Whole screens composed only from Cairn components.

- `login` — **Login**: A centred authentication card with an email/password form, a social provider button and a sign-up link.
- `dashboard` — **Dashboard shell**: A complete application frame: a sidebar with grouped navigation, a top bar with breadcrumbs and a range filter, a row of stat cards and a sortable, filterable, paginated table.
- `settings` — **Settings**: A tabbed preferences panel: profile fields, a theme radio group and a list of notification switches, with the body height animating between tabs.
- `pricing` — **Pricing**: Three tier cards with a highlighted plan. The emphasis on the middle card is drawn with the theme's focus-ring token rather than an invented accent colour.
- `team` — **Team roster**: A member list with avatars and a per-row role select — the pattern every settings screen eventually needs.

# Login block

A centred authentication card with an email/password form, a social provider button and a sign-up link.

Built from: Card, Form Field, Input, Button, Label

```dart
SizedBox(
  width: 400,
  child: CairnCard(
    children: <Widget>[
      const CairnCardHeader(
        title: Text('Login to your account'),
        description: Text('Enter your email below to sign in.'),
      ),
      CairnCardContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: CairnSpacing.s4,
          children: <Widget>[
            const CairnFormField(
              label: 'Email',
              child: CairnInput(placeholder: 'name@example.com'),
            ),
            const CairnFormField(
              label: 'Password',
              child: CairnInput(obscureText: true),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CairnButton(
                variant: CairnButtonVariant.link,
                size: CairnButtonSize.sm,
                onPressed: _recover,
                child: const Text('Forgot your password?'),
              ),
            ),
          ],
        ),
      ),
      CairnCardFooter(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: CairnSpacing.s3,
              children: <Widget>[
                CairnButton(
                  expand: true,
                  onPressed: _signIn,
                  child: const Text('Login'),
                ),
                CairnButton(
                  variant: CairnButtonVariant.outline,
                  expand: true,
                  onPressed: _signInWithGitHub,
                  child: const Text('Login with GitHub'),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  ),
)
```


---

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


---

# Settings block

A tabbed preferences panel: profile fields, a theme radio group and a list of notification switches, with the body height animating between tabs.

Built from: Card, Tabs, Form Field, Input, Textarea, Radio Group, Switch, Separator, Button

```dart
CairnCard(
  children: <Widget>[
    const CairnCardHeader(
      title: Text('Settings'),
      description: Text('Manage your account preferences.'),
    ),
    CairnCardContent(
      child: Column(
        spacing: CairnSpacing.s6,
        children: <Widget>[
          CairnTabs<String>(
            value: _tab,
            expand: true,
            onChanged: (String v) => setState(() => _tab = v),
            tabs: const <CairnTab<String>>[
              CairnTab<String>(value: 'profile', label: Text('Profile')),
              CairnTab<String>(value: 'appearance', label: Text('Appearance')),
              CairnTab<String>(
                value: 'notifications',
                label: Text('Notifications'),
              ),
            ],
          ),
          // AnimatedSize keeps the card from snapping when the taller
          // notifications panel replaces the shorter profile one.
          AnimatedSize(
            duration: CairnMotion.d200,
            curve: CairnMotion.standard,
            alignment: Alignment.topCenter,
            child: switch (_tab) {
              'profile' => const _ProfilePanel(),
              'appearance' => _AppearancePanel(value: _theme),
              _ => _NotificationsPanel(values: _switches),
            },
          ),
        ],
      ),
    ),
    CairnCardFooter(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CairnButton(onPressed: _save, child: const Text('Save changes')),
      ],
    ),
  ],
)
```


---

# Pricing block

Three tier cards with a highlighted plan. The emphasis on the middle card is drawn with the theme's focus-ring token rather than an invented accent colour.

Built from: Card, Badge, Separator, Button, Icon

```dart
CairnCard(
  children: <Widget>[
    CairnCardHeader(
      title: Text(tier.name),
      description: Text(tier.blurb),
      action: tier.featured ? const CairnBadge(label: Text('Popular')) : null,
    ),
    CairnCardContent(
      child: Column(
        spacing: CairnSpacing.s4,
        children: <Widget>[
          _PriceRow(price: tier.price, cadence: tier.cadence),
          const CairnSeparator(),
          for (final String feature in tier.features)
            Row(
              children: <Widget>[
                const CairnIcon(CairnIconData.check, size: 14),
                const SizedBox(width: CairnSpacing.s2p5),
                Expanded(child: Text(feature)),
              ],
            ),
        ],
      ),
    ),
    CairnCardFooter(
      children: <Widget>[
        Expanded(
          child: CairnButton(
            variant: tier.featured
                ? CairnButtonVariant.primary
                : CairnButtonVariant.outline,
            expand: true,
            onPressed: _subscribe,
            child: const Text('Get started'),
          ),
        ),
      ],
    ),
  ],
)
```


---

# Team roster block

A member list with avatars and a per-row role select — the pattern every settings screen eventually needs.

Built from: Card, Avatar, Select, Separator, Button

```dart
CairnCard(
  children: <Widget>[
    CairnCardHeader(
      title: const Text('Team members'),
      description: const Text('Invite collaborators and manage access.'),
      action: CairnButton(
        variant: CairnButtonVariant.outline,
        size: CairnButtonSize.sm,
        onPressed: _invite,
        child: const Text('Invite'),
      ),
    ),
    CairnCardContent(
      child: Column(
        children: <Widget>[
          for (final Member member in members)
            Row(
              children: <Widget>[
                CairnAvatar(fallback: Text(member.initials)),
                const SizedBox(width: CairnSpacing.s3),
                Expanded(child: _MemberIdentity(member: member)),
                CairnSelect<String>(
                  value: member.role,
                  width: 130,
                  size: CairnSelectSize.sm,
                  options: roleOptions,
                  onChanged: (String v) => _setRole(member, v),
                ),
              ],
            ),
        ],
      ),
    ),
  ],
)
```

