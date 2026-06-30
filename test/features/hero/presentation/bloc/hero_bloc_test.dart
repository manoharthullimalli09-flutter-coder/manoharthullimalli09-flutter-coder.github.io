import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/hero/presentation/bloc/hero_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late HeroBloc bloc;
  late MockGetDeveloperInfoUseCase mockUseCase;

  setUpAll(() => registerFallbackValue(NoParams()));

  setUp(() {
    mockUseCase = MockGetDeveloperInfoUseCase();
    bloc = HeroBloc(getDeveloperInfo: mockUseCase);
  });

  tearDown(() => bloc.close());

  test('initial state is HeroInitial', () {
    expect(bloc.state, isA<HeroInitial>());
  });

  blocTest<HeroBloc, HeroState>(
    'emits [HeroLoading, HeroLoaded] when LoadDeveloperInfo succeeds',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => const Right(tDeveloper));
      return bloc;
    },
    act: (b) => b.add(LoadDeveloperInfo()),
    expect: () => [isA<HeroLoading>(), isA<HeroLoaded>()],
    verify: (_) => verify(() => mockUseCase(NoParams())).called(1),
  );

  blocTest<HeroBloc, HeroState>(
    'emits [HeroLoading, HeroError] when LoadDeveloperInfo fails',
    build: () {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => const Left(CacheFailure('Load failed')));
      return bloc;
    },
    act: (b) => b.add(LoadDeveloperInfo()),
    expect: () => [isA<HeroLoading>(), isA<HeroError>()],
  );
}
