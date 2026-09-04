import 'package:equatable/equatable.dart';

enum BreathPhase { inhale, holdIn, exhale, holdOut }

class BreathingPattern extends Equatable {
  final String name;
  final String description;
  final int inhale;
  final int holdIn;
  final int exhale;
  final int holdOut;

  const BreathingPattern({
    required this.name,
    required this.description,
    required this.inhale,
    required this.holdIn,
    required this.exhale,
    required this.holdOut,
  });

  static const box = BreathingPattern(
    name: 'Box',
    description: 'Equal counts. Used for focus before high-pressure work.',
    inhale: 4,
    holdIn: 4,
    exhale: 4,
    holdOut: 4,
  );

  static const relax = BreathingPattern(
    name: '4-7-8',
    description: 'Long exhale. Widely used to wind down before sleep.',
    inhale: 4,
    holdIn: 7,
    exhale: 8,
    holdOut: 0,
  );

  static const calm = BreathingPattern(
    name: 'Calm',
    description: 'Gentle and continuous. A good first pattern.',
    inhale: 4,
    holdIn: 0,
    exhale: 6,
    holdOut: 0,
  );

  static const all = [box, relax, calm];

  int secondsFor(BreathPhase phase) => switch (phase) {
    BreathPhase.inhale => inhale,
    BreathPhase.holdIn => holdIn,
    BreathPhase.exhale => exhale,
    BreathPhase.holdOut => holdOut,
  };

  /// Phases set to zero seconds are skipped entirely, so 4-7-8 never shows an
  /// empty "hold" beat at the end of a cycle.
  BreathPhase nextPhase(BreathPhase current) {
    var next = current;
    for (var i = 0; i < BreathPhase.values.length; i++) {
      next = BreathPhase.values[(next.index + 1) % BreathPhase.values.length];
      if (secondsFor(next) > 0) return next;
    }
    return current;
  }

  int get cycleSeconds => inhale + holdIn + exhale + holdOut;

  @override
  List<Object> get props => [name, description, inhale, holdIn, exhale, holdOut];
}
