import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class StreakRepository {
  Future<Either<Failure, int>> getSessionsCompleted();
  Future<Either<Failure, int>> incrementSessionsCompleted();
}
