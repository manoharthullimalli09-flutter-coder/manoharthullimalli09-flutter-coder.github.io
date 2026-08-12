# Manohar Thullimalli — Flutter Portfolio

**Live: [manoharthullimalli09-flutter-coder.github.io](https://manoharthullimalli09-flutter-coder.github.io)**

A cross-platform portfolio built in Flutter, running from a single codebase on
Web, Android, iOS, macOS, Windows and Linux.

The site is the artifact. Rather than describing Flutter experience, it
demonstrates it — Clean Architecture across four features, BLoC throughout,
a fully tested presentation layer, and a responsive layout that holds from
375px to 1920px.

---

## Architecture

Three layers per feature, with dependencies pointing inward only:

```
Presentation  →  Domain  ←  Data
(BLoC, widgets)  (Entities,      (Models, DataSources,
                  UseCases,       Repository impls)
                  Repo interfaces)
```

| Decision | Why |
|---|---|
| **BLoC / Cubit only** | One state management story, no `setState` for business logic. `StatefulWidget` appears only where an `AnimationController` lifecycle demands it. |
| **`Either<Failure, T>`** (dartz) | Repositories never throw across a layer boundary. Exceptions are mapped to typed `Failure`s in the data layer. |
| **`get_it` injection** | Everything wired in `injection_container.dart`. BLoCs depend on abstract UseCases, UseCases on abstract Repositories — so tests substitute mocks at any boundary. |
| **Content from JSON** | All projects, skills and bio load from `assets/data/portfolio_data.json`. No backend, no database, zero hosting cost. |
| **EmailJS for contact** | The one network call in the app. No server to run or pay for. |

```
lib/
├── core/            config · constants · errors · extensions · router · theme · usecases · widgets
├── features/
│   ├── hero/        ─┐
│   ├── projects/     │  each: domain/ (entities, repositories, usecases)
│   ├── skills/       │        data/   (models, datasources, repositories)
│   └── contact/     ─┘        presentation/ (bloc, widgets)
│   ├── home/                  portfolio_page.dart — scroll shell
│   └── theme_switcher/        ThemeCubit (persisted via SharedPreferences)
└── injection_container.dart
```

## Stack

**Flutter** · **BLoC / Cubit** · **Clean Architecture** · `get_it` · `dartz` ·
`go_router` · `dio` · `shared_preferences` · `google_fonts` · `intl` (en + hi) ·
`flutter_test` · `bloc_test` · `mocktail`

## Notable implementation details

- **Coordinated card hover** — a row of project cards shares one width tween.
  The hovered card takes a larger share, its siblings give the same amount
  back, and the shares always sum to a constant so the row can never overflow
  mid-animation. Artwork scales on all sides while panels stay level.
- **`CustomPainter` particle field** behind the hero, wrapped in a
  `RepaintBoundary`.
- **Frosted navbar** mounted only while scrolled — a `BackdropFilter` costs a
  `saveLayer` every frame even at sigma 0.
- **`PathUrlStrategy`** — clean web URLs, no `#` fragment.
- **Dark and light themes** built from one palette, toggled live and persisted.

## Running

```bash
flutter pub get
flutter run -d chrome --target lib/main_dev.dart   # web (primary target)
flutter run -d windows --target lib/main_dev.dart  # or macos / linux / a device id
```

Two flavors — `lib/main_dev.dart` and `lib/main_prod.dart` — select config
(EmailJS IDs, logging) through `AppConfig`, so no `kDebugMode` checks leak into
business logic.

## Tests

```bash
flutter test              # 84 tests
flutter test --coverage
flutter analyze           # 0 issues
```

Every layer is covered at its own boundary: UseCases against mock
repositories, repositories against mock data sources, BLoCs against mock
UseCases via `bloc_test`, and widgets against real BLoCs with mocked
dependencies. Mocks are `mocktail` — no codegen step.

## Deployment

Pushing to `main` runs [`deploy_web.yml`](.github/workflows/deploy_web.yml):
analyze → test → build (prod flavor, `--tree-shake-icons`) → publish to GitHub
Pages. The build is gated on the tests passing.

```bash
flutter build web --release --target lib/main_prod.dart --base-href "/" --tree-shake-icons
```

---

**Manohar Thullimalli** — Senior Flutter Developer
[GitHub](https://github.com/manoharthullimalli09-flutter-coder) ·
[LinkedIn](https://www.linkedin.com/in/manohar-t-68a32231a)
