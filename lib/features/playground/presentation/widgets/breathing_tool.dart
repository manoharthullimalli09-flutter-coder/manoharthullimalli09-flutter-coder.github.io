import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/breathing_pattern.dart';
import '../bloc/breathing_cubit.dart';
import 'playground_shared.dart';

class BreathingTool extends StatelessWidget {
  const BreathingTool({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BreathingCubit>()..loadSessions(),
      child: const _BreathingView(),
    );
  }
}

class _BreathingView extends StatefulWidget {
  const _BreathingView();

  @override
  State<_BreathingView> createState() => _BreathingViewState();
}

/// The widget owns the [AnimationController] — the cubit owns which phase is
/// running. When a phase's animation ends the cubit is asked what comes next,
/// which keeps the timing on the ticker and the logic out of the UI.
class _BreathingViewState extends State<_BreathingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..addStatusListener(_onPhaseEnd);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onPhaseEnd);
    _controller.dispose();
    super.dispose();
  }

  void _onPhaseEnd(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    context.read<BreathingCubit>().completePhase();
  }

  void _playPhase(BreathingState state) {
    final seconds = state.phaseSeconds;
    if (seconds <= 0) return;
    _controller
      ..duration = Duration(seconds: seconds)
      ..forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BreathingCubit, BreathingState>(
      listenWhen: (a, b) =>
          a.phase != b.phase || a.isRunning != b.isRunning,
      listener: (context, state) {
        if (state.isRunning) {
          _playPhase(state);
        } else {
          _controller.stop();
          _controller.value = 0;
        }
      },
      builder: (context, state) {
        final cubit = context.read<BreathingCubit>();

        final circle = _BreathCircle(
          controller: _controller,
          phase: state.phase,
          isRunning: state.isRunning,
          label: state.isRunning ? state.phaseLabel : 'Ready',
          size: context.isMobile ? 200 : 240,
        );

        final controls = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pattern',
              style: TextStyle(fontSize: 13, color: mutedOf(context)),
            ),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: AppSizes.sm,
              runSpacing: AppSizes.sm,
              children: [
                for (final p in BreathingPattern.all)
                  ChoiceChip(
                    label: Text(p.name),
                    selected: state.pattern == p,
                    onSelected:
                        state.isRunning ? null : (_) => cubit.selectPattern(p),
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: state.pattern == p
                          ? AppColors.primary
                          : mutedOf(context),
                      fontWeight: state.pattern == p
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                    side: BorderSide(
                      color: state.pattern == p
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.sm + 2),
            Text(
              state.pattern.description,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: mutedOf(context),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Row(
              children: [
                Expanded(
                  child: ResultTile(
                    label: 'Cycle',
                    value: '${state.cyclesDone}/'
                        '${BreathingCubit.cyclesPerSession}',
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: ResultTile(
                    label: 'Sessions done',
                    value: '${state.sessionsCompleted}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            FilledButton.icon(
              onPressed: state.isRunning ? cubit.stop : cubit.start,
              icon: Icon(
                state.isRunning
                    ? Icons.stop_rounded
                    : Icons.play_arrow_rounded,
                size: 20,
              ),
              label: Text(state.isRunning ? 'Stop' : 'Start session'),
              style: FilledButton.styleFrom(
                backgroundColor:
                    state.isRunning ? AppColors.error : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
              ),
            ),
            if (state.justFinished) ...[
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      'Session complete. Nicely done.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );

        if (context.isMobile) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              circle,
              const SizedBox(height: AppSizes.xl),
              controls,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 4, child: Center(child: circle)),
            const SizedBox(width: AppSizes.xl),
            Expanded(flex: 5, child: controls),
          ],
        );
      },
    );
  }
}

// ── Animated circle ──────────────────────────────────────────────────────────

class _BreathCircle extends StatelessWidget {
  final AnimationController controller;
  final BreathPhase phase;
  final bool isRunning;
  final String label;
  final double size;

  const _BreathCircle({
    required this.controller,
    required this.phase,
    required this.isRunning,
    required this.label,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: size,
        height: size,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            // Inhale expands, exhale contracts, holds sit still at the size
            // the previous phase left behind.
            final t = controller.value;
            final scale = switch (phase) {
              BreathPhase.inhale => 0.55 + 0.45 * Curves.easeInOut.transform(t),
              BreathPhase.holdIn => 1.0,
              BreathPhase.exhale =>
                1.0 - 0.45 * Curves.easeInOut.transform(t),
              BreathPhase.holdOut => 0.55,
            };

            return CustomPaint(
              painter: _BreathPainter(
                scale: isRunning ? scale : 0.7,
                progress: isRunning ? t : 0,
                track: surfaceOf(context),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textOf(context),
                      ),
                    ),
                    if (isRunning) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${(controller.duration!.inSeconds * (1 - t)).ceil()}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w300,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BreathPainter extends CustomPainter {
  final double scale;
  final double progress;
  final Color track;

  const _BreathPainter({
    required this.scale,
    required this.progress,
    required this.track,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    canvas.drawCircle(
      center,
      maxRadius - 2,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = track,
    );

    final r = maxRadius * scale;

    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ).createShader(Rect.fromCircle(center: center, radius: r))
        ..color = AppColors.primary.withValues(alpha: 0.85),
    );

    // Progress arc around the rim, so the countdown is visible peripherally.
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: maxRadius - 2),
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = AppColors.secondary,
      );
    }
  }

  @override
  bool shouldRepaint(_BreathPainter old) =>
      old.scale != scale || old.progress != progress || old.track != track;
}
