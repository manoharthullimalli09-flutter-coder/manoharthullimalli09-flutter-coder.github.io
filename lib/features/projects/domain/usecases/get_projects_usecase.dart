import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUseCase implements UseCase<List<ProjectEntity>, NoParams> {
  final ProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProjectEntity>>> call(NoParams params) =>
      repository.getProjects();
}

class FilterProjectsByPlatformParams {
  final String platform;
  const FilterProjectsByPlatformParams(this.platform);
}

class FilterProjectsByPlatformUseCase
    implements UseCase<List<ProjectEntity>, FilterProjectsByPlatformParams> {
  final ProjectsRepository repository;

  FilterProjectsByPlatformUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProjectEntity>>> call(FilterProjectsByPlatformParams params) =>
      repository.getProjectsByPlatform(params.platform);
}
