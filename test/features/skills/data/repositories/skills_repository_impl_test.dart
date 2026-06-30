import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/skills/data/datasources/skills_local_datasource.dart';
import 'package:flutter_portfolio/features/skills/data/repositories/skills_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_data.dart';

class _MockSkillsLocalDataSource extends Mock implements SkillsLocalDataSource {}

void main() {
  late SkillsRepositoryImpl repo;
  late _MockSkillsLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = _MockSkillsLocalDataSource();
    repo = SkillsRepositoryImpl(mockDataSource);
  });

  test('returns Right(categories) on success', () async {
    when(() => mockDataSource.getSkillCategories())
        .thenAnswer((_) async => [tSkillCategory]);

    final result = await repo.getSkillCategories();

    result.fold(
      (_) => fail('Expected Right'),
      (cats) => expect(cats, [tSkillCategory]),
    );
  });

  test('returns Left(ParseFailure) on TypeError', () async {
    when(() => mockDataSource.getSkillCategories()).thenThrow(TypeError());

    final result = await repo.getSkillCategories();

    result.fold((f) => expect(f, isA<ParseFailure>()), (_) => fail('Expected failure'));
  });

  test('returns Left(CacheFailure) on generic exception', () async {
    when(() => mockDataSource.getSkillCategories())
        .thenThrow(Exception('io error'));

    final result = await repo.getSkillCategories();

    expect(result, const Left(CacheFailure()));
  });
}
