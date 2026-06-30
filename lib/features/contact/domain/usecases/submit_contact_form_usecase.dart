import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/contact_form_entity.dart';
import '../repositories/contact_repository.dart';

class SubmitContactFormUseCase implements UseCase<Unit, ContactFormEntity> {
  final ContactRepository repository;

  SubmitContactFormUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ContactFormEntity params) =>
      repository.submitForm(params);
}
