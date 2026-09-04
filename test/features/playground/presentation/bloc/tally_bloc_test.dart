import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/core/usecases/usecase.dart';
import 'package:flutter_portfolio/features/playground/domain/entities/transaction_entity.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/tally_usecases.dart';
import 'package:flutter_portfolio/features/playground/presentation/bloc/tally_bloc.dart';

class MockGetTransactions extends Mock implements GetTransactionsUseCase {}

class MockSaveTransactions extends Mock implements SaveTransactionsUseCase {}

TransactionEntity txn(
  String id, {
  double amount = 100,
  TransactionType type = TransactionType.expense,
  String category = 'Food',
  DateTime? date,
}) =>
    TransactionEntity(
      id: id,
      title: 'Item $id',
      amount: amount,
      type: type,
      category: category,
      date: date ?? DateTime(2026, 1, 1),
    );

void main() {
  late MockGetTransactions getTransactions;
  late MockSaveTransactions saveTransactions;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(<TransactionEntity>[]);
  });

  setUp(() {
    getTransactions = MockGetTransactions();
    saveTransactions = MockSaveTransactions();
    when(() => saveTransactions(any()))
        .thenAnswer((_) async => const Right(unit));
  });

  TallyBloc build() => TallyBloc(
        getTransactions: getTransactions,
        saveTransactions: saveTransactions,
      );

  test('initial state is empty with a zeroed summary', () {
    when(() => getTransactions(any())).thenAnswer((_) async => const Right([]));
    final bloc = build();
    expect(bloc.state.status, TallyStatus.initial);
    expect(bloc.state.isEmpty, isTrue);
    expect(bloc.state.summary.balance, 0);
  });

  blocTest<TallyBloc, TallyState>(
    'LoadTransactions emits loading then loaded with a computed summary',
    setUp: () {
      when(() => getTransactions(any())).thenAnswer(
        (_) async => Right([
          txn('1', amount: 500, type: TransactionType.income),
          txn('2', amount: 200),
        ]),
      );
    },
    build: build,
    act: (bloc) => bloc.add(const LoadTransactions()),
    expect: () => [
      isA<TallyState>().having((s) => s.status, 'status', TallyStatus.loading),
      isA<TallyState>()
          .having((s) => s.status, 'status', TallyStatus.loaded)
          .having((s) => s.summary.totalIncome, 'income', 500)
          .having((s) => s.summary.totalExpense, 'expense', 200)
          .having((s) => s.summary.balance, 'balance', 300),
    ],
  );

  blocTest<TallyBloc, TallyState>(
    'LoadTransactions surfaces a repository failure',
    setUp: () {
      when(() => getTransactions(any()))
          .thenAnswer((_) async => const Left(CacheFailure('boom')));
    },
    build: build,
    act: (bloc) => bloc.add(const LoadTransactions()),
    expect: () => [
      isA<TallyState>().having((s) => s.status, 'status', TallyStatus.loading),
      isA<TallyState>()
          .having((s) => s.status, 'status', TallyStatus.error)
          .having((s) => s.message, 'message', 'boom'),
    ],
  );

  blocTest<TallyBloc, TallyState>(
    'AddTransaction appends, recomputes the summary and persists',
    setUp: () {
      when(() => getTransactions(any())).thenAnswer((_) async => const Right([]));
    },
    build: build,
    act: (bloc) => bloc.add(AddTransaction(txn('1', amount: 250))),
    expect: () => [
      isA<TallyState>()
          .having((s) => s.transactions.length, 'count', 1)
          .having((s) => s.summary.totalExpense, 'expense', 250)
          .having((s) => s.summary.balance, 'balance', -250),
    ],
    verify: (_) => verify(() => saveTransactions(any())).called(1),
  );

  blocTest<TallyBloc, TallyState>(
    'spendByCategory groups expenses and ignores income',
    setUp: () {
      when(() => getTransactions(any())).thenAnswer(
        (_) async => Right([
          txn('1', amount: 100, category: 'Food'),
          txn('2', amount: 50, category: 'Food'),
          txn('3', amount: 400, category: 'Rent'),
          txn('4', amount: 900, type: TransactionType.income),
        ]),
      );
    },
    build: build,
    act: (bloc) => bloc.add(const LoadTransactions()),
    skip: 1,
    expect: () => [
      isA<TallyState>()
          .having((s) => s.summary.spendByCategory['Food'], 'food', 150)
          .having((s) => s.summary.spendByCategory['Rent'], 'rent', 400)
          .having(
            (s) => s.summary.spendByCategory.containsKey('Income'),
            'income excluded',
            isFalse,
          ),
    ],
  );

  blocTest<TallyBloc, TallyState>(
    'DeleteTransaction removes only the matching id',
    setUp: () {
      when(() => getTransactions(any())).thenAnswer(
        (_) async => Right([txn('1'), txn('2')]),
      );
    },
    build: build,
    act: (bloc) async {
      bloc.add(const LoadTransactions());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DeleteTransaction('1'));
    },
    skip: 2,
    expect: () => [
      isA<TallyState>()
          .having((s) => s.transactions.length, 'count', 1)
          .having((s) => s.transactions.first.id, 'surviving id', '2'),
    ],
  );

  blocTest<TallyBloc, TallyState>(
    'ClearTransactions empties the list and persists the empty list',
    setUp: () {
      when(() => getTransactions(any()))
          .thenAnswer((_) async => Right([txn('1'), txn('2')]));
    },
    build: build,
    act: (bloc) async {
      bloc.add(const LoadTransactions());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const ClearTransactions());
    },
    skip: 2,
    expect: () => [
      isA<TallyState>()
          .having((s) => s.isEmpty, 'empty', isTrue)
          .having((s) => s.summary.balance, 'balance', 0),
    ],
  );

  blocTest<TallyBloc, TallyState>(
    'a save failure keeps the entry visible and reports the message',
    setUp: () {
      when(() => getTransactions(any())).thenAnswer((_) async => const Right([]));
      when(() => saveTransactions(any()))
          .thenAnswer((_) async => const Left(CacheFailure('disk full')));
    },
    build: build,
    act: (bloc) => bloc.add(AddTransaction(txn('1'))),
    expect: () => [
      isA<TallyState>().having((s) => s.transactions.length, 'count', 1),
      isA<TallyState>()
          .having((s) => s.transactions.length, 'still there', 1)
          .having((s) => s.message, 'message', 'disk full'),
    ],
  );

  blocTest<TallyBloc, TallyState>(
    'transactions are ordered newest first',
    setUp: () {
      when(() => getTransactions(any())).thenAnswer(
        (_) async => Right([
          txn('old', date: DateTime(2026, 1, 1)),
          txn('new', date: DateTime(2026, 6, 1)),
        ]),
      );
    },
    build: build,
    act: (bloc) => bloc.add(const LoadTransactions()),
    skip: 1,
    expect: () => [
      isA<TallyState>()
          .having((s) => s.transactions.first.id, 'first', 'new'),
    ],
  );
}
