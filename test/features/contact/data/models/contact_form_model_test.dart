import 'package:flutter_portfolio/features/contact/data/models/contact_form_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('ContactFormModel.fromEntity', () {
    test('copies all fields from entity', () {
      final model = ContactFormModel.fromEntity(tContactForm);

      expect(model.name, tContactForm.name);
      expect(model.email, tContactForm.email);
      expect(model.subject, tContactForm.subject);
      expect(model.message, tContactForm.message);
    });
  });

  group('ContactFormModel.toEmailJsParams', () {
    test('builds correct EmailJS payload structure', () {
      final model = ContactFormModel.fromEntity(tContactForm);
      final params = model.toEmailJsParams('svc_id', 'tmpl_id', 'pub_key');

      expect(params['service_id'], 'svc_id');
      expect(params['template_id'], 'tmpl_id');
      expect(params['user_id'], 'pub_key');
      expect(params['template_params']['from_name'], tContactForm.name);
      expect(params['template_params']['from_email'], tContactForm.email);
      expect(params['template_params']['subject'], tContactForm.subject);
      expect(params['template_params']['message'], tContactForm.message);
    });
  });

  group('Equatable', () {
    test('two models from same entity are equal', () {
      final a = ContactFormModel.fromEntity(tContactForm);
      final b = ContactFormModel.fromEntity(tContactForm);
      expect(a, b);
    });
  });
}
