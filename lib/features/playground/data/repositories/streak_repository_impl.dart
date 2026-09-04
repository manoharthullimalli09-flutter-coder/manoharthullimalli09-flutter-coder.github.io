import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/streak_repository.dart';
import '../datasources/playground_local_datasource.dart';

class StreakRepositoryImpl implements StreakRepository {
  final PlaygroundLocalDataSource local;

  const StreakRepositoryImpl(this.local);

  @override
  Future<Either<Failure, int>> getSessionsCompleted() async {
    try {
      return Right(local.readSessionsCompleted());
    } catch (_) {
      return const Left(CacheFailure('Could not read your session count.'));
    }
  }

  @override
  Future<Either<Failure, int>> incrementSessionsCompleted() async {
    try {
      return Right(await local.incrementSessionsCompleted());
    } catch (_) {
      return const Left(CacheFailure('Could not save your session.'));
    }
  }
}
