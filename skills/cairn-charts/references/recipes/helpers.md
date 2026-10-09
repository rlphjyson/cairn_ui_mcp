# Helpers the recipes use

## Axis scale

```dart
import 'dart:math' as math;

/// Rounds [value] up to a "nice" axis maximum (1, 2, 2.5, 5 or 10 times a
/// power of ten), so grid lines land on readable numbers.
double niceCeil(double value) {
  if (value <= 0) return 1;
  final double magnitude = math
      .pow(10, (math.log(value) / math.ln10).floor())
      .toDouble();
  for (final double step in <double>[1, 2, 2.5, 5, 10]) {
    if (value <= step * magnitude) return step * magnitude;
  }
  return 10 * magnitude;
}
```

## Number formatting

```dart
/// Number formatting for the dashboard.
abstract final class DashboardFormat {
  /// `31200` -> `31,200`.
  static String number(num value) {
    final String digits = value.round().abs().toString();
    final StringBuffer out = StringBuffer(value < 0 ? '-' : '');
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) out.write(',');
      out.write(digits[i]);
    }
    return out.toString();
  }

  /// `31200` -> `$31,200`.
  static String currency(num value) => '\$${number(value)}';

  /// `31200` -> `31.2k`, `950` -> `950`. For chart axes.
  static String compact(num value) {
    if (value.abs() >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value.abs() >= 1000) {
      final double k = value / 1000;
      return '${k == k.roundToDouble() ? k.toInt() : k.toStringAsFixed(1)}k';
    }
    return value.round().toString();
  }

  /// `3.24` -> `3.2%`.
  static String percent(num value, {int decimals = 1}) =>
      '${value.toStringAsFixed(decimals)}%';

  /// `12.5` -> `+12.5%`, `-3` -> `-3.0%`.
  static String signedPercent(num value) =>
      '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
}
```

## Legend row

```dart
import 'package:cairn_ui/cairn_ui.dart';
import 'package:flutter/widgets.dart';

import '../dashboard_text.dart';

/// A coloured swatch, a label and an optional value, for chart legends.
class LegendRow extends StatelessWidget {
  /// Creates a row.
  const LegendRow({
    super.key,
    required this.color,
    required this.label,
    this.value,
    this.labelWidth = 76,
  });

  /// The series colour.
  final Color color;

  /// The series name.
  final String label;

  /// A figure shown after the label.
  final String? value;

  /// Fixed label width, so values line up in a column.
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final CairnTheme theme = CairnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(theme.radiusScale.sm / 2),
          ),
        ),
        const SizedBox(width: CairnSpacing.s2p5),
        SizedBox(
          width: value == null ? null : labelWidth,
          child: Text(
            label,
            style: dashText(
              theme,
              theme.textStyle(CairnTypography.sm),
              color: theme.mutedForeground,
            ),
          ),
        ),
        if (value != null)
          Text(
            value!,
            style: dashText(
              theme,
              theme.textStyle(CairnTypography.sm),
              weight: CairnTypography.medium,
            ),
          ),
      ],
    );
  }
}
```

## Text style helper

```dart
import 'package:cairn_ui/cairn_ui.dart';
import 'package:flutter/widgets.dart';

/// A Cairn text style with the template's defaults applied. Every colour comes
/// from [CairnTheme], so light and dark need no extra code.
TextStyle dashText(
  CairnTheme theme,
  TextStyle base, {
  Color? color,
  FontWeight? weight,
  double? height,
}) => base.copyWith(
  color: color ?? theme.foreground,
  fontWeight: weight,
  height: height,
);
```
