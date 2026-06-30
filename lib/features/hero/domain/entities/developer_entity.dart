import 'package:equatable/equatable.dart';

class SocialLinks extends Equatable {
  final String github;
  final String linkedin;
  final String twitter;
  final String resumeUrl;

  const SocialLinks({
    this.github = '',
    this.linkedin = '',
    this.twitter = '',
    this.resumeUrl = '',
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
        github: json['github'] as String? ?? '',
        linkedin: json['linkedin'] as String? ?? '',
        twitter: json['twitter'] as String? ?? '',
        resumeUrl: json['resume'] as String? ?? '',
      );

  @override
  List<Object> get props => [github, linkedin, twitter, resumeUrl];
}

class DeveloperEntity extends Equatable {
  final String name;
  final String title;
  final String bio;
  final String email;
  final String profileImageUrl;
  final int yearsOfExperience;
  final int projectsCompleted;
  final int platformsSupported;
  final SocialLinks socialLinks;

  const DeveloperEntity({
    required this.name,
    required this.title,
    required this.bio,
    required this.email,
    required this.profileImageUrl,
    required this.yearsOfExperience,
    required this.projectsCompleted,
    required this.platformsSupported,
    required this.socialLinks,
  });

  @override
  List<Object> get props => [
        name, title, bio, email, profileImageUrl,
        yearsOfExperience, projectsCompleted, platformsSupported, socialLinks,
      ];
}
