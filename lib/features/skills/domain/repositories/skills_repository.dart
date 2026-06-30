import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/skill_entity.dart';

abstract class SkillsRepository {
  Future<Either<Failure, List<SkillCategoryEntity>>> getSkillCategories();
}
