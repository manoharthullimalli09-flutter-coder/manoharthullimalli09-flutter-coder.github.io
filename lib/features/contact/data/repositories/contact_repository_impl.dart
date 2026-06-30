import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/contact_form_entity.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_remote_datasource.dart';
import '../models/contact_form_model.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource dataSource;

  ContactRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Unit>> submitForm(ContactFormEntity form) async {
    try {
      await dataSource.submitForm(ContactFormModel.fromEntity(form));
      return const Right(unit);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(ServerFailure(e.message ?? 'Failed to send message.'));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
