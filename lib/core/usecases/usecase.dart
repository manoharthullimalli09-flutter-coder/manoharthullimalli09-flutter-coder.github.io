import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

abstract class UseCase<Output, Params> {
  Future<Either<Failure, Output>> call(Params params);
}

/// Same contract as [UseCase] without the `Future`, for use cases that are
/// pure computation — no I/O to await. They still return `Either` because
/// input validation genuinely fails (a negative principal, a zero tenure).
abstract class SyncUseCase<Output, Params> {
  Either<Failure, Output> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
