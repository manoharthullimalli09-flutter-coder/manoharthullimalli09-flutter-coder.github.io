import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_portfolio/features/playground/data/datasources/playground_local_datasource.dart';
import 'package:flutter_portfolio/features/playground/data/models/transaction_model.dart';
import 'package:flutter_portfolio/features/playground/data/repositories/streak_repository_impl.dart';
import 'package:flutter_portfolio/features/playground/data/repositories/tally_repository_impl.dart';
import 'package:flutter_portfolio/features/playground/domain/entities/transaction_entity.dart';

void main() {
  late SharedPreferences prefs;
  late PlaygroundLocalDataSourceImpl local;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    local = PlaygroundLocalDataSourceImpl(prefs);
  });

  final sample = [
    TransactionEntity(
      id: '1',
      title: 'Groceries',
      amount: 1250.50,
      type: TransactionType.expense,
      category: 'Food',
      date: DateTime(2026, 3, 14),
    ),
    TransactionEntity(
      id: '2',
      title: 'Salary',
      amount: 90000,
      type: TransactionType.income,
      category: 'Income',
      date: DateTime(2026, 3, 1),
    ),
  ];

  group('TallyRepositoryImpl', () {
    test('round-trips transactions through storage unchanged', () async {
      final repo = TallyRepositoryImpl(local);

      await repo.saveTransactions(sample);
      final result = await repo.getTransactions();

      final loaded = result.getOrElse(() => []);
      expect(loaded.length, 2);
      expect(loaded.first.title, 'Groceries');
      expect(loaded.first.amount, 1250.50);
      expect(loaded.first.type, TransactionType.expense);
      expect(loaded.first.date, DateTime(2026, 3, 14));
      expect(loaded[1].type, TransactionType.income);
    });

    test('returns an empty list when nothing has been saved', () async {
      final result = await TallyRepositoryImpl(local).getTransactions();
      expect(result.getOrElse(() => [const _Never()]), isEmpty);
    });

    test('corrupt stored JSON degrades to empty, not a crash', () async {
      await prefs.setString('playground_transactions', '{not valid json');
      final result = await TallyRepositoryImpl(local).getTransactions();

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => [const _Never()]), isEmpty);
    });

    test('saving an empty list clears what was stored', () async {
      final repo = TallyRepositoryImpl(local);
      await repo.saveTransactions(sample);
      await repo.saveTransactions(const []);

      expect((await repo.getTransactions()).getOrElse(() => [const _Never()]),
          isEmpty);
    });
  });

  group('TransactionModel', () {
    test('toJson -> fromJson preserves every field', () {
      final model = TransactionModel.fromEntity(sample.first);
      final restored = TransactionModel.fromJson(model.toJson());
      expect(restored, equals(model));
    });

    test('an unknown type falls back to expense rather than throwing', () {
      final restored = TransactionModel.fromJson({
        'id': 'x',
        'title': 'Mystery',
        'amount': 10,
        'type': 'not_a_type',
        'category': 'Other',
        'date': DateTime(2026, 1, 1).millisecondsSinceEpoch,
      });
      expect(restored.type, TransactionType.expense);
    });
  });

  group('StreakRepositoryImpl', () {
    test('starts at zero and increments across calls', () async {
      final repo = StreakRepositoryImpl(local);

      expect((await repo.getSessionsCompleted()).getOrElse(() => -1), 0);
      expect((await repo.incrementSessionsCompleted()).getOrElse(() => -1), 1);
      expect((await repo.incrementSessionsCompleted()).getOrElse(() => -1), 2);
      expect((await repo.getSessionsCompleted()).getOrElse(() => -1), 2);
    });
  });
}

/// Sentinel so `getOrElse` failing is visibly wrong rather than silently empty.
class _Never extends TransactionEntity {
  const _Never()
      : super(
          id: 'never',
          title: 'never',
          amount: 0,
          type: TransactionType.expense,
          category: 'never',
          date: const _Epoch(),
        );
}

class _Epoch implements DateTime {
  const _Epoch();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
