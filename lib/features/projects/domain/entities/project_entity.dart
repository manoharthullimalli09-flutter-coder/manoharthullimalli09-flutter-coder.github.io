import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> platforms;
  final List<String> techStack;
  final String imageUrl;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? webUrl;
  final String? githubUrl;
  final bool isFeatured;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.platforms,
    required this.techStack,
    required this.imageUrl,
    this.playStoreUrl,
    this.appStoreUrl,
    this.webUrl,
    this.githubUrl,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [id, title, description, category, platforms,
      techStack, imageUrl, playStoreUrl, appStoreUrl, webUrl, githubUrl, isFeatured];
}
