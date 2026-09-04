import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/tally_usecases.dart';

part 'tally_event.dart';
part 'tally_state.dart';

class TallyBloc extends Bloc<TallyEvent, TallyState> {
  final GetTransactionsUseCase getTransactions;
  final SaveTransactionsUseCase saveTransactions;

  TallyBloc({required this.getTransactions, required this.saveTransactions})
      : super(const TallyState()) {
    on<LoadTransactions>(_onLoad);
    on<AddTransaction>(_onAdd);
    on<DeleteTransaction>(_onDelete);
    on<ClearTransactions>(_onClear);
  }

  Future<void> _onLoad(LoadTransactions event, Emitter<TallyState> emit) async {
    emit(state.copyWith(status: TallyStatus.loading));
    final result = await getTransactions(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: TallyStatus.error, message: failure.message),
      ),
      (txns) => emit(_loaded(_sorted(txns))),
    );
  }

  Future<void> _onAdd(AddTransaction event, Emitter<TallyState> emit) async {
    await _commit([...state.transactions, event.transaction], emit);
  }

  Future<void> _onDelete(
    DeleteTransaction event,
    Emitter<TallyState> emit,
  ) async {
    await _commit(
      state.transactions.where((t) => t.id != event.id).toList(),
      emit,
    );
  }

  Future<void> _onClear(
    ClearTransactions event,
    Emitter<TallyState> emit,
  ) async {
    await _commit(const [], emit);
  }

  /// The list is shown immediately and persisted after; a storage error
  /// surfaces as a message without rolling the visible list back, because
  /// the entry the visitor just typed should not vanish under them.
  Future<void> _commit(
    List<TransactionEntity> next,
    Emitter<TallyState> emit,
  ) async {
    final sorted = _sorted(next);
    emit(_loaded(sorted));

    final result = await saveTransactions(sorted);
    result.fold(
      (failure) => emit(_loaded(sorted).copyWith(message: failure.message)),
      (_) {},
    );
  }

  TallyState _loaded(List<TransactionEntity> txns) => TallyState(
        status: TallyStatus.loaded,
        transactions: txns,
        summary: TallySummaryEntity.from(txns),
      );

  /// Newest first — the entry just added should land at the top of the list.
  List<TransactionEntity> _sorted(List<TransactionEntity> txns) =>
      [...txns]..sort((a, b) => b.date.compareTo(a.date));
}
