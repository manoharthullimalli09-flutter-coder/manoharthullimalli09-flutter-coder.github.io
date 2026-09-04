import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/tally_repository.dart';

class GetTransactionsUseCase
    implements UseCase<List<TransactionEntity>, NoParams> {
  final TallyRepository repository;

  const GetTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TransactionEntity>>> call(NoParams params) =>
      repository.getTransactions();
}

class SaveTransactionsUseCase
    implements UseCase<Unit, List<TransactionEntity>> {
  final TallyRepository repository;

  const SaveTransactionsUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(List<TransactionEntity> params) =>
      repository.saveTransactions(params);
}
