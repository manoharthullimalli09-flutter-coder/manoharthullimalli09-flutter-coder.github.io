import 'package:flutter_portfolio/features/hero/data/models/developer_model.dart';
import 'package:flutter_portfolio/features/hero/domain/entities/developer_entity.dart';
import 'package:flutter_portfolio/features/projects/data/models/project_model.dart';
import 'package:flutter_portfolio/features/projects/domain/entities/project_entity.dart';
import 'package:flutter_portfolio/features/skills/data/models/skill_model.dart';
import 'package:flutter_portfolio/features/skills/domain/entities/skill_entity.dart';
import 'package:flutter_portfolio/features/contact/domain/entities/contact_form_entity.dart';

// --- Developer fixtures ---
const tSocialLinks = SocialLinks(
  github: 'https://github.com/test',
  linkedin: 'https://linkedin.com/in/test',
  twitter: '',
  resumeUrl: 'assets/resume/test.pdf',
);

const tDeveloperJson = {
  'name': 'Manohar Thullimalli',
  'title': 'Senior Flutter Developer',
  'bio': 'Test bio',
  'email': 'test@test.com',
  'profileImageUrl': 'assets/images/profile.jpg',
  'yearsOfExperience': 5,
  'projectsCompleted': 20,
  'platformsSupported': 4,
  'socialLinks': {
    'github': 'https://github.com/test',
    'linkedin': 'https://linkedin.com/in/test',
    'twitter': '',
    'resume': 'assets/resume/test.pdf',
  },
};

const tDeveloper = DeveloperModel(
  name: 'Manohar Thullimalli',
  title: 'Senior Flutter Developer',
  bio: 'Test bio',
  email: 'test@test.com',
  profileImageUrl: 'assets/images/profile.jpg',
  yearsOfExperience: 5,
  projectsCompleted: 20,
  platformsSupported: 4,
  socialLinks: tSocialLinks,
);

// --- Project fixtures ---
const tProjectJson = {
  'id': 'test-project',
  'title': 'Test Project',
  'description': 'A test project',
  'category': 'E-Commerce',
  'platforms': ['android', 'ios'],
  'techStack': ['Flutter', 'BLoC'],
  'imageUrl': 'assets/images/test.webp',
  'isFeatured': true,
};

const tProject = ProjectModel(
  id: 'test-project',
  title: 'Test Project',
  description: 'A test project',
  category: 'E-Commerce',
  platforms: ['android', 'ios'],
  techStack: ['Flutter', 'BLoC'],
  imageUrl: 'assets/images/test.webp',
  isFeatured: true,
);

final tProjects = [tProject];

// --- Skill fixtures ---
const tSkill = SkillModel(
  name: 'Flutter',
  proficiency: 0.97,
  category: 'Flutter & Dart',
);

const tSkillCategoryJson = {
  'name': 'Flutter & Dart',
  'skills': [
    {'name': 'Flutter', 'proficiency': 0.97, 'category': 'Flutter & Dart'},
    {'name': 'Dart', 'proficiency': 0.95, 'category': 'Flutter & Dart'},
  ],
};

final tSkillCategory = SkillCategoryModel.fromJson(tSkillCategoryJson);
final tSkillCategories = [tSkillCategory];

// --- Contact fixtures ---
const tContactForm = ContactFormEntity(
  name: 'Test User',
  email: 'test@test.com',
  subject: 'Test Subject',
  message: 'Test message content',
);

// --- Convenience typed lists ---
final List<ProjectEntity> tProjectsTyped = [tProject];
final List<SkillCategoryEntity> tSkillCategoriesTyped = [tSkillCategory];
