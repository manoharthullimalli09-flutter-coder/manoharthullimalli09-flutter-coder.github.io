import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late ProjectsBloc bloc;
  late MockGetProjectsUseCase mockGetProjects;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() {
    mockGetProjects = MockGetProjectsUseCase();
    bloc = ProjectsBloc(getProjects: mockGetProjects);
  });

  tearDown(() => bloc.close());

  test('initial state is ProjectsInitial', () {
    expect(bloc.state, isA<ProjectsInitial>());
  });

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [Loading, Loaded] when LoadProjects succeeds',
    build: () {
      when(
        () => mockGetProjects(any()),
      ).thenAnswer((_) async => Right(tProjectsTyped));
      return bloc;
    },
    act: (b) => b.add(LoadProjects()),
    expect: () => [isA<ProjectsLoading>(), isA<ProjectsLoaded>()],
    verify: (_) => verify(() => mockGetProjects(NoParams())).called(1),
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits [Loading, Error] when LoadProjects fails',
    build: () {
      when(
        () => mockGetProjects(any()),
      ).thenAnswer((_) async => const Left(CacheFailure('Load failed')));
      return bloc;
    },
    act: (b) => b.add(LoadProjects()),
    expect: () => [isA<ProjectsLoading>(), isA<ProjectsError>()],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits Loaded with filtered projects on FilterProjectsByPlatform',
    build: () {
      when(
        () => mockGetProjects(any()),
      ).thenAnswer((_) async => Right(tProjectsTyped));
      return bloc;
    },
    act: (b) async {
      b.add(LoadProjects());
      await Future.delayed(Duration.zero);
      b.add(FilterProjectsByPlatform('android'));
    },
    expect: () => [
      isA<ProjectsLoading>(),
      isA<ProjectsLoaded>(),
      isA<ProjectsLoaded>(),
    ],
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'emits Loaded with activeFilter null on ClearProjectFilter',
    build: () {
      when(
        () => mockGetProjects(any()),
      ).thenAnswer((_) async => Right(tProjectsTyped));
      return bloc;
    },
    act: (b) async {
      b.add(LoadProjects());
      await Future.delayed(Duration.zero);
      b.add(FilterProjectsByPlatform('android'));
      b.add(ClearProjectFilter());
    },
    expect: () => [
      isA<ProjectsLoading>(),
      isA<ProjectsLoaded>(),
      isA<ProjectsLoaded>(),
      isA<ProjectsLoaded>(),
    ],
    verify: (b) {
      final last = b.state as ProjectsLoaded;
      expect(last.activeFilter, isNull);
    },
  );

  blocTest<ProjectsBloc, ProjectsState>(
    'loaded state carries correct projects list',
    build: () {
      when(
        () => mockGetProjects(any()),
      ).thenAnswer((_) async => Right(tProjectsTyped));
      return bloc;
    },
    act: (b) => b.add(LoadProjects()),
    verify: (b) {
      final state = b.state as ProjectsLoaded;
      expect(state.projects, tProjectsTyped);
      expect(state.activeFilter, isNull);
    },
  );
}
