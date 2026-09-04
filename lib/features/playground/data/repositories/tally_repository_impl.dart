import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/tally_repository.dart';
import '../datasources/playground_local_datasource.dart';
import '../models/transaction_model.dart';

class TallyRepositoryImpl implements TallyRepository {
  final PlaygroundLocalDataSource local;

  const TallyRepositoryImpl(this.local);

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions() async {
    try {
      return Right(local.readTransactions());
    } on FormatException {
      // Corrupt stored JSON must not brick the tool — start clean instead.
      return const Right([]);
    } on TypeError {
      return const Right([]);
    } catch (_) {
      return const Left(CacheFailure('Could not read saved transactions.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveTransactions(
    List<TransactionEntity> transactions,
  ) async {
    try {
      await local.writeTransactions(
        transactions.map(TransactionModel.fromEntity).toList(),
      );
      return const Right(unit);
    } catch (_) {
      return const Left(CacheFailure('Could not save your transactions.'));
    }
  }
}
