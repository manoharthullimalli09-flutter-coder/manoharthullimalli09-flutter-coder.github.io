import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ParticlesBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;

  const ParticlesBackground({
    super.key,
    required this.child,
    this.particleCount = 40,
  });

  @override
  State<ParticlesBackground> createState() => _ParticlesBackgroundState();
}

class _ParticlesBackgroundState extends State<ParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _particles = List.generate(
      widget.particleCount,
      (_) => _Particle.random(_rng),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => CustomPaint(
                painter: _ParticlesPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double angle;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.opacity,
  });

  factory _Particle.random(math.Random rng) => _Particle(
    x: rng.nextDouble(),
    y: rng.nextDouble(),
    radius: rng.nextDouble() * 2 + 1,
    speed: rng.nextDouble() * 0.03 + 0.005,
    angle: rng.nextDouble() * math.pi * 2,
    opacity: rng.nextDouble() * 0.4 + 0.1,
  );
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dx =
          (p.x + math.cos(p.angle + progress * math.pi * 2) * p.speed) % 1.0;
      final dy =
          (p.y + math.sin(p.angle + progress * math.pi * 2) * p.speed) % 1.0;

      final paint = Paint()
        ..color = (dx > 0.5 ? AppColors.primary : AppColors.secondary)
            .withValues(alpha: p.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(dx * size.width, dy * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter old) => old.progress != progress;
}
