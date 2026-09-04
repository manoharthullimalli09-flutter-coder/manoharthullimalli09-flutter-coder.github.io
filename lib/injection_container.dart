import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'features/contact/data/datasources/contact_remote_datasource.dart';
import 'features/contact/data/repositories/contact_repository_impl.dart';
import 'features/contact/domain/repositories/contact_repository.dart';
import 'features/contact/domain/usecases/submit_contact_form_usecase.dart';
import 'features/contact/presentation/bloc/contact_bloc.dart';
import 'features/hero/data/datasources/hero_local_datasource.dart';
import 'features/hero/data/repositories/hero_repository_impl.dart';
import 'features/hero/domain/repositories/hero_repository.dart';
import 'features/hero/domain/usecases/download_resume_usecase.dart';
import 'features/hero/domain/usecases/get_developer_info_usecase.dart';
import 'features/hero/presentation/bloc/hero_bloc.dart';
import 'features/playground/data/datasources/playground_local_datasource.dart';
import 'features/playground/data/repositories/streak_repository_impl.dart';
import 'features/playground/data/repositories/tally_repository_impl.dart';
import 'features/playground/domain/repositories/streak_repository.dart';
import 'features/playground/domain/repositories/tally_repository.dart';
import 'features/playground/domain/usecases/calculate_emi_usecase.dart';
import 'features/playground/domain/usecases/calculate_salary_usecase.dart';
import 'features/playground/domain/usecases/calculate_sip_usecase.dart';
import 'features/playground/domain/usecases/streak_usecases.dart';
import 'features/playground/domain/usecases/tally_usecases.dart';
import 'features/playground/presentation/bloc/breathing_cubit.dart';
import 'features/playground/presentation/bloc/emi_cubit.dart';
import 'features/playground/presentation/bloc/salary_cubit.dart';
import 'features/playground/presentation/bloc/sip_cubit.dart';
import 'features/playground/presentation/bloc/tally_bloc.dart';
import 'features/projects/data/datasources/projects_local_datasource.dart';
import 'features/projects/data/repositories/projects_repository_impl.dart';
import 'features/projects/domain/repositories/projects_repository.dart';
import 'features/projects/domain/usecases/get_projects_usecase.dart';
import 'features/projects/presentation/bloc/projects_bloc.dart';
import 'features/skills/data/datasources/skills_local_datasource.dart';
import 'features/skills/data/repositories/skills_repository_impl.dart';
import 'features/skills/domain/repositories/skills_repository.dart';
import 'features/skills/domain/usecases/get_skills_usecase.dart';
import 'features/skills/presentation/bloc/skills_cubit.dart';
import 'features/theme_switcher/presentation/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- External ---
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);

  final dio = Dio()
    ..options = BaseOptions(
      baseUrl: AppConfig.emailJsBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    )
    ..interceptors.addAll([
      if (AppConfig.enableLogging)
        LogInterceptor(requestBody: true, responseBody: true),
    ]);
  sl.registerLazySingleton(() => dio);

  // --- Data sources ---
  sl.registerLazySingleton<HeroLocalDataSource>(
    () => HeroLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<ProjectsLocalDataSource>(
    () => ProjectsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SkillsLocalDataSource>(
    () => SkillsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<PlaygroundLocalDataSource>(
    () => PlaygroundLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ContactRemoteDataSource>(
    () => ContactRemoteDataSourceImpl(
      dio: sl(),
      serviceId: AppConfig.emailJsServiceId,
      templateId: AppConfig.emailJsTemplateId,
      publicKey: AppConfig.emailJsPublicKey,
    ),
  );

  // --- Repositories ---
  sl.registerLazySingleton<HeroRepository>(() => HeroRepositoryImpl(sl()));
  sl.registerLazySingleton<ProjectsRepository>(
    () => ProjectsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SkillsRepository>(() => SkillsRepositoryImpl(sl()));
  sl.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TallyRepository>(() => TallyRepositoryImpl(sl()));
  sl.registerLazySingleton<StreakRepository>(() => StreakRepositoryImpl(sl()));

  // --- Use cases ---
  sl.registerLazySingleton(() => GetDeveloperInfoUseCase(sl()));
  sl.registerLazySingleton(() => const DownloadResumeUseCase());
  sl.registerLazySingleton(() => GetProjectsUseCase(sl()));
  sl.registerLazySingleton(() => FilterProjectsByPlatformUseCase(sl()));
  sl.registerLazySingleton(() => GetSkillsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitContactFormUseCase(sl()));
  sl.registerLazySingleton(() => const CalculateEmiUseCase());
  sl.registerLazySingleton(() => const CalculateSipUseCase());
  sl.registerLazySingleton(() => const CalculateSalaryUseCase());
  sl.registerLazySingleton(() => GetTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => SaveTransactionsUseCase(sl()));
  sl.registerLazySingleton(() => GetSessionsCompletedUseCase(sl()));
  sl.registerLazySingleton(() => RecordBreathingSessionUseCase(sl()));

  // --- BLoCs (Factory = new instance per screen) ---
  sl.registerFactory(() => HeroBloc(getDeveloperInfo: sl()));
  sl.registerFactory(() => ProjectsBloc(getProjects: sl()));
  sl.registerFactory(() => SkillsCubit(getSkills: sl()));
  sl.registerFactory(() => ContactBloc(submitForm: sl()));
  sl.registerFactory(() => EmiCubit(calculateEmi: sl()));
  sl.registerFactory(() => SipCubit(calculateSip: sl()));
  sl.registerFactory(() => SalaryCubit(calculateSalary: sl()));
  sl.registerFactory(
    () => TallyBloc(getTransactions: sl(), saveTransactions: sl()),
  );
  sl.registerFactory(
    () => BreathingCubit(getSessions: sl(), recordSession: sl()),
  );
  sl.registerLazySingleton(() => ThemeCubit(prefs: sl()));
}
