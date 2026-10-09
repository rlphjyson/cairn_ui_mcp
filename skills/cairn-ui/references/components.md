# Components

| Component | Widgets | Category | What it is |
| --- | --- | --- | --- |
| Button (`button`) | `CairnButton` | Forms | Six variants across eight sizes, with icon and loading forms. |
| Input (`input`) | `CairnInput` | Forms | A single-line text field with leading and trailing slots. |
| Textarea (`textarea`) | `CairnTextarea` | Forms | A multi-line field that grows with its content. |
| Label (`label`) | `CairnLabel` | Forms | A form label with leading-none and a disabled treatment. |
| Checkbox (`checkbox`) | `CairnCheckbox` | Forms | A checkbox with optional indeterminate state. |
| Switch (`switch`) | `CairnSwitch` | Forms | A binary toggle with an animated thumb. |
| Radio Group (`radio-group`) | `CairnRadioGroup`, `CairnRadioItem` | Forms | Mutually exclusive options with roving focus. |
| Slider (`slider`) | `CairnSlider` | Forms | A range control driven by pointer or keyboard. |
| Toggle (`toggle`) | `CairnToggle` | Forms | A button that stays pressed. |
| Toggle Group (`toggle-group`) | `CairnToggleGroup` | Forms | Joined or spaced toggles, single- or multi-select. |
| Input OTP (`input-otp`) | `CairnInputOtp` | Forms | A grouped one-time-code field. |
| Form Field (`form-field`) | `CairnFormField` | Forms | Label, description and error layout around any control. |
| Card (`card`) | `CairnCard`, `CairnCardHeader`, `CairnCardContent`, `CairnCardFooter` | Display | A surface with header, content and footer slots. |
| Badge (`badge`) | `CairnBadge` | Display | A small status pill in five variants. |
| Avatar (`avatar`) | `CairnAvatar`, `CairnAvatarGroup`, `CairnAvatarGroup` | Display | A user image with a persistent fallback, plus a stack group. |
| Alert (`alert`) | `CairnAlert` | Display | An inline banner, default or destructive. |
| Separator (`separator`) | `CairnSeparator` | Display | A hairline rule, horizontal or vertical. |
| Skeleton (`skeleton`) | `CairnSkeleton` | Display | A pulsing placeholder for loading content. |
| Spinner (`spinner`) | `CairnSpinner` | Display | An indeterminate activity indicator. |
| Kbd (`kbd`) | `CairnKbd`, `CairnKbdGroup`, `CairnKbdGroup` | Display | Keyboard key hints, single or grouped. |
| Aspect Ratio (`aspect-ratio`) | `CairnAspectRatio` | Display | Constrains a child to a fixed ratio. |
| Empty (`empty`) | `CairnEmpty` | Display | The zero-state panel, with a dashed border. |
| Table (`table`) | `CairnTable` | Display | A typed, column-driven table with an optional caption. |
| Dialog (`dialog`) | `CairnDialog`, `CairnDialogHeader`, `CairnDialogFooter`, `CairnAlertDialog`, `CairnAlertDialog`, `CairnDialogHeader`, `CairnDialogFooter` | Overlays | A focus-trapped modal, dismissible by Escape or barrier. |
| Alert Dialog (`alert-dialog`) | `CairnDialog`, `CairnDialogHeader`, `CairnDialogFooter`, `CairnAlertDialog` | Overlays | A modal that demands an explicit choice. |
| Sheet (`sheet`) | `CairnSheet`, `CairnDrawer`, `CairnDrawer` | Overlays | A panel that slides in from any of the four edges. |
| Drawer (`drawer`) | `CairnSheet`, `CairnDrawer` | Overlays | A bottom sheet with a grab handle and drag-to-dismiss. |
| Popover (`popover`) | `CairnSurface`, `CairnPopover`, `CairnPopoverTitle`, `CairnPopoverDescription`, `CairnSurface`, `CairnPopoverTitle`, `CairnPopoverDescription` | Overlays | An anchored surface that flips and shifts to stay on screen. |
| Tooltip (`tooltip`) | `CairnTooltip`, `CairnHoverCard` | Overlays | A hint that opens on hover and on keyboard focus. |
| Hover Card (`hover-card`) | `CairnTooltip`, `CairnHoverCard` | Overlays | A rich preview with open and close grace periods. |
| Dropdown Menu (`dropdown-menu`) | `CairnDropdownMenu` | Overlays | An anchored menu with labels, shortcuts and separators. |
| Context Menu (`context-menu`) | `CairnContextMenu` | Overlays | A menu anchored to the pointer on right-click or long-press. |
| Menu (`menu`) | `CairnMenuPanel`, `CairnMenuItem`, `CairnMenuCheckboxItem`, `CairnMenuLabel`, `CairnMenuSeparator`, `CairnMenuPanel`, `CairnMenuItem`, `CairnMenuCheckboxItem`, `CairnMenuLabel`, `CairnMenuSeparator` | Overlays | The panel, item, checkbox item, label and separator primitives. |
| Select (`select`) | `CairnSelect` | Overlays | A trigger whose menu matches its width. |
| Combobox (`combobox`) | `CairnCombobox` | Overlays | A select with a search field over the options. |
| Command (`command`) | `CairnCommand` | Overlays | A Ctrl+K palette with grouping and keyword matching. |
| Tabs (`tabs`) | `CairnTabs` | Navigation | Filled and line variants with roving focus. |
| Accordion (`accordion`) | `CairnAccordion`, `CairnCollapsible`, `CairnCollapsible` | Navigation | Single or multiple disclosure sections. |
| Collapsible (`collapsible`) | `CairnAccordion`, `CairnCollapsible` | Navigation | The single-section primitive underneath Accordion. |
| Breadcrumb (`breadcrumb`) | `CairnBreadcrumb`, `CairnBreadcrumbEllipsis`, `CairnBreadcrumbEllipsis` | Navigation | A trail with a current-page crumb and an ellipsis form. |
| Pagination (`pagination`) | `CairnPagination` | Navigation | A windowed page range with ellipses. |
| Menubar (`menubar`) | `CairnMenubar`, `CairnNavigationMenu`, `CairnNavigationMenu` | Navigation | A desktop menu bar with hover-to-switch behaviour. |
| Navigation Menu (`navigation-menu`) | `CairnMenubar`, `CairnNavigationMenu` | Navigation | A top-level nav with arbitrary dropdown panels. |
| Scroll Area (`scroll-area`) | `CairnScrollArea` | Navigation | A scroller with a thumb drawn from the theme's tokens. |
| Carousel (`carousel`) | `CairnCarousel` | Navigation | A paged viewport with controls and indicators. |
| Progress (`progress`) | `CairnProgress` | Data & feedback | Determinate and indeterminate progress bars. |
| Toast (`toast`) | `CairnToaster`, `CairnToaster` | Data & feedback | Stacked notifications that outlive the route that fired them. |
| Data Table (`data-table`) | `CairnDataTable` | Data & feedback | Sorting, filtering and pagination on top of Table. |
| Calendar (`calendar`) | `CairnCalendar` | Data & feedback | A month grid on a fixed 7 x 6 layout. |
| Date Picker (`date-picker`) | `CairnDatePicker` | Data & feedback | A Calendar inside a Popover, behind a formatted trigger. |
| Rating (`rating`) | `CairnRating` | Forms | A star rating with half steps and keyboard control. |
| Swap (`swap`) | `CairnSwap` | Forms | A controlled two-face toggle with fade, rotate and flip. |
| File Input (`file-input`) | `CairnFileInput` | Forms | A file field that draws the control and leaves picking to you. |
| Floating Action Button (`fab`) | `CairnFab`, `CairnFabAction` | Forms | A round action button that can open into a speed dial. |
| Stat (`stat`) | `CairnStat`, `CairnStats`, `CairnStats` | Display | A figure with its label and context, grouped by Stats. |
| Status (`status`) | `CairnStatus` | Display | A small tone dot, optionally pulsing. |
| Timeline (`timeline`) | `CairnTimeline`, `CairnTimelineItem` | Display | Events on a marker rail with a connecting hairline. |
| Chat Bubble (`chat-bubble`) | `CairnChatBubble` | Display | A message bubble that aligns itself by sender. |
| Indicator (`indicator`) | `CairnIndicator` | Display | A badge or dot pinned to a corner of its child. |
| Stack (`stack`) | `CairnStack` | Display | Overlapping layers, or an avatar pile. |
| Hero (`hero`) | `CairnHero` | Display | A landing-page header with eyebrow, actions and a 36rem measure. |
| Diff (`diff`) | `CairnDiff` | Display | A draggable before-and-after comparison. |
| List (`list`) | `CairnList`, `CairnListItem`, `CairnListItem` | Display | Rows with leading, trailing and selected states. |
| Mockup (`mockup`) | `CairnMockupWindow`, `CairnMockupBrowser`, `CairnMockupCode`, `CairnMockupPhone`, `CairnMockupWindow`, `CairnMockupBrowser`, `CairnMockupCode`, `CairnMockupPhone` | Display | Window, browser, code and phone frames for showcasing content. |
| Steps (`steps`) | `CairnSteps`, `CairnStep` | Navigation | A progress rail for multi-step flows. |
| Navbar (`navbar`) | `CairnNavbar` | Navigation | A top bar with start, centre and end slots. |
| Dock (`dock`) | `CairnDock`, `CairnDockItem` | Navigation | A 64px bottom navigation bar for mobile. |
| Link (`link`) | `CairnLink` | Navigation | A text link with muted and underline options. |
| Radial Progress (`radial-progress`) | `CairnRadialProgress` | Data & feedback | An animated progress ring. |
| Countdown (`countdown`) | `CairnCountdown`, `CairnCountdownDigits`, `CairnCountdownDigits` | Data & feedback | A ticking countdown that shows only the units it needs. |

70 components. Call `get_component` with a name or slug for the full API.
