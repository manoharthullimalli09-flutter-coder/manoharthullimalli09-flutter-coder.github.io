import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HeroAvatar extends StatelessWidget {
  const HeroAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.secondary.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Border ring
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
          // Photo circle — zoomed in slightly so the image bleeds past the
          // border ring edges, with crop shifted up to keep the head centred.
          Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.hardEdge,
            child: Transform.scale(
              scale: 1.15,
              child: Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.4),
                errorBuilder: (_, __, ___) => const _PlaceholderAvatar(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: const Icon(Icons.person_rounded, size: 120, color: Colors.white70),
    );
  }
}
