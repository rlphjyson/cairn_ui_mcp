# Testing

Token extraction makes the first implementation correct. Golden tests are what keep it correct.

### What is tested

| Directory | What it covers |
| --- | --- |
| test/tokens/ | The OKLCH pipeline, the neutral-ramp assertion, the radius formula |
| test/components/ | Behaviour: focus, keyboard, dismissal, sizing |
| test/goldens/ | Every component as a variant sheet, in both themes |

```shell
flutter test                 # 114 tests
flutter analyze --fatal-infos --fatal-warnings
dart format --set-exit-if-changed .
```


### Why goldens are reliable here

Two decisions make golden comparison a signal rather than a source of flakes.

Fonts are bundled, not borrowed from the OS. flutter test loads no real font by default — text lays out with a placeholder where every glyph is an identical box, which tells you nothing about typography. Cairn ships Geist under test/fonts/ and registers it in test/flutter_test_config.dart, so text shapes identically everywhere.

Goldens are generated and verified on one platform. Even with identical fonts, sub-pixel anti-aliasing differs between operating systems. Rather than weaken the comparison with a fuzzy threshold — which would let real regressions through — Cairn enforces goldens on Linux, which is what CI runs. On Windows and macOS the widgets are still built and pumped, so layout errors and exceptions are caught, but the pixel comparison is skipped.

> **Regenerating goldens** Because references must come from the same platform that verifies them, do not run --update-goldens locally on Windows or macOS. Use the "Update goldens" workflow in Actions instead; it re-runs flutter test afterwards to prove the regenerated images actually pass.


### A gotcha worth stealing

Golden capture pumps a fixed number of frames rather than calling pumpAndSettle. Components with repeating animations — Spinner, the Skeleton pulse, the Input OTP caret, indeterminate Progress — never stop scheduling frames, so pumpAndSettle times out. The harness also sets MediaQueryData.disableAnimations, which those components honour, so they render as one deterministic frame.


### This site's own tests

cairn_site does not repeat the library's golden rigour — it is a marketing site, not the design-system source of truth. What it does test is that every route renders without throwing, that the dark theme is what a fresh visitor gets, that the toggle actually reaches the light theme, and that the catalogues are internally consistent: no duplicate slugs, no component whose detail route would 404.