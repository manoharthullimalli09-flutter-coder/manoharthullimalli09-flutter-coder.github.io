import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/projects/data/datasources/projects_local_datasource.dart';
import 'package:flutter_portfolio/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_data.dart';

class _MockProjectsLocalDataSource extends Mock
    implements ProjectsLocalDataSource {}

void main() {
  late ProjectsRepositoryImpl repo;
  late _MockProjectsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = _MockProjectsLocalDataSource();
    repo = ProjectsRepositoryImpl(mockDataSource);
  });

  group('getProjects', () {
    test('returns Right(projects) on success', () async {
      when(
        () => mockDataSource.getProjects(),
      ).thenAnswer((_) async => [tProject]);

      final result = await repo.getProjects();

      result.fold(
        (_) => fail('Expected Right'),
        (projects) => expect(projects, [tProject]),
      );
    });

    test('returns Left(ParseFailure) on TypeError', () async {
      when(() => mockDataSource.getProjects()).thenThrow(TypeError());

      final result = await repo.getProjects();

      expect(result.isLeft(), true);
      result.fold(
        (f) => expect(f, isA<ParseFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    test('returns Left(CacheFailure) on generic exception', () async {
      when(() => mockDataSource.getProjects()).thenThrow(Exception('io error'));

      final result = await repo.getProjects();

      expect(result, const Left(CacheFailure()));
    });
  });

  group('getProjectsByPlatform', () {
    test('returns filtered list matching platform', () async {
      when(
        () => mockDataSource.getProjects(),
      ).thenAnswer((_) async => [tProject]);

      final result = await repo.getProjectsByPlatform('android');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right'),
        (projects) => expect(projects, [tProject]),
      );
    });

    test('returns empty list when no projects match platform', () async {
      when(
        () => mockDataSource.getProjects(),
      ).thenAnswer((_) async => [tProject]);

      final result = await repo.getProjectsByPlatform('desktop');

      result.fold(
        (_) => fail('Expected Right'),
        (projects) => expect(projects, isEmpty),
      );
    });
  });
}
