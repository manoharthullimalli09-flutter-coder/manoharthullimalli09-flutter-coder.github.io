# Flutter Portfolio — Manohar Thullimalli

## Project Purpose

This is a **cross-platform Flutter portfolio application** that showcases Manohar Thullimalli's 5+ years of professional Flutter experience to recruiters and hiring managers. It runs natively on Android, iOS, Web, and Desktop (macOS/Windows/Linux) from a single codebase — itself a demonstration of cross-platform mastery.

The app IS the resume. Every architectural decision, animation, and responsive layout choice communicates competence.

**Primary target: Web** — the website is the recruiter's first touchpoint and must be free to host, fast to load, and flawless to use. All other platforms are first-class but web drives every design decision.

---

## Developer Profile

**Manohar Thullimalli** — Senior Flutter Developer  
Email: manohar.professional.flutter@gmail.com  
Experience: 5+ years professional Flutter development  
Platforms shipped: Android · iOS · Web · macOS · Windows · Linux

### Domain Experience
- **E-commerce & Marketplace** — product listings, cart, payments (Stripe, Razorpay), order management
- **Enterprise / B2B SaaS** — Healthcare (patient records, appointments), FinTech (invoicing, payments), Logistics (tracking, delivery), HR & Productivity dashboards
- **Social & Community** — real-time chat, activity feeds, user profiles, notifications

### Tech Stack
| Category | Technologies |
|---|---|
| State Management | BLoC / Cubit · Riverpod · Provider · GetX |
| Backend & Services | Firebase (Auth, Firestore, Cloud Messaging) · REST APIs · Dio · http |
| Architecture | Clean Architecture · SOLID · Repository pattern |
| Testing | Unit tests · Widget tests · Integration tests · TDD |
| Advanced Flutter | CustomPainter · AnimationController · Lottie · Hero transitions |
| Native Integration | MethodChannel · EventChannel · FFI · platform-specific plugins |
| CI/CD | GitHub Actions · Codemagic · Fastlane · Bitrise |
| Publishing | Google Play Store (live) · Apple App Store (live) |

---

## Portfolio App — Feature Specification

### Sections
1. **Hero / About Me** — animated intro, photo, tagline, quick-stat counters (years, projects, platforms)
2. **Projects Showcase** — cards with screenshots, platform badges, tech stack chips, and live demo/store links
3. **Skills & Tech Stack** — animated skill bars grouped by category (Flutter, State Mgmt, Backend, DevOps)
4. **Contact / Hire Me** — contact form, resume PDF download, social media links

### Design System
- **Theme**: Dark & minimal — tech-forward aesthetic
- **Color palette**: Deep dark background (`#0D0D0D`), primary accent (`#6C63FF` purple-indigo), secondary (`#00D4FF` cyan), surface cards with subtle glass borders
- **Typography**: Inter or Google Fonts — clean, modern, highly legible
- **Dark/Light mode toggle**: Full theming via `ThemeData`, persisted with SharedPreferences

### Technical Wow Factors (for recruiter impression)
- **Smooth scroll animations**: Staggered fade-in on scroll, hero transitions between sections
- **Fully responsive layout**: Adaptive breakpoints for mobile (< 600px), tablet (600–1024px), desktop (> 1024px) — single `ResponsiveLayout` widget
- **Dark/Light mode**: Live toggle without app restart, theme persisted across sessions
- **Localization (l10n)**: English + at least one additional language via Flutter's `intl` package and ARB files
- **Performance**: Lazy-loaded project cards, cached network images, 60fps animations
- **Custom painter**: At least one section uses `CustomPainter` for visual flair (e.g., animated background particles or skill-ring charts)

---

## Architecture

### Mandatory: BLoC + Clean Architecture

**BLoC is the only state management used in this project.** No GetX, no Riverpod, no raw setState for business logic. Every feature has its own BLoC or Cubit. This demonstrates disciplined architecture to senior engineering reviewers.

**Clean Architecture is enforced across all features.** The codebase is split into three layers — Presentation, Domain, and Data — with strict dependency rules: outer layers depend on inner layers, never the reverse.

```
Presentation  →  Domain  ←  Data
(BLoC, UI)       (Entities, UseCases, Repo interfaces)   (Models, Repo impls, DataSources)
```

### SOLID Principles — Applied Explicitly

| Principle | How it applies in this project |
|---|---|
| **S** — Single Responsibility | Each BLoC handles one feature only. Each UseCase does exactly one thing. Each widget renders one piece of UI. |
| **O** — Open/Closed | New portfolio sections are added by creating a new feature folder — zero changes to existing code. |
| **L** — Liskov Substitution | `PortfolioRepository` (abstract) is safely substitutable by `PortfolioRepositoryImpl` or `MockPortfolioRepository` in tests. |
| **I** — Interface Segregation | Repositories expose only the methods each feature actually needs — no fat interfaces. |
| **D** — Dependency Inversion | BLoCs depend on abstract `UseCase` and `Repository` interfaces injected via constructor — never on concrete `Impl` classes. |

### Clean Architecture Folder Structure

```
lib/
├── core/
│   ├── config/               # AppConfig (flavor enum, EmailJS keys, logging flag)
│   ├── constants/            # AppColors, AppBreakpoints, AppSizes
│   ├── errors/               # Failure hierarchy: ServerFailure, CacheFailure, NetworkFailure, ValidationFailure
│   ├── extensions/           # ContextExtensions (isMobile, isTablet, isDesktop, screenWidth…)
│   ├── router/               # app_router.dart — GoRouter with PathUrlStrategy, AppRoutes constants
│   ├── theme/                # AppTheme.dark() / AppTheme.light() — full Material 3 ThemeData
│   ├── usecases/             # UseCase<Type, Params> abstract + NoParams
│   ├── utils/                # ResponsiveUtil, ResponsiveLayout widget
│   └── widgets/              # Shared UI: GlassCard, SectionHeader, GradientText, AnimatedCounter, PortfolioNavBar
│
├── features/
│   ├── hero/
│   │   ├── domain/
│   │   │   ├── entities/     # DeveloperEntity (Equatable, pure Dart)
│   │   │   ├── repositories/ # HeroRepository (abstract)
│   │   │   └── usecases/     # GetDeveloperInfoUseCase
│   │   ├── data/
│   │   │   ├── models/       # DeveloperModel (fromJson, toJson, copyWith)
│   │   │   ├── datasources/  # HeroLocalDataSource / Impl (rootBundle → portfolio_data.json)
│   │   │   └── repositories/ # HeroRepositoryImpl → Either<Failure, DeveloperEntity>
│   │   └── presentation/
│   │       ├── bloc/         # HeroBloc, HeroEvent (LoadDeveloperInfo), HeroState (Initial/Loading/Loaded/Error)
│   │       └── widgets/      # HeroSection, HeroAvatar (glow rings), AnimatedTagline (typewriter), _StatRow (AnimatedCounter)
│   │
│   ├── projects/
│   │   ├── domain/
│   │   │   ├── entities/     # ProjectEntity (Equatable)
│   │   │   ├── repositories/ # ProjectsRepository (abstract)
│   │   │   └── usecases/     # GetProjectsUseCase, FilterProjectsByPlatformUseCase
│   │   ├── data/
│   │   │   ├── models/       # ProjectModel (fromJson, toJson)
│   │   │   ├── datasources/  # ProjectsLocalDataSource / Impl
│   │   │   └── repositories/ # ProjectsRepositoryImpl (filter runs in-memory)
│   │   └── presentation/
│   │       ├── bloc/         # ProjectsBloc (LoadProjects, FilterByPlatform, ClearFilter), caches _allProjects
│   │       └── widgets/      # ProjectsSection (filter chips), ProjectCard (hover lift, category gradient, platform badges, tech chips)
│   │
│   ├── skills/
│   │   ├── domain/
│   │   │   ├── entities/     # SkillEntity, SkillCategoryEntity (Equatable)
│   │   │   ├── repositories/ # SkillsRepository (abstract)
│   │   │   └── usecases/     # GetSkillsUseCase
│   │   ├── data/
│   │   │   ├── models/       # SkillModel, SkillCategoryModel (fromJson)
│   │   │   ├── datasources/  # SkillsLocalDataSource / Impl
│   │   │   └── repositories/ # SkillsRepositoryImpl
│   │   └── presentation/
│   │       ├── bloc/         # SkillsCubit (loadSkills), SkillsState (Initial/Loading/Loaded/Error)
│   │       └── widgets/      # SkillsSection, _SkillCategoryCard, _AnimatedSkillBar (1200ms ease-out, color lerp primary→cyan)
│   │
│   ├── contact/
│   │   ├── domain/
│   │   │   ├── entities/     # ContactFormEntity (Equatable)
│   │   │   ├── repositories/ # ContactRepository (abstract)
│   │   │   └── usecases/     # SubmitContactFormUseCase
│   │   ├── data/
│   │   │   ├── models/       # ContactFormModel (fromEntity, toEmailJsParams)
│   │   │   ├── datasources/  # ContactRemoteDataSource / Impl (Dio → EmailJS REST)
│   │   │   └── repositories/ # ContactRepositoryImpl (DioException → Failure mapping)
│   │   └── presentation/
│   │       ├── bloc/         # ContactBloc (SubmitContactForm, ResetContactForm), ContactState
│   │       └── widgets/      # ContactSection (desktop side-by-side / mobile stacked), _ContactForm (validated), _SuccessView
│   │
│   ├── home/
│   │   └── presentation/
│   │       └── portfolio_page.dart   # Full scroll shell: CustomScrollView + Stack NavBar overlay, RepaintBoundary per section, _Footer
│   │
│   └── theme_switcher/
│       └── presentation/
│           └── bloc/         # ThemeCubit (toggleTheme, persists via SharedPreferences)
│
├── injection_container.dart  # get_it: External → DataSources → Repos → UseCases → BLoC factories
├── portfolio_app.dart        # MaterialApp.router — ThemeCubit wrapper, l10n delegates, dark/light themes
├── main_dev.dart             # Flavor.dev entry point
├── main_prod.dart            # Flavor.prod entry point
├── l10n/                     # app_en.arb, app_hi.arb + generated app_localizations.dart
└── l10n.yaml                 # arb-dir, template, output config
│
assets/
├── images/                   # profile.jpg, project screenshots (webp preferred)
├── resume/                   # Manohar_Thullimalli_Resume.pdf
└── data/
    └── portfolio_data.json   # developer, projects (6), skillCategories (5) — single source of truth
│
web/
└── index.html                # SEO meta, OG/Twitter cards, branded loader (MT. gradient spinner)
│
.github/
└── workflows/
    └── deploy_web.yml        # test → analyze → build web (prod flavor) → deploy to GitHub Pages
```

### Dependency Injection — get_it

`get_it` is the service locator for this project. It is appropriate here because:
- The app has no user auth or complex scoping — a simple global locator is sufficient
- It pairs cleanly with Clean Architecture: register once in `injection_container.dart`, inject everywhere via constructor
- BLoCs are **not** registered in get_it (they are scoped to feature widgets via `BlocProvider`); everything else is

Registration order in `injection_container.dart`:
```dart
// 1. External (Dio client, SharedPreferences)
sl.registerLazySingleton(() => Dio()..options = BaseOptions(baseUrl: AppConfig.emailJsBaseUrl));
final prefs = await SharedPreferences.getInstance();
sl.registerLazySingleton(() => prefs);

// 2. Data sources
sl.registerLazySingleton<HeroLocalDataSource>(() => HeroLocalDataSourceImpl());
sl.registerLazySingleton<ContactRemoteDataSource>(() => ContactRemoteDataSourceImpl(sl()));

// 3. Repositories
sl.registerLazySingleton<HeroRepository>(() => HeroRepositoryImpl(sl()));
sl.registerLazySingleton<ContactRepository>(() => ContactRepositoryImpl(sl()));

// 4. Use cases
sl.registerLazySingleton(() => GetDeveloperInfoUseCase(sl()));
sl.registerLazySingleton(() => SubmitContactFormUseCase(sl()));

// 5. BLoCs — registered as Factory (new instance per feature screen)
sl.registerFactory(() => HeroBloc(getDeveloperInfo: sl()));
sl.registerFactory(() => ContactBloc(submitForm: sl()));
sl.registerFactory(() => ThemeCubit(prefs: sl()));
```

- BLoCs are provided at the feature widget level via `BlocProvider(create: (_) => sl<XBloc>())`
- Never call `sl<XBloc>()` inside a widget's `build()` method — only inside `BlocProvider.create`

### Flavor Setup

Two flavors: **dev** and **prod**. The same codebase, different configuration — no `if (kDebugMode)` scattered across business logic.

#### Flavor Config Class
```dart
// lib/core/config/app_config.dart
enum Flavor { dev, prod }

class AppConfig {
  static late Flavor flavor;

  static String get emailJsBaseUrl => switch (flavor) {
    Flavor.dev  => 'https://api.emailjs.com',   // same URL, different service ID
    Flavor.prod => 'https://api.emailjs.com',
  };

  static String get emailJsServiceId => switch (flavor) {
    Flavor.dev  => 'service_dev_xxxx',
    Flavor.prod => 'service_prod_xxxx',
  };

  static bool get enableLogging => flavor == Flavor.dev;
  static String get appName => flavor == Flavor.dev ? 'Portfolio DEV' : 'Manohar Thullimalli';
}
```

#### Flavor Entry Points
```
lib/
├── main_dev.dart     # AppConfig.flavor = Flavor.dev; runApp(...)
└── main_prod.dart    # AppConfig.flavor = Flavor.prod; runApp(...)
```

```dart
// main_dev.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.flavor = Flavor.dev;
  await initDependencies();
  runApp(const PortfolioApp());
}

// main_prod.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.flavor = Flavor.prod;
  await initDependencies();
  runApp(const PortfolioApp());
}
```

#### Running with Flavors
```bash
# Development
flutter run -d chrome --target lib/main_dev.dart

# Production (web deploy)
flutter build web --release --target lib/main_prod.dart --base-href "/" --tree-shake-icons

# Production (Android)
flutter build apk --release --target lib/main_prod.dart --split-per-abi

# Production (iOS)
flutter build ios --release --target lib/main_prod.dart
```

#### GitHub Actions — always builds prod
```yaml
- run: flutter build web --release --target lib/main_prod.dart --base-href "/" --tree-shake-icons
```

#### Dio Interceptors per Flavor
```dart
// In injection_container.dart
final dio = Dio()
  ..options = BaseOptions(baseUrl: AppConfig.emailJsBaseUrl, connectTimeout: const Duration(seconds: 10))
  ..interceptors.addAll([
    if (AppConfig.enableLogging) LogInterceptor(requestBody: true, responseBody: true),
    ErrorInterceptor(),   // maps DioException → Failure types
  ]);
sl.registerLazySingleton(() => dio);
```

### Data Strategy
- All portfolio content (projects, skills, developer info) loaded from `assets/data/portfolio_data.json` — zero network cost for core content, works offline, works on GitHub Pages
- Contact form POSTs to **EmailJS** (free tier: 200 emails/month) via `Dio` — no backend server needed
- No Firebase, no database, no server costs — fully static and free to host
- `AppConfig.emailJsServiceId` and `emailJsTemplateId` differ per flavor so dev submissions go to a test inbox

---

## Testing Strategy

Every layer of Clean Architecture has its own test type. Tests are **not optional** — every feature ships with tests.

### Test Coverage Targets
| Layer | Test Type | Tool | Coverage Goal |
|---|---|---|---|
| Domain — UseCases | Unit tests | `flutter_test` + `mocktail` | 100% |
| Domain — Entities | Unit tests | `flutter_test` | 100% |
| Data — Models | Unit tests (fromJson/toJson) | `flutter_test` | 100% |
| Data — DataSources | Unit tests with mocked file I/O / HTTP | `mocktail` | 90%+ |
| Data — Repositories | Unit tests with mocked DataSources | `mocktail` | 90%+ |
| Presentation — BLoC | BLoC tests (event → state sequences) | `bloc_test` | 100% |
| Presentation — Widgets | Widget tests (pump, find, interact) | `flutter_test` | 80%+ |
| End-to-end | Integration tests (web + mobile) | `integration_test` | Golden paths |

### Test Folder Structure

```
test/
├── core/
│   ├── utils/                    # responsive_util_test.dart, validators_test.dart
│   └── errors/                   # failure_test.dart
│
├── features/
│   ├── projects/
│   │   ├── domain/
│   │   │   ├── usecases/         # get_projects_usecase_test.dart
│   │   │   └── entities/         # project_entity_test.dart
│   │   ├── data/
│   │   │   ├── models/           # project_model_test.dart (fromJson, toJson, equality)
│   │   │   ├── datasources/      # projects_local_datasource_test.dart
│   │   │   └── repositories/     # projects_repository_impl_test.dart
│   │   └── presentation/
│   │       ├── bloc/             # projects_bloc_test.dart
│   │       └── widgets/          # projects_section_test.dart, project_card_test.dart
│   │
│   ├── hero/                     # same pattern as projects/
│   ├── skills/                   # same pattern
│   └── contact/                  # same pattern + form validation tests
│
├── helpers/
│   ├── mock_repository.dart      # shared MockPortfolioRepository, MockContactRepository
│   ├── test_data.dart            # fixture JSON strings, test entities, test models
│   └── pump_app.dart             # pumpApp() helper that wraps with BlocProvider + theme
│
└── integration_test/
    ├── app_test.dart             # full app smoke test: scroll all sections, theme toggle
    └── contact_form_test.dart    # fill form, submit, verify state
```

### Testing Rules
1. **Mock at the boundary** — mock repositories in UseCase tests, mock DataSources in Repository tests, mock UseCases in BLoC tests. Never mock the class under test.
2. **Use `mocktail`** — no `Mockito` codegen needed; `registerFallbackValue` for custom types.
3. **Model equality** — every Model and Entity overrides `==` and `hashCode` via `Equatable`; test equality and `copyWith`.
4. **BLoC test sequences** — test the full `[InitialState, LoadingState, LoadedState]` sequence for every event; also test error paths (`[InitialState, LoadingState, ErrorState]`).
5. **Widget tests pump real BLoC** — use `MockUseCase` + `BlocProvider` in widget tests, never mock the BLoC itself.
6. **No network in tests** — all tests run offline; contact form DataSource is mocked to return `Either.right(unit)` or `Either.left(ServerFailure())`.
7. **Test JSON fixtures** — store raw JSON strings in `test/helpers/test_data.dart`; test `Model.fromJson()` against them so parsing regressions are caught immediately.

### Example Test Shapes

```dart
// UseCase unit test
test('returns List<ProjectEntity> on success', () async {
  when(() => mockRepo.getProjects()).thenAnswer((_) async => Right(tProjects));
  final result = await usecase(NoParams());
  expect(result, Right(tProjects));
  verify(() => mockRepo.getProjects()).called(1);
});

// BLoC test
blocTest<ProjectsBloc, ProjectsState>(
  'emits [Loading, Loaded] when LoadProjects is added',
  build: () => ProjectsBloc(getProjects: mockGetProjects),
  act: (bloc) => bloc.add(LoadProjects()),
  expect: () => [ProjectsLoading(), ProjectsLoaded(projects: tProjects)],
);

// Model fromJson test
test('ProjectModel.fromJson produces correct entity', () {
  final model = ProjectModel.fromJson(tProjectJson);
  expect(model.title, 'E-Commerce App');
  expect(model.platforms, containsAll(['android', 'ios']));
});

// Widget test
testWidgets('ProjectCard displays title and tech chips', (tester) async {
  await tester.pumpApp(ProjectCard(project: tProject));
  expect(find.text(tProject.title), findsOneWidget);
  expect(find.byType(TechChip), findsWidgets);
});
```

---

## Platform-Specific Notes

### Web (PRIMARY PLATFORM)
- **This is the main deliverable** — design and test web first, then verify other platforms
- SEO meta tags in `web/index.html`: `og:title`, `og:description`, `og:image`, `twitter:card`
- `PathUrlStrategy` — no `#` hash in URLs (`manoharthullimalli.github.io/projects` not `.../#/projects`)
- Preloader in `web/index.html` with branded splash while Flutter initializes
- `<meta name="description">` and structured `<title>` for Google indexing
- Smooth scroll behavior via `ScrollController` coordinated with go_router
- Web-specific image format: `.webp` for all project screenshots (smaller, faster)
- **No Firebase required** — contact form via EmailJS REST API, content from local assets

### Desktop (macOS / Windows / Linux)
- Window size constraints: min 900×600, default 1440×900
- `window_manager` package: custom title bar on macOS, proper window centering on launch
- Full keyboard navigation (Tab order, Enter to submit forms, Escape to close overlays)
- Scroll behavior uses mouse wheel and trackpad gestures natively

### Android
- Minimum SDK: 21 (Android 5.0+)
- Target SDK: 34+
- Adaptive launcher icon, splash screen via `flutter_native_splash`
- ProGuard/R8 rules for release build

### iOS
- Minimum iOS: 13.0
- Universal (iPhone + iPad layouts)
- App Store screenshots: 6.7", 6.5", 5.5" iPhone + 12.9" iPad required sizes

---

## Free Web Deployment — GitHub Pages

The website must be **100% free to host** forever. GitHub Pages is the chosen platform.

### Deployment URL (no cost)
```
https://manoharthullimalli.github.io
```
If a custom domain is purchased later, GitHub Pages supports it for free (just CNAME + DNS).

### GitHub Pages Setup
```bash
# 1. Build the web release (output goes to build/web/)
flutter build web --release --base-href "/"

# 2. Push build/web/ to the gh-pages branch
# Using the gh-pages npm tool (one-time setup):
npm install -g gh-pages
gh-pages -d build/web

# OR use the GitHub Actions workflow (recommended — auto-deploys on push to main)
# See .github/workflows/deploy_web.yml below
```

### GitHub Actions CI/CD Workflow (free, runs on every push to main)
```yaml
# .github/workflows/deploy_web.yml
name: Deploy Flutter Web to GitHub Pages
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: 'stable'
      - run: flutter pub get
      - run: flutter test                          # must pass before deploy
      - run: flutter build web --release --base-href "/"
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: build/web
```

### Web Performance Targets
| Metric | Target | How achieved |
|---|---|---|
| First Contentful Paint | < 2s | Preloader, deferred JS, webp images |
| Time to Interactive | < 3s | Lazy-load sections below fold |
| Lighthouse Performance | 90+ | Code splitting, image optimization |
| Animation frame rate | 60fps | `AnimationController` + `RepaintBoundary` |
| Bundle size | < 3MB gzipped | `--tree-shake-icons`, remove unused packages |

### Optimizations Required
- `--tree-shake-icons` on every web build (removes unused Material icons)
- All project screenshots in `.webp` format, max 800px wide
- `RepaintBoundary` wrapping each major section to isolate repaints
- `const` constructors everywhere possible
- `ListView.builder` / `SliverList` for any list with more than 3 items
- No synchronous file reads or heavy computation on the main isolate

---

## Key Packages

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_web_plugins:
    sdk: flutter                   # usePathUrlStrategy() — no # hash in web URLs

  # Navigation
  go_router: ^13.0.0

  # State management — BLoC only
  flutter_bloc: ^8.1.0
  equatable: ^2.0.0              # value equality for Entities, States, Events

  # Dependency injection
  get_it: ^7.6.0

  # Functional programming (Either for error handling)
  dartz: ^0.10.1

  # UI & Animations
  animate_do: ^3.0.0             # pre-built entrance animations (FadeIn, SlideIn)
  lottie: ^3.0.0                 # Lottie JSON animations
  google_fonts: ^6.0.0           # Inter, JetBrains Mono

  # Responsive layout
  responsive_framework: ^1.1.0

  # Assets & Media
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.0            # SVG icons and illustrations

  # Platform utilities
  url_launcher: ^6.2.0           # open links, store URLs, email
  window_manager: ^0.3.0         # desktop window control
  open_filex: ^4.3.0             # open PDF resume on mobile/desktop

  # Persistence
  shared_preferences: ^2.2.0    # persist theme preference

  # Localization
  intl: ^0.20.2

  # HTTP client
  dio: ^5.4.0                    # POST to EmailJS REST endpoint; interceptors for logging & error handling

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter

  flutter_lints: ^3.0.0          # Dart analysis rules
  flutter_native_splash: ^2.3.0  # generate splash screens

  # Testing
  bloc_test: ^9.1.0              # BLoC event → state sequence testing
  mocktail: ^1.0.0               # mock generation without codegen

  # Code coverage
  # Run: flutter test --coverage && genhtml coverage/lcov.info -o coverage/html
```

---

## Conventions Claude Must Follow

### Architecture Rules (non-negotiable)
1. **BLoC is mandatory** — never use `setState` for business logic, never use GetX or Riverpod. `StatefulWidget` is only for local UI state (e.g., `AnimationController` lifecycle). All business logic lives in a BLoC or Cubit.
2. **Clean Architecture layers are inviolable** — Presentation never imports from `data/`; Domain never imports from `presentation/` or `data/`. Data imports Domain (implements its interfaces). Violations break testability.
3. **Depend on abstractions** — BLoCs receive abstract `UseCase` classes. UseCases receive abstract `Repository` interfaces. Everything wired via `get_it` in `injection_container.dart`.
4. **Either for error handling** — repositories always return `Future<Either<Failure, T>>`. Never throw exceptions across layer boundaries. Map all exceptions to typed `Failure` subclasses in the data layer.

### Code Quality Rules
5. **No comments** unless the WHY is non-obvious (a platform quirk, an undocumented constraint). Never narrate what the code does.
6. **Equatable on every Entity, Model, State, Event** — value equality is required for BLoC tests and caching.
7. **`const` constructors everywhere possible** — `const` widgets skip rebuild entirely; this is the single easiest performance win.
8. **Stateless first** — a widget stays stateless unless it owns an `AnimationController` lifecycle. All other state belongs in BLoC.
9. **Assets over network** — portfolio content always comes from `assets/data/portfolio_data.json`, never hardcoded in Dart files.
10. **Clean imports** — group: dart: → flutter: → packages → local. Feature barrels via `features/X/index.dart`.

### Performance Rules
11. **60fps rule** — use `AnimationController` + `AnimatedBuilder` or Lottie. Never animate with `Timer` or `setState`.
12. **`RepaintBoundary`** on every major section widget to isolate expensive repaints.
13. **Web build flags** — always build with `--tree-shake-icons` and `--release`; never ship a profile or debug build.
14. **Images** — `.webp` for web, max 800px wide, use `CachedNetworkImage` for any remote images (though core content is all local assets).

### Testing Rules
15. **Test every layer** — new feature = new BLoC test + new UseCase test + new Model test + at least one widget test. No exceptions.
16. **Mock at the boundary** — only mock the immediate dependency of the class under test. Never mock the class itself.
17. **Responsive by default** — every widget works at 375px (mobile), 768px (tablet), and 1440px (desktop) — verify in widget tests with `tester.binding.setSurfaceSize`.
18. **Dark theme as canonical** — design dark first. Light theme is a mapping of the dark palette, not a separate design.

---

## Build & Run Commands

```bash
# Setup
flutter pub get
dart run flutter_native_splash:create   # generate splash screens

# Development
flutter run -d chrome              # Web (primary)
flutter run -d macos               # macOS desktop
flutter run -d windows             # Windows desktop
flutter run -d <android-id>        # Android (flutter devices to list)
flutter run -d <ios-id>            # iOS

# Testing (run before every commit)
flutter test                                        # all unit + widget tests
flutter test --coverage                             # with lcov coverage report
flutter test integration_test/app_test.dart -d chrome  # integration test on web

# Release builds
flutter build web --release --base-href "/" --tree-shake-icons
flutter build macos --release
flutter build apk --release --split-per-abi
flutter build ios --release

# Web deployment (manual)
gh-pages -d build/web              # push build/web/ to gh-pages branch

# Localization
flutter gen-l10n                   # regenerate from assets/l10n/*.arb

# Dependency injection codegen (if needed)
dart run build_runner build --delete-conflicting-outputs
```

---

## Recruiter-Facing Goals

Every section of this app must implicitly prove one or more of the following:

| What recruiters see | What it proves |
|---|---|
| App runs flawlessly on 4 platforms | Cross-platform Flutter mastery |
| Smooth 60fps scroll & hero animations | Animation & performance skills |
| Responsive layout across all screen sizes | Adaptive UI architecture |
| Dark/light mode toggle that persists | Flutter theming & state persistence |
| Clean, readable Dart code | Code quality & senior-level judgment |
| Multi-language support | l10n capability, global mindset |
| Enterprise project descriptions with metrics | Real-world production experience |
| Published Play Store & App Store apps | End-to-end delivery capability |
| CI/CD and testing mentions | DevOps & quality engineering |
| Open-source contributions (GitHub) | Community engagement, portfolio depth |

---

## Current Status

> Last updated: 2026-06-30
> `flutter analyze` → **0 issues** | `flutter test` → **67 tests passing**

### Foundation
- [x] Flutter project initialized (`flutter create . --org com.manoharthullimalli`)
- [x] Clean Architecture folder structure scaffolded (all 4 features: hero, projects, skills, contact)
- [x] Flavor setup — `main_dev.dart`, `main_prod.dart`, `main.dart` (dev alias), `AppConfig` (EmailJS keys, logging)
- [x] `get_it` injection_container.dart wired (DataSources → Repos → UseCases → BLoC factories)
- [x] `Dio` client with `LogInterceptor` (dev flavor only); `ErrorInterceptor` maps `DioException` → `Failure`
- [x] Design system — `AppColors` (dark palette), `AppTheme.dark()/.light()`, `AppSizes`, `AppBreakpoints`
- [x] `portfolio_data.json` — 6 real projects + 5 skill categories + developer bio
- [x] `go_router` routes (`/`, `/projects`, `/skills`, `/contact`) → all serve `PortfolioPage`
- [x] `PathUrlStrategy` via `flutter_web_plugins` — no `#` hash in web URLs
- [x] Localization — `app_en.arb` + `app_hi.arb`, generated `AppLocalizations` via `l10n.yaml`
- [x] GitHub Actions deploy workflow (`.github/workflows/deploy_web.yml`) — test → build prod → gh-pages

### Core Widgets (lib/core/widgets/)
- [x] `GlassCard` — dark/light adaptive, border, shadow, optional hover tap
- [x] `SectionHeader` — animated title with accent lines + subtitle
- [x] `GradientText` — ShaderMask purple→cyan on any text
- [x] `AnimatedCounter` — smooth count-up with CurvedAnimation
- [x] `PortfolioNavBar` — sticky (transparent → frosted on scroll), desktop links + mobile hamburger + theme toggle
- [x] `ParticlesBackground` — `CustomPainter` animated particle field (40 particles, 20s loop, `RepaintBoundary`), wraps hero section

### Features — Web First
- [x] Hero section — typewriter tagline, animated stat counters (5+ yrs, 20+ projects, 4 platforms), avatar with glow rings, available badge, CTA buttons wired to smooth-scroll (`onViewWork` → Projects, `onHireMe` → Contact), desktop side-by-side / mobile stacked
- [x] Projects showcase — 6 projects, platform filter chips (All/Android/iOS/Web/Desktop), 3-col responsive grid, hover-lift card, category gradient header, platform badges, tech chips, featured label
- [x] Skills section — 5 skill categories, animated bars (1200ms ease-out, primary→cyan lerp), responsive 3-col grid
- [x] Contact section — desktop side-by-side / mobile stacked, validated form (name/email/subject/message), submitting state, success view, reset, social links (GitHub/LinkedIn), `_DownloadResumeButton` (calls `DownloadResumeUseCase`)
- [x] Dark/light mode toggle — `ThemeCubit`, persisted via `SharedPreferences`, `AnimatedSwitcher` icon
- [x] SEO meta tags in `web/index.html` — OG, Twitter Card, description, keywords, theme-color
- [x] Branded web loader — `MT.` gradient logo + spinner, hides on `flutter-first-frame` event
- [x] `PortfolioPage` — `CustomScrollView` + `Stack` overlay nav, `RepaintBoundary` on every section, footer with "Built with Flutter" tagline
- [ ] Resume PDF asset — `Manohar_Thullimalli_Resume.pdf` not yet added to `assets/resume/` (use case + button already wired)
- [ ] Profile photo — `assets/images/profile.jpg` not yet added (gradient avatar icon shown as fallback)

### Tests (67 passing, 0 failing)
- [x] **Hero** — `DeveloperModel` (fromJson/toJson/copyWith/SocialLinks, 9 tests) · `HeroRepositoryImpl` (success/ParseFailure/CacheFailure, 3 tests) · `GetDeveloperInfoUseCase` (success/failure, 2 tests) · `HeroBloc` (initial/Loaded/Error, 3 tests)
- [x] **Projects** — `ProjectModel` (fromJson/toJson/equality, 3 tests) · `ProjectsRepositoryImpl` (getProjects + getByPlatform, 5 tests) · `GetProjectsUseCase` + `FilterProjectsByPlatformUseCase` (4 tests) · `ProjectsBloc` (initial/Loaded/Error/filter/clearFilter, 6 tests)
- [x] **Skills** — `SkillModel`/`SkillCategoryModel` (fromJson/toJson/equality, 5 tests) · `SkillsRepositoryImpl` (success/ParseFailure/CacheFailure, 3 tests) · `GetSkillsUseCase` (success/failure, 2 tests) · `SkillsCubit` (initial/Loaded/Error/verify content, 4 tests)
- [x] **Contact** — `ContactFormModel` (fromEntity/toEmailJsParams/equality, 3 tests) · `ContactRepositoryImpl` (success/NetworkFailure/ServerFailure/exception, 4 tests) · `SubmitContactFormUseCase` (success/ServerFailure/NetworkFailure, 3 tests) · `ContactBloc` (initial/Success/Error×2/Reset/entity equality, 6 tests)
- [x] Shared test helpers — `test_data.dart` (all fixtures), `mock_repositories.dart` (mocktail mocks for all repos + use cases), `pump_app.dart` (real `ThemeCubit` with mocked prefs)
- [ ] Widget tests for section widgets (pending)
- [ ] Integration test — full scroll, theme toggle, contact form (pending)
- [ ] Web `RepaintBoundary` profiling — confirm 60fps in Chrome DevTools (pending)

### Architecture Fixes Applied
- **`SocialLinks` value object** — `portfolio_data.json` has `socialLinks` as a Map; replaced `List<String>` field on `DeveloperEntity`/`DeveloperModel` with typed `SocialLinks` (github/linkedin/twitter/resumeUrl). Prevents runtime `TypeError`.
- **DIP fix: `ContactRemoteDataSource`** — removed direct `AppConfig` calls from the data layer; `serviceId`/`templateId`/`publicKey` now injected via constructor, resolved only in `injection_container.dart`.
- **ISP fix: `ProjectsBloc`** — removed dead `FilterProjectsByPlatformUseCase` constructor param; filtering is in-memory using cached `_allProjects` — no redundant I/O needed.
- **`ParseFailure` added** — all repository `catch` blocks use `on TypeError` / `on FormatException` → `ParseFailure`, generic `catch` → `CacheFailure`/`ServerFailure`.
- **`ProjectModel.copyWith`** — was missing; added to match `DeveloperModel` and `SkillModel`.
- **`_ProjectGrid` / `_StatRow` types** — were untyped (`List` / `dynamic`); now `List<ProjectEntity>` and `DeveloperEntity`.
- **Hero CTA callbacks** — `onViewWork` / `onHireMe` threaded from `HeroSection` → `_HeroContent` → `_HeroDesktop`/`_HeroMobile` → `_CTAButtons`; `PortfolioPage` wires them to `_scrollTo(GlobalKey)`.
- **`DownloadResumeUseCase`** — opens `assets/resume/Manohar_Thullimalli_Resume.pdf` via `url_launcher`; registered in DI as `LazySingleton`.

### Implementation Notes
- `Color.withOpacity()` is deprecated in this Flutter SDK — **all color opacity uses `.withValues(alpha:)`** throughout the codebase
- `CardTheme` → renamed to `CardThemeData` in Material 3
- `ColorScheme.background` / `onBackground` deprecated → using `surface` / `onSurface`
- `intl` pinned to `^0.20.2` by `flutter_localizations` SDK constraint (not `^0.19.0`)
- `flutter_web_plugins` must be listed as a `sdk: flutter` dep (not pub.dev) — provides `usePathUrlStrategy()`
- Fonts: Inter loaded via `google_fonts` package (no local font files needed)
- `Right(value)` in tests infers `Right<dynamic, T>` which doesn't equal `Right<Failure, T>` — always use `.fold()` assertions for repository return values

### Cross-Platform Verification
- [ ] Responsive verified: 375px (mobile) · 768px (tablet) · 1440px (desktop) · 1920px (wide)
- [ ] macOS desktop window constraints + keyboard nav
- [ ] Android build — adaptive icon, splash, APK release
- [ ] iOS build — universal, splash, archive

### Deployment
- [ ] GitHub repo created — `github.com/manoharthullimalli/manoharthullimalli.github.io`
- [ ] GitHub Pages live at `https://manoharthullimalli.github.io`
- [ ] Lighthouse score 90+ on Performance, Accessibility, SEO
- [ ] Android build submitted to Play Store
- [ ] iOS build submitted to App Store
