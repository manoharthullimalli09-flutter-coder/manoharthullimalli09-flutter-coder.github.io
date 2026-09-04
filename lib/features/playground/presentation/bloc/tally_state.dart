part of 'tally_bloc.dart';

enum TallyStatus { initial, loading, loaded, error }

class TallyState extends Equatable {
  final TallyStatus status;
  final List<TransactionEntity> transactions;
  final TallySummaryEntity summary;
  final String? message;

  const TallyState({
    this.status = TallyStatus.initial,
    this.transactions = const [],
    this.summary = const TallySummaryEntity(
      totalIncome: 0,
      totalExpense: 0,
      spendByCategory: {},
    ),
    this.message,
  });

  bool get isEmpty => transactions.isEmpty;

  TallyState copyWith({
    TallyStatus? status,
    List<TransactionEntity>? transactions,
    TallySummaryEntity? summary,
    String? message,
  }) => TallyState(
    status: status ?? this.status,
    transactions: transactions ?? this.transactions,
    summary: summary ?? this.summary,
    message: message,
  );

  @override
  List<Object?> get props => [status, transactions, summary, message];
}
