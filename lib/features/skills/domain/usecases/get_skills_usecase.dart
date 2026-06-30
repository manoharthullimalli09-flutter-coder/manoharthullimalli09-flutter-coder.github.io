import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/skill_entity.dart';
import '../repositories/skills_repository.dart';

class GetSkillsUseCase implements UseCase<List<SkillCategoryEntity>, NoParams> {
  final SkillsRepository repository;

  GetSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SkillCategoryEntity>>> call(NoParams params) =>
      repository.getSkillCategories();
}
