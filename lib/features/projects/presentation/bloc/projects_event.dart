part of 'projects_bloc.dart';

abstract class ProjectsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProjects extends ProjectsEvent {}

class FilterProjectsByPlatform extends ProjectsEvent {
  final String platform;
  FilterProjectsByPlatform(this.platform);

  @override
  List<Object> get props => [platform];
}

class ClearProjectFilter extends ProjectsEvent {}
