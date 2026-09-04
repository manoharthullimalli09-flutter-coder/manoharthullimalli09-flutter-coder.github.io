import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.type,
    required super.category,
    required super.date,
  });

  factory TransactionModel.fromEntity(TransactionEntity e) => TransactionModel(
    id: e.id,
    title: e.title,
    amount: e.amount,
    type: e.type,
    category: e.category,
    date: e.date,
  );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        amount: (json['amount'] as num).toDouble(),
        type: TransactionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => TransactionType.expense,
        ),
        category: json['category'] as String? ?? 'Other',
        date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'type': type.name,
    'category': category,
    'date': date.millisecondsSinceEpoch,
  };
}
