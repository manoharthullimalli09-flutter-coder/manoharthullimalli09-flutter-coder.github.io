import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/skills/presentation/bloc/skills_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late SkillsCubit cubit;
  late MockGetSkillsUseCase mockUseCase;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() {
    mockUseCase = MockGetSkillsUseCase();
    cubit = SkillsCubit(getSkills: mockUseCase);
  });

  tearDown(() => cubit.close());

  test('initial state is SkillsInitial', () {
    expect(cubit.state, isA<SkillsInitial>());
  });

  blocTest<SkillsCubit, SkillsState>(
    'emits [Loading, Loaded] when loadSkills succeeds',
    build: () {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => Right(tSkillCategoriesTyped));
      return cubit;
    },
    act: (c) => c.loadSkills(),
    expect: () => [isA<SkillsLoading>(), isA<SkillsLoaded>()],
    verify: (_) => verify(() => mockUseCase(NoParams())).called(1),
  );

  blocTest<SkillsCubit, SkillsState>(
    'emits [Loading, Error] when loadSkills fails',
    build: () {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => const Left(CacheFailure('Failed')));
      return cubit;
    },
    act: (c) => c.loadSkills(),
    expect: () => [isA<SkillsLoading>(), isA<SkillsError>()],
  );

  blocTest<SkillsCubit, SkillsState>(
    'loaded state contains correct categories',
    build: () {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => Right(tSkillCategoriesTyped));
      return cubit;
    },
    act: (c) => c.loadSkills(),
    verify: (c) {
      final state = c.state as SkillsLoaded;
      expect(state.categories, tSkillCategoriesTyped);
    },
  );
}
