import '../../domain/entities/contact_form_entity.dart';

class ContactFormModel extends ContactFormEntity {
  const ContactFormModel({
    required super.name,
    required super.email,
    required super.subject,
    required super.message,
  });

  factory ContactFormModel.fromEntity(ContactFormEntity entity) =>
      ContactFormModel(
        name: entity.name,
        email: entity.email,
        subject: entity.subject,
        message: entity.message,
      );

  Map<String, dynamic> toEmailJsParams(
    String serviceId,
    String templateId,
    String publicKey,
  ) => {
    'service_id': serviceId,
    'template_id': templateId,
    'user_id': publicKey,
    'template_params': {
      'from_name': name,
      'from_email': email,
      'subject': subject,
      'message': message,
    },
  };
}
