import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/repositories/skills_repository.dart';
import '../datasources/skills_local_datasource.dart';

class SkillsRepositoryImpl implements SkillsRepository {
  final SkillsLocalDataSource dataSource;

  SkillsRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<SkillCategoryEntity>>>
  getSkillCategories() async {
    try {
      final models = await dataSource.getSkillCategories();
      return Right(models);
    } on TypeError catch (e) {
      return Left(ParseFailure('Skills data has unexpected format: $e'));
    } on FormatException catch (e) {
      return Left(ParseFailure(e.message));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
