import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/hero/domain/usecases/get_developer_info_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late GetDeveloperInfoUseCase usecase;
  late MockHeroRepository mockRepo;

  setUp(() {
    mockRepo = MockHeroRepository();
    usecase = GetDeveloperInfoUseCase(mockRepo);
  });

  test('returns DeveloperEntity from repository on success', () async {
    when(
      () => mockRepo.getDeveloperInfo(),
    ).thenAnswer((_) async => const Right(tDeveloper));

    final result = await usecase(NoParams());

    expect(result, const Right(tDeveloper));
    verify(() => mockRepo.getDeveloperInfo()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('returns CacheFailure when repository fails', () async {
    when(
      () => mockRepo.getDeveloperInfo(),
    ).thenAnswer((_) async => const Left(CacheFailure()));

    final result = await usecase(NoParams());

    expect(result, const Left(CacheFailure()));
  });
}
