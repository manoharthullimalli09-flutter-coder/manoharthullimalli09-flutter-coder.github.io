import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/breathing_pattern.dart';
import '../../domain/usecases/streak_usecases.dart';

part 'breathing_state.dart';

/// Owns the phase machine and the session count. The animation itself lives
/// in the widget's [AnimationController]; this cubit is told when a phase has
/// finished playing and decides what comes next.
class BreathingCubit extends Cubit<BreathingState> {
  static const cyclesPerSession = 6;

  final GetSessionsCompletedUseCase getSessions;
  final RecordBreathingSessionUseCase recordSession;

  BreathingCubit({required this.getSessions, required this.recordSession})
      : super(const BreathingState());

  Future<void> loadSessions() async {
    final result = await getSessions(NoParams());
    result.fold(
      (_) {},
      (count) => emit(state.copyWith(sessionsCompleted: count)),
    );
  }

  void selectPattern(BreathingPattern pattern) {
    if (state.isRunning) return;
    emit(state.copyWith(pattern: pattern, phase: BreathPhase.inhale));
  }

  void start() => emit(
        state.copyWith(
          isRunning: true,
          phase: BreathPhase.inhale,
          cyclesDone: 0,
          justFinished: false,
        ),
      );

  void stop() => emit(state.copyWith(isRunning: false, cyclesDone: 0));

  /// Called by the widget when the current phase's animation completes.
  Future<void> completePhase() async {
    if (!state.isRunning) return;

    final next = state.pattern.nextPhase(state.phase);

    // Wrapping back to inhale means a full cycle just finished.
    final completedCycle = next == BreathPhase.inhale;
    final cycles = state.cyclesDone + (completedCycle ? 1 : 0);

    if (cycles >= cyclesPerSession) {
      emit(state.copyWith(isRunning: false, cyclesDone: 0, justFinished: true));
      final result = await recordSession(NoParams());
      result.fold(
        (_) {},
        (count) => emit(state.copyWith(sessionsCompleted: count)),
      );
      return;
    }

    emit(state.copyWith(phase: next, cyclesDone: cycles));
  }

  void acknowledgeFinish() => emit(state.copyWith(justFinished: false));
}
