part of 'tally_bloc.dart';

abstract class TallyEvent extends Equatable {
  const TallyEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TallyEvent {
  const LoadTransactions();
}

class AddTransaction extends TallyEvent {
  final TransactionEntity transaction;
  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TallyEvent {
  final String id;
  const DeleteTransaction(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearTransactions extends TallyEvent {
  const ClearTransactions();
}
