import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/developer_entity.dart';
import '../../domain/usecases/get_developer_info_usecase.dart';

part 'hero_event.dart';
part 'hero_state.dart';

class HeroBloc extends Bloc<HeroEvent, HeroState> {
  final GetDeveloperInfoUseCase getDeveloperInfo;

  HeroBloc({required this.getDeveloperInfo}) : super(HeroInitial()) {
    on<LoadDeveloperInfo>(_onLoadDeveloperInfo);
  }

  Future<void> _onLoadDeveloperInfo(LoadDeveloperInfo event, Emitter<HeroState> emit) async {
    emit(HeroLoading());
    final result = await getDeveloperInfo(NoParams());
    result.fold(
      (failure) => emit(HeroError(failure.message)),
      (developer) => emit(HeroLoaded(developer)),
    );
  }
}
