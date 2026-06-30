import 'package:flutter_portfolio/features/skills/data/models/skill_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('SkillModel.fromJson', () {
    test('parses all fields correctly', () {
      final json = {
        'name': 'Flutter',
        'proficiency': 0.97,
        'category': 'Flutter & Dart',
      };
      final model = SkillModel.fromJson(json);

      expect(model.name, 'Flutter');
      expect(model.proficiency, 0.97);
      expect(model.category, 'Flutter & Dart');
      expect(model.iconPath, isNull);
    });

    test('parses proficiency from int correctly', () {
      final json = {
        'name': 'Dart',
        'proficiency': 1,
        'category': 'Flutter & Dart',
      };
      final model = SkillModel.fromJson(json);
      expect(model.proficiency, 1.0);
    });

    test('parses optional iconPath when present', () {
      final json = {
        'name': 'Flutter',
        'proficiency': 0.9,
        'category': 'Flutter & Dart',
        'iconPath': 'assets/icons/flutter.svg',
      };
      final model = SkillModel.fromJson(json);
      expect(model.iconPath, 'assets/icons/flutter.svg');
    });
  });

  group('SkillModel.toJson', () {
    test('serialises all fields', () {
      final json = tSkill.toJson();
      expect(json['name'], 'Flutter');
      expect(json['proficiency'], 0.97);
    });
  });

  group('SkillCategoryModel', () {
    test('fromJson parses category name and nested skills', () {
      final model = SkillCategoryModel.fromJson(tSkillCategoryJson);
      expect(model.name, 'Flutter & Dart');
      expect(model.skills.length, 2);
      expect(model.skills.first.name, 'Flutter');
    });
  });

  group('Equatable', () {
    test('two SkillModels with same data are equal', () {
      const a = SkillModel(
        name: 'Flutter',
        proficiency: 0.97,
        category: 'Flutter & Dart',
      );
      const b = SkillModel(
        name: 'Flutter',
        proficiency: 0.97,
        category: 'Flutter & Dart',
      );
      expect(a, b);
    });
  });
}
