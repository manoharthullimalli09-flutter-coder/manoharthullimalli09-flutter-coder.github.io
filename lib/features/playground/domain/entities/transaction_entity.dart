import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class TransactionEntity extends Equatable {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;

  const TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  /// Positive for income, negative for expense — lets a balance be a plain sum.
  double get signedAmount =>
      type == TransactionType.income ? amount : -amount;

  @override
  List<Object> get props => [id, title, amount, type, category, date];
}

class TallySummaryEntity extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final Map<String, double> spendByCategory;

  const TallySummaryEntity({
    required this.totalIncome,
    required this.totalExpense,
    required this.spendByCategory,
  });

  double get balance => totalIncome - totalExpense;

  factory TallySummaryEntity.from(List<TransactionEntity> txns) {
    var income = 0.0;
    var expense = 0.0;
    final byCategory = <String, double>{};

    for (final t in txns) {
      if (t.type == TransactionType.income) {
        income += t.amount;
      } else {
        expense += t.amount;
        byCategory[t.category] = (byCategory[t.category] ?? 0) + t.amount;
      }
    }

    return TallySummaryEntity(
      totalIncome: income,
      totalExpense: expense,
      spendByCategory: byCategory,
    );
  }

  @override
  List<Object> get props => [totalIncome, totalExpense, spendByCategory];
}
