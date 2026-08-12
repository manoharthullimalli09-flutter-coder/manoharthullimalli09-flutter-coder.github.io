import 'package:dartz/dartz.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/projects/domain/entities/project_entity.dart';
import 'package:flutter_portfolio/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_portfolio/features/projects/presentation/widgets/project_card.dart';
import 'package:flutter_portfolio/features/projects/presentation/widgets/project_chips.dart';
import 'package:flutter_portfolio/features/projects/presentation/widgets/project_detail_dialog.dart';
import 'package:flutter_portfolio/features/projects/presentation/widgets/projects_section.dart';
import 'package:flutter_portfolio/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/pump_app.dart';

/// Deliberately more tech than a card can show on one row, so the clipping
/// and the dialog's full listing are both exercised.
const _alphaTech = [
  'Flutter',
  'BLoC',
  'Firebase',
  'WebSocket',
  'FCM',
  'REST API',
  'Clean Architecture',
];

const _longDescription =
    'A production application with a great deal of detail worth reading, '
    'far more than the three lines a project card is willing to spend on '
    'it, which is precisely why the detail dialog exists at all.';

const _projects = [
  ProjectEntity(
    id: 'a',
    title: 'Alpha',
    description: _longDescription,
    category: 'E-Commerce',
    platforms: ['android', 'ios'],
    techStack: _alphaTech,
    imageUrl: '',
    playStoreUrl: 'https://play.google.com/alpha',
    githubUrl: 'https://github.com/example/alpha',
    isFeatured: true,
  ),
  ProjectEntity(
    id: 'b',
    title: 'Bravo',
    description: 'Second project',
    category: 'Healthcare',
    platforms: ['android'],
    techStack: ['Flutter', 'Dio'],
    imageUrl: '',
    webUrl: 'https://example.com/bravo',
  ),
  ProjectEntity(
    id: 'c',
    title: 'Charlie',
    description: 'Third project',
    category: 'FinTech',
    platforms: ['web'],
    techStack: ['Flutter'],
    imageUrl: '',
  ),
];

void main() {
  late MockGetProjectsUseCase mockGetProjects;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() {
    mockGetProjects = MockGetProjectsUseCase();
    when(() => mockGetProjects(any()))
        .thenAnswer((_) async => const Right<Failure, List<ProjectEntity>>(_projects));
    sl.registerFactory<ProjectsBloc>(
      () => ProjectsBloc(getProjects: mockGetProjects),
    );
  });

  tearDown(() => sl.reset());

  Future<TestGesture> hoverOver(WidgetTester tester, Finder target) async {
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(target));
    await tester.pumpAndSettle();
    return gesture;
  }

  group('desktop hover', () {
    setUp(() => TestWidgetsFlutterBinding.ensureInitialized());

    Future<void> pumpDesktop(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        const SingleChildScrollView(child: ProjectsSection()),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders one card per project at equal width when idle',
        (tester) async {
      await pumpDesktop(tester);

      final cards = find.byType(ProjectCard);
      expect(cards, findsNWidgets(3));

      final widths = [
        for (var i = 0; i < 3; i++) tester.getSize(cards.at(i)).width,
      ];
      expect(widths[1], closeTo(widths[0], 0.5));
      expect(widths[2], closeTo(widths[0], 0.5));
    });

    testWidgets('hovered card widens and its siblings narrow to match',
        (tester) async {
      await pumpDesktop(tester);

      final cards = find.byType(ProjectCard);
      final idle = tester.getSize(cards.at(0)).width;

      await hoverOver(tester, find.text('Alpha'));

      expect(tester.getSize(cards.at(0)).width, greaterThan(idle));
      expect(tester.getSize(cards.at(1)).width, lessThan(idle));
    });

    testWidgets('every card in a row keeps the same height, hovered or not',
        (tester) async {
      await pumpDesktop(tester);

      final cards = find.byType(ProjectCard);
      double heightOf(int i) => tester.getSize(cards.at(i)).height;

      final level = heightOf(0);
      expect(heightOf(1), closeTo(level, 0.5));
      expect(heightOf(2), closeTo(level, 0.5));

      await hoverOver(tester, find.text('Alpha'));

      // Widening a card must not make it taller than the row.
      expect(heightOf(0), closeTo(level, 0.5));
      expect(heightOf(1), closeTo(level, 0.5));
      expect(heightOf(2), closeTo(level, 0.5));
    });

    testWidgets('artwork scales on every side as the card widens',
        (tester) async {
      await pumpDesktop(tester);

      final art = find.byType(CategoryArtwork);
      final restSize = tester.getSize(art.at(0));
      final restTop = tester.getTopLeft(art.at(0)).dy;
      final restBottom = tester.getBottomLeft(art.at(0)).dy;

      await hoverOver(tester, find.text('Alpha'));

      final grownSize = tester.getSize(art.at(0));
      expect(grownSize.width, greaterThan(restSize.width));
      expect(grownSize.height, greaterThan(restSize.height));

      // Vertically it opens out from a fixed centre — up and down equally.
      final rise = restTop - tester.getTopLeft(art.at(0)).dy;
      final drop = tester.getBottomLeft(art.at(0)).dy - restBottom;
      expect(rise, greaterThan(0));
      expect(drop, closeTo(rise, 0.5));
    });

    testWidgets('panel only ever changes width, never vertical position',
        (tester) async {
      await pumpDesktop(tester);

      // The title sits at the top of the panel, so its y is the panel's y.
      double panelTop() => tester.getTopLeft(find.text('Alpha')).dy;
      double panelWidth() =>
          tester.getSize(find.ancestor(
            of: find.text('Alpha'),
            matching: find.byType(AnimatedContainer),
          ).first).width;

      final restTop = panelTop();
      final restWidth = panelWidth();

      await hoverOver(tester, find.text('Alpha'));

      expect(panelTop(), closeTo(restTop, 0.5));
      expect(panelWidth(), greaterThan(restWidth));
    });

    testWidgets('card tops and bottoms stay aligned while hovering',
        (tester) async {
      await pumpDesktop(tester);

      final cards = find.byType(ProjectCard);
      await hoverOver(tester, find.text('Bravo'));

      final tops = [for (var i = 0; i < 3; i++) tester.getTopLeft(cards.at(i))];
      final bottoms = [
        for (var i = 0; i < 3; i++) tester.getBottomLeft(cards.at(i)),
      ];

      for (var i = 1; i < 3; i++) {
        expect(tops[i].dy, closeTo(tops[0].dy, 0.5));
        expect(bottoms[i].dy, closeTo(bottoms[0].dy, 0.5));
      }
    });

    testWidgets('row height is unchanged by hover, so the page never reflows',
        (tester) async {
      await pumpDesktop(tester);

      final section = find.byType(ProjectsSection);
      final idleHeight = tester.getSize(section).height;

      await hoverOver(tester, find.text('Alpha'));

      expect(tester.getSize(section).height, closeTo(idleHeight, 0.5));
    });

    testWidgets('sliding straight between cards never overflows the row',
        (tester) async {
      await pumpDesktop(tester);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      for (final title in ['Alpha', 'Bravo', 'Charlie', 'Alpha']) {
        await gesture.moveTo(tester.getCenter(find.text(title)));
        // Interrupt each tween mid-flight — this is where mismatched
        // per-card animations would overflow the Row.
        await tester.pump(const Duration(milliseconds: 120));
        expect(tester.takeException(), isNull);
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('a partial final row keeps full-row card sizing',
        (tester) async {
      // 4 projects on a 3-wide grid leaves one card alone on row two; it must
      // not stretch across the row and blow its aspect-derived height up.
      when(() => mockGetProjects(any())).thenAnswer(
        (_) async => Right<Failure, List<ProjectEntity>>(
          [..._projects, _projects.first],
        ),
      );
      await pumpDesktop(tester);

      final cards = find.byType(ProjectCard);
      expect(cards, findsNWidgets(4));
      expect(tester.getSize(cards.at(3)).width,
          closeTo(tester.getSize(cards.at(0)).width, 0.5));
      expect(tester.getSize(cards.at(3)).height,
          closeTo(tester.getSize(cards.at(0)).height, 0.5));
    });

    testWidgets('reveals the store link only for the hovered card',
        (tester) async {
      await pumpDesktop(tester);

      double linkOpacity(String label) => tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.text(label),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;

      expect(linkOpacity('Play Store'), 0);

      await hoverOver(tester, find.text('Alpha'));

      expect(linkOpacity('Play Store'), 1);
      expect(linkOpacity('Live Demo'), 0);
    });
  });

  group('tech stack', () {
    testWidgets('cards surface the stack that only lived in the data file',
        (tester) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        const SingleChildScrollView(child: ProjectsSection()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TechChip), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(ProjectCard),
          matching: find.text('Flutter'),
        ),
        findsWidgets,
      );
      // A row of chips wider than the card must clip, never overflow.
      expect(tester.takeException(), isNull);
    });

    testWidgets('clips overflowing chips at every breakpoint', (tester) async {
      for (final width in [390.0, 768.0, 1440.0, 1920.0]) {
        tester.view.physicalSize = Size(width, 2400);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpApp(
          const SingleChildScrollView(child: ProjectsSection()),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull,
            reason: 'overflowed at ${width}px');
      }
      addTearDown(tester.view.reset);
    });
  });

  group('detail dialog', () {
    testWidgets('opens on card tap with the untruncated description',
        (tester) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        const SingleChildScrollView(child: ProjectsSection()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProjectDetailDialog), findsNothing);

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      final dialog = find.byType(ProjectDetailDialog);
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(of: dialog, matching: find.text(_longDescription)),
        findsOneWidget,
      );
    });

    testWidgets('lists every technology the card had to clip', (tester) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        const SingleChildScrollView(child: ProjectsSection()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      final dialog = find.byType(ProjectDetailDialog);
      for (final tech in _alphaTech) {
        expect(
          find.descendant(of: dialog, matching: find.text(tech)),
          findsOneWidget,
          reason: '$tech missing from the dialog',
        );
      }
    });

    testWidgets('exposes every store link, not just the card\'s one',
        (tester) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        const SingleChildScrollView(child: ProjectsSection()),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();

      final dialog = find.byType(ProjectDetailDialog);
      // The card only ever shows one; Alpha ships to Play Store and GitHub.
      expect(find.descendant(of: dialog, matching: find.text('Play Store')),
          findsOneWidget);
      expect(find.descendant(of: dialog, matching: find.text('Source')),
          findsOneWidget);
    });

    testWidgets('closes without disturbing the grid', (tester) async {
      tester.view.physicalSize = const Size(1440, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        const SingleChildScrollView(child: ProjectsSection()),
      );
      await tester.pumpAndSettle();

      final before = tester.getSize(find.byType(ProjectCard).first);

      await tester.tap(find.text('Alpha'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(ProjectDetailDialog), findsNothing);
      expect(tester.getSize(find.byType(ProjectCard).first).width,
          closeTo(before.width, 0.5));
    });
  });

  testWidgets('mobile stacks cards and shows links without hover',
      (tester) async {
    tester.view.physicalSize = const Size(390, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpApp(const SingleChildScrollView(child: ProjectsSection()));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectCard), findsNWidgets(3));

    final opacity = tester
        .widget<AnimatedOpacity>(
          find.ancestor(
            of: find.text('Play Store'),
            matching: find.byType(AnimatedOpacity),
          ),
        )
        .opacity;
    expect(opacity, 1);
  });
}
