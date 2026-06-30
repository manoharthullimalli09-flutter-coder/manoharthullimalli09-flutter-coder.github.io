import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:flutter_portfolio/features/contact/data/models/contact_form_model.dart';
import 'package:flutter_portfolio/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/test_data.dart';

class _MockContactRemoteDataSource extends Mock
    implements ContactRemoteDataSource {}

class _FakeContactFormModel extends Fake implements ContactFormModel {}

void main() {
  late ContactRepositoryImpl repo;
  late _MockContactRemoteDataSource mockDataSource;

  setUpAll(() => registerFallbackValue(_FakeContactFormModel()));

  setUp(() {
    mockDataSource = _MockContactRemoteDataSource();
    repo = ContactRepositoryImpl(mockDataSource);
  });

  test('returns Right(unit) on successful submission', () async {
    when(() => mockDataSource.submitForm(any())).thenAnswer((_) async {});

    final result = await repo.submitForm(tContactForm);

    expect(result, const Right(unit));
  });

  test('returns Left(NetworkFailure) on connection error', () async {
    when(() => mockDataSource.submitForm(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await repo.submitForm(tContactForm);

    result.fold((f) => expect(f, isA<NetworkFailure>()), (_) => fail('Expected failure'));
  });

  test('returns Left(ServerFailure) on Dio server error', () async {
    when(() => mockDataSource.submitForm(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        message: 'Bad response',
      ),
    );

    final result = await repo.submitForm(tContactForm);

    result.fold((f) => expect(f, isA<ServerFailure>()), (_) => fail('Expected failure'));
  });

  test('returns Left(ServerFailure) on unexpected exception', () async {
    when(() => mockDataSource.submitForm(any()))
        .thenThrow(Exception('unexpected'));

    final result = await repo.submitForm(tContactForm);

    expect(result, const Left(ServerFailure()));
  });
}
