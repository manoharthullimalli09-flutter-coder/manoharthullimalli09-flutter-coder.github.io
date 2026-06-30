import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/developer_entity.dart';
import '../repositories/hero_repository.dart';

class GetDeveloperInfoUseCase implements UseCase<DeveloperEntity, NoParams> {
  final HeroRepository repository;

  GetDeveloperInfoUseCase(this.repository);

  @override
  Future<Either<Failure, DeveloperEntity>> call(NoParams params) =>
      repository.getDeveloperInfo();
}
