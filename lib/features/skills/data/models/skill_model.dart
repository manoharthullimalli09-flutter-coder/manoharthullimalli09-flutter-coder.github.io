import '../../domain/entities/skill_entity.dart';

class SkillModel extends SkillEntity {
  const SkillModel({
    required super.name,
    required super.proficiency,
    required super.category,
    super.iconPath,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
    name: json['name'] as String,
    proficiency: (json['proficiency'] as num).toDouble(),
    category: json['category'] as String,
    iconPath: json['iconPath'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'proficiency': proficiency,
    'category': category,
    'iconPath': iconPath,
  };
}

class SkillCategoryModel extends SkillCategoryEntity {
  const SkillCategoryModel({required super.name, required super.skills});

  factory SkillCategoryModel.fromJson(Map<String, dynamic> json) =>
      SkillCategoryModel(
        name: json['name'] as String,
        skills: (json['skills'] as List)
            .map((s) => SkillModel.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}
