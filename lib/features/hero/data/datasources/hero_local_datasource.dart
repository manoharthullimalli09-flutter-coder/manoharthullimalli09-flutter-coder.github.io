import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/developer_model.dart';

abstract class HeroLocalDataSource {
  Future<DeveloperModel> getDeveloperInfo();
}

class HeroLocalDataSourceImpl implements HeroLocalDataSource {
  @override
  Future<DeveloperModel> getDeveloperInfo() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/portfolio_data.json',
    );
    final data = json.decode(jsonString) as Map<String, dynamic>;
    return DeveloperModel.fromJson(data['developer'] as Map<String, dynamic>);
  }
}
