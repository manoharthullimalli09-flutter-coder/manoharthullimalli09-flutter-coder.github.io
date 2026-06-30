import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/developer_entity.dart';
import '../../domain/repositories/hero_repository.dart';
import '../datasources/hero_local_datasource.dart';

class HeroRepositoryImpl implements HeroRepository {
  final HeroLocalDataSource dataSource;

  HeroRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, DeveloperEntity>> getDeveloperInfo() async {
    try {
      final model = await dataSource.getDeveloperInfo();
      return Right(model);
    } on TypeError catch (e) {
      return Left(ParseFailure('Developer data has unexpected format: $e'));
    } on FormatException catch (e) {
      return Left(ParseFailure(e.message));
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
