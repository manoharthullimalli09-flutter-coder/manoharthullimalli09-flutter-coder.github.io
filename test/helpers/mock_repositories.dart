import 'package:flutter_portfolio/features/contact/domain/repositories/contact_repository.dart';
import 'package:flutter_portfolio/features/hero/domain/repositories/hero_repository.dart';
import 'package:flutter_portfolio/features/projects/domain/repositories/projects_repository.dart';
import 'package:flutter_portfolio/features/skills/domain/repositories/skills_repository.dart';
import 'package:flutter_portfolio/features/hero/domain/usecases/get_developer_info_usecase.dart';
import 'package:flutter_portfolio/features/projects/domain/usecases/get_projects_usecase.dart';
import 'package:flutter_portfolio/features/skills/domain/usecases/get_skills_usecase.dart';
import 'package:flutter_portfolio/features/contact/domain/usecases/submit_contact_form_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockHeroRepository extends Mock implements HeroRepository {}

class MockProjectsRepository extends Mock implements ProjectsRepository {}

class MockSkillsRepository extends Mock implements SkillsRepository {}

class MockContactRepository extends Mock implements ContactRepository {}

class MockGetDeveloperInfoUseCase extends Mock
    implements GetDeveloperInfoUseCase {}

class MockGetProjectsUseCase extends Mock implements GetProjectsUseCase {}

class MockFilterByPlatformUseCase extends Mock
    implements FilterProjectsByPlatformUseCase {}

class MockGetSkillsUseCase extends Mock implements GetSkillsUseCase {}

class MockSubmitContactFormUseCase extends Mock
    implements SubmitContactFormUseCase {}
