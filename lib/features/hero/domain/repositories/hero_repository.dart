import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/developer_entity.dart';

abstract class HeroRepository {
  Future<Either<Failure, DeveloperEntity>> getDeveloperInfo();
}
