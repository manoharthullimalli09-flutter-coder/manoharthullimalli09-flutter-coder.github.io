import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_datasource.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ProjectsLocalDataSource dataSource;

  ProjectsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    try {
      final models = await dataSource.getProjects();
      return Right(models);
    } on TypeError catch (e) {
      return Left(ParseFailure('Projects data has unexpected format: $e'));
    } on FormatException catch (e) {
      return Left(ParseFailure(e.message));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjectsByPlatform(String platform) async {
    try {
      final models = await dataSource.getProjects();
      final filtered = models.where((p) => p.platforms.contains(platform)).toList();
      return Right(filtered);
    } on TypeError catch (e) {
      return Left(ParseFailure('Projects data has unexpected format: $e'));
    } on FormatException catch (e) {
      return Left(ParseFailure(e.message));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
