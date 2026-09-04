part of 'breathing_cubit.dart';

class BreathingState extends Equatable {
  final BreathingPattern pattern;
  final BreathPhase phase;
  final bool isRunning;
  final int cyclesDone;
  final int sessionsCompleted;
  final bool justFinished;

  const BreathingState({
    this.pattern = BreathingPattern.box,
    this.phase = BreathPhase.inhale,
    this.isRunning = false,
    this.cyclesDone = 0,
    this.sessionsCompleted = 0,
    this.justFinished = false,
  });

  int get phaseSeconds => pattern.secondsFor(phase);

  String get phaseLabel => switch (phase) {
    BreathPhase.inhale => 'Breathe in',
    BreathPhase.holdIn => 'Hold',
    BreathPhase.exhale => 'Breathe out',
    BreathPhase.holdOut => 'Hold',
  };

  BreathingState copyWith({
    BreathingPattern? pattern,
    BreathPhase? phase,
    bool? isRunning,
    int? cyclesDone,
    int? sessionsCompleted,
    bool? justFinished,
  }) => BreathingState(
    pattern: pattern ?? this.pattern,
    phase: phase ?? this.phase,
    isRunning: isRunning ?? this.isRunning,
    cyclesDone: cyclesDone ?? this.cyclesDone,
    sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
    justFinished: justFinished ?? this.justFinished,
  );

  @override
  List<Object?> get props => [
    pattern,
    phase,
    isRunning,
    cyclesDone,
    sessionsCompleted,
    justFinished,
  ];
}
