# Quick start

A complete, runnable app in about thirty lines, and the three patterns you will use constantly.

### A complete app

`lib/main.dart`
```dart
import 'package:cairn_ui/cairn_ui.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CairnTheme.materialTheme(CairnTheme.light),
      darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
      themeMode: ThemeMode.dark,
      // The toast host sits above every route, so a toast outlives the
      // screen that fired it.
      builder: (BuildContext context, Widget? child) =>
          CairnToaster(child: child ?? const SizedBox.shrink()),
      home: Scaffold(
        body: Center(
          child: CairnCard(
            width: 360,
            children: <Widget>[
              const CairnCardHeader(
                title: Text('Deploy your project'),
                description: Text('Ship to production in one click.'),
              ),
              CairnCardFooter(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CairnButton(
                    variant: CairnButtonVariant.outline,
                    onPressed: () {},
                    child: const Text('Cancel'),
                  ),
                  CairnButton(onPressed: () {}, child: const Text('Deploy')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```


### Reading tokens

Anywhere you need a colour, a radius or a type style in your own widgets, read it from the theme rather than hardcoding it. This is how everything on this site is built:

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

> **Use theme.radiusScale, not CairnRadius, in app code** CairnRadius.lg is the constant for the default --radius of 10px. theme.radiusScale.lg re-derives it from whatever --radius the active theme carries, so a themed app with a tighter radius keeps your own surfaces proportional instead of leaving them at 10.


### Overlays

Modal surfaces — Dialog, Alert Dialog, Sheet, Drawer — are opened with a show* function that pushes a PopupRoute, which is what gives you focus trapping, focus restore and back-gesture dismissal for free:

```dart
await showCairnDialog<void>(
  context: context,
  builder: (BuildContext context) => CairnDialog(
    title: const Text('Edit profile'),
    content: const CairnFormField(label: 'Name', child: CairnInput()),
    actions: <Widget>[
      CairnButton(onPressed: () => Navigator.pop(context), child: const Text('Save')),
    ],
  ),
);
```

Anchored surfaces — Popover, Dropdown Menu, Tooltip, Hover Card — use OverlayPortal instead, so they stay out of the navigation stack. Those take a CairnOverlayController you own:

```dart
final CairnOverlayController controller = CairnOverlayController();

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

CairnPopover(
  controller: controller,
  content: const CairnPopoverTitle('Dimensions'),
  child: CairnButton(
    onPressed: controller.toggle,
    child: const Text('Open'),
  ),
)
```


### Toasts

Install CairnToaster once in MaterialApp.builder, above the Navigator. Then any widget can fire a toast and it will survive that widget's route being popped.

```dart
CairnToast.show(
  context,
  const CairnToast(
    variant: CairnToastVariant.success,
    title: 'Changes saved',
    description: 'Your profile is up to date.',
  ),
);
```