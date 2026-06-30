import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/skills/domain/usecases/get_skills_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late GetSkillsUseCase usecase;
  late MockSkillsRepository mockRepo;

  setUp(() {
    mockRepo = MockSkillsRepository();
    usecase = GetSkillsUseCase(mockRepo);
  });

  test('returns skill categories on success', () async {
    when(() => mockRepo.getSkillCategories())
        .thenAnswer((_) async => Right(tSkillCategoriesTyped));

    final result = await usecase(NoParams());

    expect(result, Right(tSkillCategoriesTyped));
    verify(() => mockRepo.getSkillCategories()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('returns CacheFailure when repository fails', () async {
    when(() => mockRepo.getSkillCategories())
        .thenAnswer((_) async => const Left(CacheFailure()));

    final result = await usecase(NoParams());

    expect(result, const Left(CacheFailure()));
  });
}
