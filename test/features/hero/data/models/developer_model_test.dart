import 'package:flutter_portfolio/features/hero/data/models/developer_model.dart';
import 'package:flutter_portfolio/features/hero/domain/entities/developer_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('DeveloperModel.fromJson', () {
    test('parses all fields correctly', () {
      final model = DeveloperModel.fromJson(tDeveloperJson);

      expect(model.name, 'Manohar Thullimalli');
      expect(model.title, 'Senior Flutter Developer');
      expect(model.yearsOfExperience, 5);
      expect(model.projectsCompleted, 20);
      expect(model.platformsSupported, 4);
    });

    test('parses socialLinks map into SocialLinks value object', () {
      final model = DeveloperModel.fromJson(tDeveloperJson);

      expect(model.socialLinks.github, 'https://github.com/test');
      expect(model.socialLinks.linkedin, 'https://linkedin.com/in/test');
      expect(model.socialLinks.resumeUrl, 'assets/resume/test.pdf');
    });

    test('handles missing socialLinks keys gracefully', () {
      final json = Map<String, dynamic>.from(tDeveloperJson);
      json['socialLinks'] = <String, dynamic>{};

      final model = DeveloperModel.fromJson(json);

      expect(model.socialLinks.github, '');
      expect(model.socialLinks.linkedin, '');
    });
  });

  group('DeveloperModel.toJson', () {
    test('round-trips through toJson -> fromJson', () {
      final original = DeveloperModel.fromJson(tDeveloperJson);
      final roundTripped = DeveloperModel.fromJson(original.toJson());

      expect(roundTripped, original);
    });

    test('serialises socialLinks as a map', () {
      final json = tDeveloper.toJson();
      expect(json['socialLinks'], isA<Map<String, dynamic>>());
    });
  });

  group('DeveloperModel.copyWith', () {
    test('overrides specified fields only', () {
      final copy = tDeveloper.copyWith(name: 'Changed');
      expect(copy.name, 'Changed');
      expect(copy.title, tDeveloper.title);
    });

    test('returns equal model when no fields changed', () {
      expect(tDeveloper.copyWith(), tDeveloper);
    });
  });

  group('Equatable', () {
    test('two models with same data are equal', () {
      final a = DeveloperModel.fromJson(tDeveloperJson);
      final b = DeveloperModel.fromJson(tDeveloperJson);
      expect(a, b);
    });

    test('SocialLinks with same data are equal', () {
      const a = SocialLinks(github: 'gh', linkedin: 'li');
      const b = SocialLinks(github: 'gh', linkedin: 'li');
      expect(a, b);
    });
  });
}
