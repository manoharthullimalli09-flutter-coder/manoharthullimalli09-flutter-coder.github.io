import '../../domain/entities/developer_entity.dart';

class DeveloperModel extends DeveloperEntity {
  const DeveloperModel({
    required super.name,
    required super.title,
    required super.bio,
    required super.email,
    required super.profileImageUrl,
    required super.yearsOfExperience,
    required super.projectsCompleted,
    required super.platformsSupported,
    required super.socialLinks,
  });

  factory DeveloperModel.fromJson(Map<String, dynamic> json) => DeveloperModel(
        name: json['name'] as String,
        title: json['title'] as String,
        bio: json['bio'] as String,
        email: json['email'] as String,
        profileImageUrl: json['profileImageUrl'] as String,
        yearsOfExperience: json['yearsOfExperience'] as int,
        projectsCompleted: json['projectsCompleted'] as int,
        platformsSupported: json['platformsSupported'] as int,
        socialLinks: SocialLinks.fromJson(
          json['socialLinks'] as Map<String, dynamic>? ?? {},
        ),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'bio': bio,
        'email': email,
        'profileImageUrl': profileImageUrl,
        'yearsOfExperience': yearsOfExperience,
        'projectsCompleted': projectsCompleted,
        'platformsSupported': platformsSupported,
        'socialLinks': {
          'github': socialLinks.github,
          'linkedin': socialLinks.linkedin,
          'twitter': socialLinks.twitter,
          'resume': socialLinks.resumeUrl,
        },
      };

  DeveloperModel copyWith({
    String? name,
    String? title,
    String? bio,
    String? email,
    String? profileImageUrl,
    int? yearsOfExperience,
    int? projectsCompleted,
    int? platformsSupported,
    SocialLinks? socialLinks,
  }) =>
      DeveloperModel(
        name: name ?? this.name,
        title: title ?? this.title,
        bio: bio ?? this.bio,
        email: email ?? this.email,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
        projectsCompleted: projectsCompleted ?? this.projectsCompleted,
        platformsSupported: platformsSupported ?? this.platformsSupported,
        socialLinks: socialLinks ?? this.socialLinks,
      );
}
