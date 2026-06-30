import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/contact/domain/entities/contact_form_entity.dart';
import 'package:flutter_portfolio/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_repositories.dart';
import '../../../../helpers/test_data.dart';

void main() {
  late ContactBloc bloc;
  late MockSubmitContactFormUseCase mockUseCase;

  setUpAll(() => registerFallbackValue(tContactForm));

  setUp(() {
    mockUseCase = MockSubmitContactFormUseCase();
    bloc = ContactBloc(submitForm: mockUseCase);
  });

  tearDown(() => bloc.close());

  test('initial state is ContactInitial', () {
    expect(bloc.state, isA<ContactInitial>());
  });

  blocTest<ContactBloc, ContactState>(
    'emits [Submitting, Success] on successful form submission',
    build: () {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => const Right(unit));
      return bloc;
    },
    act: (b) => b.add(SubmitContactForm(tContactForm)),
    expect: () => [isA<ContactSubmitting>(), isA<ContactSuccess>()],
    verify: (_) => verify(() => mockUseCase(tContactForm)).called(1),
  );

  blocTest<ContactBloc, ContactState>(
    'emits [Submitting, Error] when submission fails with ServerFailure',
    build: () {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => const Left(ServerFailure('Server down')));
      return bloc;
    },
    act: (b) => b.add(SubmitContactForm(tContactForm)),
    expect: () => [isA<ContactSubmitting>(), isA<ContactError>()],
    verify: (b) {
      final state = b.state as ContactError;
      expect(state.message, 'Server down');
    },
  );

  blocTest<ContactBloc, ContactState>(
    'emits [Submitting, Error] when submission fails with NetworkFailure',
    build: () {
      when(() => mockUseCase(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      return bloc;
    },
    act: (b) => b.add(SubmitContactForm(tContactForm)),
    expect: () => [isA<ContactSubmitting>(), isA<ContactError>()],
  );

  blocTest<ContactBloc, ContactState>(
    'emits ContactInitial on ResetContactForm',
    build: () => bloc,
    seed: () => ContactSuccess(),
    act: (b) => b.add(ResetContactForm()),
    expect: () => [isA<ContactInitial>()],
  );

  group('ContactFormEntity equality', () {
    test('two identical forms are equal', () {
      const a = ContactFormEntity(
        name: 'Test', email: 'a@b.com', subject: 'Hi', message: 'Hello',
      );
      const b = ContactFormEntity(
        name: 'Test', email: 'a@b.com', subject: 'Hi', message: 'Hello',
      );
      expect(a, b);
    });
  });
}
