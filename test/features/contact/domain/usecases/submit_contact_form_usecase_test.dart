import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/contact/domain/usecases/submit_contact_form_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late SubmitContactFormUseCase usecase;
  late MockContactRepository mockRepo;

  setUpAll(() => registerFallbackValue(tContactForm));

  setUp(() {
    mockRepo = MockContactRepository();
    usecase = SubmitContactFormUseCase(mockRepo);
  });

  test('returns Right(unit) on successful submission', () async {
    when(() => mockRepo.submitForm(any()))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(tContactForm);

    expect(result, const Right(unit));
    verify(() => mockRepo.submitForm(tContactForm)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });

  test('returns ServerFailure when submission fails', () async {
    when(() => mockRepo.submitForm(any()))
        .thenAnswer((_) async => const Left(ServerFailure('Network error')));

    final result = await usecase(tContactForm);

    expect(result, const Left(ServerFailure('Network error')));
  });

  test('returns NetworkFailure on connectivity issues', () async {
    when(() => mockRepo.submitForm(any()))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    final result = await usecase(tContactForm);

    result.fold((f) => expect(f, isA<NetworkFailure>()), (_) => fail('Expected failure'));
  });
}
