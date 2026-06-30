import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/skill_entity.dart';
import '../../domain/usecases/get_skills_usecase.dart';

part 'skills_state.dart';

class SkillsCubit extends Cubit<SkillsState> {
  final GetSkillsUseCase getSkills;

  SkillsCubit({required this.getSkills}) : super(SkillsInitial());

  Future<void> loadSkills() async {
    emit(SkillsLoading());
    final result = await getSkills(NoParams());
    result.fold(
      (failure) => emit(SkillsError(failure.message)),
      (categories) => emit(SkillsLoaded(categories)),
    );
  }
}
