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

  bool get _isConfigured =>
      serviceId.isNotEmpty && templateId.isNotEmpty && publicKey.isNotEmpty;

  @override
  Future<void> submitForm(ContactFormModel form) async {
    if (!_isConfigured) {
      throw const ContactNotConfiguredException();
    }
    await dio.post(
      '/api/v1.0/email/send',
      data: form.toEmailJsParams(serviceId, templateId, publicKey),
    );
  }
}

/// Thrown when the build carries no EmailJS credentials, so the form can say
/// something useful rather than surfacing a 400 from the API.
class ContactNotConfiguredException implements Exception {
  const ContactNotConfiguredException();

  @override
  String toString() => 'EmailJS credentials were not provided at build time.';
}
