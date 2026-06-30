import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/animated_counter.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/developer_entity.dart';
import '../bloc/hero_bloc.dart';
import 'animated_tagline.dart';
import 'hero_avatar.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onViewWork;
  final VoidCallback? onHireMe;

  const HeroSection({super.key, this.onViewWork, this.onHireMe});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HeroBloc>()..add(LoadDeveloperInfo()),
      child: _HeroContent(onViewWork: onViewWork, onHireMe: onHireMe),
    );
  }
}

class _HeroContent extends StatelessWidget {
  final VoidCallback? onViewWork;
  final VoidCallback? onHireMe;

  const _HeroContent({this.onViewWork, this.onHireMe});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeroBloc, HeroState>(
      builder: (context, state) {
        if (state is HeroLoaded) {
          return context.isDesktop
              ? _HeroDesktop(
                  state: state,
                  onViewWork: onViewWork,
                  onHireMe: onHireMe,
                )
              : _HeroMobile(
                  state: state,
                  onViewWork: onViewWork,
                  onHireMe: onHireMe,
                );
        }
        if (state is HeroError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      },
    );
  }
}

class _HeroDesktop extends StatelessWidget {
  final HeroLoaded state;
  final VoidCallback? onViewWork;
  final VoidCallback? onHireMe;

  const _HeroDesktop({required this.state, this.onViewWork, this.onHireMe});

  @override
  Widget build(BuildContext context) {
    final dev = state.developer;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AvailableBadge(),
              const SizedBox(height: AppSizes.lg),
              FadeInLeft(
                duration: const Duration(milliseconds: 700),
                child: Text(
                  'Hi, I\'m ${dev.name.split(' ').first}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              FadeInLeft(
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 700),
                child: GradientText(
                  dev.title,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 700),
                child: AnimatedTagline(
                  phrases: const [
                    'Flutter · Android · iOS · Web · Desktop',
                    'BLoC · Clean Architecture · SOLID',
                    'Firebase · REST APIs · CI/CD',
                    '5+ Years · 20+ Projects · 4 Platforms',
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              FadeInLeft(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 700),
                child: Text(
                  dev.bio,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: _CTAButtons(onViewWork: onViewWork, onHireMe: onHireMe),
              ),
              const SizedBox(height: AppSizes.xxl),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: _StatRow(developer: dev),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.xxl),
        Expanded(
          flex: 4,
          child: FadeInRight(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 800),
            child: const HeroAvatar(),
          ),
        ),
      ],
    );
  }
}

class _HeroMobile extends StatelessWidget {
  final HeroLoaded state;
  final VoidCallback? onViewWork;
  final VoidCallback? onHireMe;

  const _HeroMobile({required this.state, this.onViewWork, this.onHireMe});

  @override
  Widget build(BuildContext context) {
    final dev = state.developer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSizes.xl),
        FadeInDown(child: const HeroAvatar()),
        const SizedBox(height: AppSizes.xl),
        _AvailableBadge(),
        const SizedBox(height: AppSizes.md),
        FadeInUp(
          child: Text(
            'Hi, I\'m ${dev.name.split(' ').first}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        FadeInUp(
          delay: const Duration(milliseconds: 100),
          child: GradientText(
            dev.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        const SizedBox(height: AppSizes.md),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: AnimatedTagline(
            phrases: const [
              'Flutter · All 4 Platforms',
              'BLoC · Clean Architecture',
              '5+ Years · 20+ Projects',
            ],
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSizes.xl),
        FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: _CTAButtons(onViewWork: onViewWork, onHireMe: onHireMe),
        ),
        const SizedBox(height: AppSizes.xl),
        FadeInUp(
          delay: const Duration(milliseconds: 400),
          child: _StatRow(developer: dev),
        ),
      ],
    );
  }
}

class _AvailableBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              'Available for new opportunities',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}

class _CTAButtons extends StatelessWidget {
  final VoidCallback? onViewWork;
  final VoidCallback? onHireMe;

  const _CTAButtons({this.onViewWork, this.onHireMe});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.md,
      children: [
        ElevatedButton.icon(
          onPressed: onViewWork,
          icon: const Icon(Icons.work_outline_rounded, size: 18),
          label: const Text('View My Work'),
        ),
        OutlinedButton.icon(
          onPressed: onHireMe,
          icon: const Icon(Icons.mail_outline_rounded, size: 18),
          label: const Text('Hire Me'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.xl,
              vertical: AppSizes.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final DeveloperEntity developer;
  const _StatRow({required this.developer});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.xl,
      runSpacing: AppSizes.lg,
      alignment: WrapAlignment.start,
      children: [
        _StatItem(
          value: developer.yearsOfExperience,
          suffix: '+',
          label: 'Years Experience',
        ),
        _StatItem(
          value: developer.projectsCompleted,
          suffix: '+',
          label: 'Projects Shipped',
        ),
        _StatItem(
          value: developer.platformsSupported,
          suffix: '',
          label: 'Platforms',
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String suffix;
  final String label;
  const _StatItem({
    required this.value,
    required this.suffix,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCounter(
          end: value,
          suffix: suffix,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
