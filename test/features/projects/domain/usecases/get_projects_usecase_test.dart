import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late GetProjectsUseCase usecase;
  late MockProjectsRepository mockRepo;

  setUp(() {
    mockRepo = MockProjectsRepository();
    usecase = GetProjectsUseCase(mockRepo);
  });

  test('returns list of projects on success', () async {
    when(() => mockRepo.getProjects())
        .thenAnswer((_) async => Right(tProjectsTyped));

    final result = await usecase(NoParams());

    expect(result, Right(tProjectsTyped));
    verify(() => mockRepo.getProjects()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('returns CacheFailure when repository fails', () async {
    when(() => mockRepo.getProjects())
        .thenAnswer((_) async => const Left(CacheFailure()));

    final result = await usecase(NoParams());

    expect(result, const Left(CacheFailure()));
  });

  group('FilterProjectsByPlatformUseCase', () {
    late FilterProjectsByPlatformUseCase filterUsecase;

    setUp(() => filterUsecase = FilterProjectsByPlatformUseCase(mockRepo));

    test('delegates to repository with platform param', () async {
      when(() => mockRepo.getProjectsByPlatform('android'))
          .thenAnswer((_) async => Right(tProjectsTyped));

      final result = await filterUsecase(
        const FilterProjectsByPlatformParams('android'),
      );

      expect(result, Right(tProjectsTyped));
      verify(() => mockRepo.getProjectsByPlatform('android')).called(1);
    });

    test('returns failure when platform not found', () async {
      when(() => mockRepo.getProjectsByPlatform('unknown'))
          .thenAnswer((_) async => const Left(CacheFailure()));

      final result = await filterUsecase(
        const FilterProjectsByPlatformParams('unknown'),
      );

      expect(result.isLeft(), true);
    });
  });
}
