part of 'projects_bloc.dart';

abstract class ProjectsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<ProjectEntity> projects;
  final String? activeFilter;

  ProjectsLoaded({required this.projects, this.activeFilter});

  @override
  List<Object?> get props => [projects, activeFilter];
}

class ProjectsError extends ProjectsState {
  final String message;
  ProjectsError(this.message);

  @override
  List<Object> get props => [message];
}
