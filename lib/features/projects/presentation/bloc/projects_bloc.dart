import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/usecases/get_projects_usecase.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  final GetProjectsUseCase getProjects;

  List<ProjectEntity> _allProjects = [];

  ProjectsBloc({required this.getProjects}) : super(ProjectsInitial()) {
    on<LoadProjects>(_onLoadProjects);
    on<FilterProjectsByPlatform>(_onFilter);
    on<ClearProjectFilter>(_onClearFilter);
  }

  Future<void> _onLoadProjects(
    LoadProjects event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());
    final result = await getProjects(NoParams());
    result.fold((failure) => emit(ProjectsError(failure.message)), (projects) {
      _allProjects = projects;
      emit(ProjectsLoaded(projects: projects, activeFilter: null));
    });
  }

  void _onFilter(FilterProjectsByPlatform event, Emitter<ProjectsState> emit) {
    final filtered = _allProjects
        .where((p) => p.platforms.contains(event.platform))
        .toList();
    emit(ProjectsLoaded(projects: filtered, activeFilter: event.platform));
  }

  void _onClearFilter(ClearProjectFilter event, Emitter<ProjectsState> emit) {
    emit(ProjectsLoaded(projects: _allProjects, activeFilter: null));
  }
}
