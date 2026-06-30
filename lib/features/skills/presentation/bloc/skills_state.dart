part of 'skills_cubit.dart';

abstract class SkillsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SkillsInitial extends SkillsState {}

class SkillsLoading extends SkillsState {}

class SkillsLoaded extends SkillsState {
  final List<SkillCategoryEntity> categories;
  SkillsLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class SkillsError extends SkillsState {
  final String message;
  SkillsError(this.message);

  @override
  List<Object> get props => [message];
}
