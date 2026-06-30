import 'package:flutter_portfolio/features/projects/data/models/project_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/test_data.dart';

void main() {
  group('ProjectModel', () {
    test('fromJson produces correct model', () {
      final model = ProjectModel.fromJson(tProjectJson);
      expect(model.id, 'test-project');
      expect(model.title, 'Test Project');
      expect(model.platforms, containsAll(['android', 'ios']));
      expect(model.isFeatured, true);
    });

    test('toJson round-trips correctly', () {
      final model = ProjectModel.fromJson(tProjectJson);
      final json = model.toJson();
      expect(json['id'], model.id);
      expect(json['platforms'], model.platforms);
    });

    test('equality is value-based via Equatable', () {
      final a = ProjectModel.fromJson(tProjectJson);
      final b = ProjectModel.fromJson(tProjectJson);
      expect(a, equals(b));
    });
  });
}
