---
name: cairn-templates
description: Start Flutter apps and sites from the ready-made Cairn UI templates (e-commerce, dashboard, blog, documentation, SaaS landing and more): choose the right template, add it as a package or copy it, mount it, rebrand it, swap its in-memory data for a real backend and migrate it. Use when the user wants a whole app, a starter or a full-page layout built with Cairn (cairn_ui), or asks for a store, dashboard, blog, docs site, landing page, auth, chat, onboarding or settings app.
---

# Cairn templates

Each template is a standalone Flutter package in the `templates/` folder of the cairn_site repository (https://github.com/rlphjyson/cairn_site). It has its own `pubspec.yaml`, assets, tests, README and an HTML tutorial (`doc/index.html`). All are built only from Cairn components and tokens, organised as clean architecture (layers at the top of `lib/`, features inside each layer), with `flutter_bloc` and `get_it`, and nothing generated.

Read `references/templates.md` for the current list and what each contains, and the per-template file in `references/templates/` before changing one.

## Choosing

| The user wants | Template |
| --- | --- |
| A shop on a phone | `shop` (mobile) |
| Analytics, KPIs, admin | `dashboard` (web) |
| Articles, a journal | `blog` (web) |
| Product documentation | `docs` (web) |
| A product marketing page | `landing` (web) |

If more templates are listed in `references/templates.md`, prefer the closest one.

## Use a template

1. **Add it.** As a package (so updates are a version bump):
   ```yaml
   dependencies:
     cairn_ui: ^0.2.0
     cairn_template_shop:
       git:
         url: https://github.com/rlphjyson/cairn_site.git
         path: templates/shop
         ref: main          # pin a tag or commit for production
   ```
   Or copy `templates/<name>/lib` into the app (and `assets/` if it has one), rewrite the `package:cairn_template_<name>/` imports, and set the `<Name>Package.name` constant to `null` so images resolve against the host app's assets.
2. **Mount it.** The host must provide a Cairn theme:
   ```dart
   MaterialApp(
     theme: CairnTheme.materialTheme(CairnTheme.light),
     darkTheme: CairnTheme.materialTheme(CairnTheme.dark),
     home: const Scaffold(body: ShopApp()),   // DashboardApp, BlogApp, DocsApp, LandingApp
   )
   ```
   Web templates fill the space their parent gives them; give them a `Scaffold` body or a bounded box.
3. **Change the content.** Each template keeps its content in `data/<feature>/remote/*` as in-memory data sources that return decoded JSON (mapped by `domain/<feature>/mappers`). Edit the literals first; the template's `doc/index.html` has the JSON shape tables.
4. **Rebrand.** Names and brand constants live under `common/constants`; colours, radius and fonts come from your `CairnTheme` (`copyWith`).
5. **Connect a real backend.** Write a class that implements the same `...RemoteDataSource` interface using your HTTP client, then replace its registration in `core/infrastructure/di/<name>_injection.dart`. Nothing in domain or presentation changes. Some templates also accept data sources as constructor arguments.
6. **Routing.** Templates navigate with their own small cubit so they run in any app. To use `go_router`, replace that cubit and keep the views (each tutorial shows how).
7. **Verify.** `flutter analyze` and run the template's own tests: `cd templates/<name> && flutter test`.

## Rules

- Do not rewrite a template's architecture. Add features in the same layout: models, mappers, repository interface, use case, data source, repository, cubit, view model, view.
- Views never read the DI container; screen-scoped cubits come from `ViewModelBuilder`, session cubits from `context.read`.
- Keep photographs' credits: each template folder has a `NOTICE.md` with the source and licence of its images.
- Follow the `cairn-ui` skill for any new UI inside a template.
