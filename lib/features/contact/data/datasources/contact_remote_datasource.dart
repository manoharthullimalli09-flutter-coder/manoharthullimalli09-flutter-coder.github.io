import 'package:dio/dio.dart';
import '../models/contact_form_model.dart';

abstract class ContactRemoteDataSource {
  Future<void> submitForm(ContactFormModel form);
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final Dio dio;
  final String serviceId;
  final String templateId;
  final String publicKey;

  const ContactRemoteDataSourceImpl({
    required this.dio,
    required this.serviceId,
    required this.templateId,
    required this.publicKey,
  });

  @override
  Future<void> submitForm(ContactFormModel form) async {
    await dio.post(
      '/api/v1.0/email/send',
      data: form.toEmailJsParams(serviceId, templateId, publicKey),
    );
  }
}
