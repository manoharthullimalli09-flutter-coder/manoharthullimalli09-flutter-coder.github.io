import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/skill_model.dart';

abstract class SkillsLocalDataSource {
  Future<List<SkillCategoryModel>> getSkillCategories();
}

class SkillsLocalDataSourceImpl implements SkillsLocalDataSource {
  @override
  Future<List<SkillCategoryModel>> getSkillCategories() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/portfolio_data.json',
    );
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final list = data['skillCategories'] as List;
    return list
        .map((e) => SkillCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
