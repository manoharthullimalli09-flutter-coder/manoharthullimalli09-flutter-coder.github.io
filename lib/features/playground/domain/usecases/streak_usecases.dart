import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/streak_repository.dart';

class GetSessionsCompletedUseCase implements UseCase<int, NoParams> {
  final StreakRepository repository;

  const GetSessionsCompletedUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) =>
      repository.getSessionsCompleted();
}

class RecordBreathingSessionUseCase implements UseCase<int, NoParams> {
  final StreakRepository repository;

  const RecordBreathingSessionUseCase(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) =>
      repository.incrementSessionsCompleted();
}
