import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/hero/data/datasources/hero_local_datasource.dart';
import 'package:flutter_portfolio/features/hero/data/repositories/hero_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_data.dart';

class _MockHeroLocalDataSource extends Mock implements HeroLocalDataSource {}

void main() {
  late HeroRepositoryImpl repo;
  late _MockHeroLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = _MockHeroLocalDataSource();
    repo = HeroRepositoryImpl(mockDataSource);
  });

  test('returns Right(developer) when data source succeeds', () async {
    when(() => mockDataSource.getDeveloperInfo())
        .thenAnswer((_) async => tDeveloper);

    final result = await repo.getDeveloperInfo();

    expect(result, const Right(tDeveloper));
    verify(() => mockDataSource.getDeveloperInfo()).called(1);
  });

  test('returns Left(ParseFailure) on TypeError from data source', () async {
    when(() => mockDataSource.getDeveloperInfo()).thenThrow(
      TypeError(),
    );

    final result = await repo.getDeveloperInfo();

    expect(result.isLeft(), true);
    result.fold((f) => expect(f, isA<ParseFailure>()), (_) => fail('Expected failure'));
  });

  test('returns Left(CacheFailure) on generic exception', () async {
    when(() => mockDataSource.getDeveloperInfo())
        .thenThrow(Exception('disk error'));

    final result = await repo.getDeveloperInfo();

    expect(result, const Left(CacheFailure()));
  });
}
