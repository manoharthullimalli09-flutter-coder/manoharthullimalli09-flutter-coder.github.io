import 'package:equatable/equatable.dart';

class SkillEntity extends Equatable {
  final String name;
  final double proficiency; // 0.0 – 1.0
  final String category;
  final String? iconPath;

  const SkillEntity({
    required this.name,
    required this.proficiency,
    required this.category,
    this.iconPath,
  });

  @override
  List<Object?> get props => [name, proficiency, category, iconPath];
}

class SkillCategoryEntity extends Equatable {
  final String name;
  final List<SkillEntity> skills;

  const SkillCategoryEntity({required this.name, required this.skills});

  @override
  List<Object> get props => [name, skills];
}
