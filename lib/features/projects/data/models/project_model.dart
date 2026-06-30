import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.platforms,
    required super.techStack,
    required super.imageUrl,
    super.playStoreUrl,
    super.appStoreUrl,
    super.webUrl,
    super.githubUrl,
    super.isFeatured,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    platforms: List<String>.from(json['platforms'] as List),
    techStack: List<String>.from(json['techStack'] as List),
    imageUrl: json['imageUrl'] as String,
    playStoreUrl: json['playStoreUrl'] as String?,
    appStoreUrl: json['appStoreUrl'] as String?,
    webUrl: json['webUrl'] as String?,
    githubUrl: json['githubUrl'] as String?,
    isFeatured: json['isFeatured'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'platforms': platforms,
    'techStack': techStack,
    'imageUrl': imageUrl,
    'playStoreUrl': playStoreUrl,
    'appStoreUrl': appStoreUrl,
    'webUrl': webUrl,
    'githubUrl': githubUrl,
    'isFeatured': isFeatured,
  };

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<String>? platforms,
    List<String>? techStack,
    String? imageUrl,
    String? playStoreUrl,
    String? appStoreUrl,
    String? webUrl,
    String? githubUrl,
    bool? isFeatured,
  }) => ProjectModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    platforms: platforms ?? this.platforms,
    techStack: techStack ?? this.techStack,
    imageUrl: imageUrl ?? this.imageUrl,
    playStoreUrl: playStoreUrl ?? this.playStoreUrl,
    appStoreUrl: appStoreUrl ?? this.appStoreUrl,
    webUrl: webUrl ?? this.webUrl,
    githubUrl: githubUrl ?? this.githubUrl,
    isFeatured: isFeatured ?? this.isFeatured,
  );
}
