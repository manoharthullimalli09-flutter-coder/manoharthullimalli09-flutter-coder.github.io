import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/project_model.dart';

abstract class ProjectsLocalDataSource {
  Future<List<ProjectModel>> getProjects();
}

class ProjectsLocalDataSourceImpl implements ProjectsLocalDataSource {
  @override
  Future<List<ProjectModel>> getProjects() async {
    final jsonString = await rootBundle.loadString('assets/data/portfolio_data.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final list = data['projects'] as List;
    return list.map((e) => ProjectModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
