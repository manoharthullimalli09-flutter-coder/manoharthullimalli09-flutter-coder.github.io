import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/contact_form_entity.dart';

abstract class ContactRepository {
  Future<Either<Failure, Unit>> submitForm(ContactFormEntity form);
}
