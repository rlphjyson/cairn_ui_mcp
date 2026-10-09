# Accessibility

Looking right is the easy half. Focus, keyboard operation and screen-reader semantics are part of each component's contract in Cairn, not a pass somebody makes later.

### Focus-visible, not focus

Cairn draws its focus ring on focus-visible rather than focus: clicking a button must not show a ring, while tabbing to it must. Flutter's hasFocus cannot distinguish the two. CairnInteractive combines focus state with FocusManager.highlightMode and tracks whether the focus change came from a pointer press.

> **Try it** Click the button below — no ring. Then press Tab to move focus to it — a 3px ring at 50% alpha appears. That distinction is the difference between a focus indicator that helps keyboard users and one that looks like a rendering bug to mouse users.


### Keyboard

- Space and Enter both activate, wired through ActivateIntent so it composes with a host app's own shortcuts.
- Roving focus in Radio Group and Tabs: one tab stop for the group, arrow keys to move within it.
- Slider supports arrow keys plus Home and End, and exposes increase/decrease actions with correct increasedValue and decreasedValue announcements.
- Escape dismisses every overlay — except Alert Dialog, which by design demands an explicit choice.
- The Command palette keeps focus in its input while arrow keys move a highlight through the list, so typing and navigating never compete for the same keystrokes.


### Focus trapping and restore

Dialog, Alert Dialog, Sheet and Drawer push a PopupRoute, which gets Flutter's per-route FocusScope — so focus is trapped while they are open and restored to the trigger when they close. It also brings back-gesture dismissal, which a web implementation has no equivalent of. Anchored surfaces (Popover, Dropdown Menu) use OverlayPortal instead, so they stay out of the navigation stack and the system back gesture does not close them.


### Pointer events and disabled state

disabled:pointer-events-none genuinely removes the subtree from hit testing rather than just making the component itself inert. A disabled button with a tooltip wrapped around it will not show the tooltip, which is the correct web behaviour and is easy to get wrong in Flutter.


### Reduced motion

Skeleton, Spinner and the Input OTP caret honour MediaQuery.disableAnimations. That is also what makes golden tests possible: those components never stop scheduling frames, so the golden harness sets disableAnimations and captures one deterministic frame instead of timing out in pumpAndSettle.


### Semantics

Controls that have no visible label take a semanticLabel: icon buttons require one, and Switch, Slider, Progress and Avatar all accept one. Separator is decorative by default so screen readers skip it; pass decorative: false when the rule carries meaning. Breadcrumb announces its current crumb as the current page rather than rendering a dead link.