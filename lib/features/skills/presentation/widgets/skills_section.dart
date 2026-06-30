import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/skill_entity.dart';
import '../bloc/skills_cubit.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SkillsCubit>()..loadSkills(),
      child: const _SkillsContent(),
    );
  }
}

class _SkillsContent extends StatelessWidget {
  const _SkillsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkillsCubit, SkillsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SectionHeader(
              title: 'Skills & Tech',
              subtitle:
                  'Technologies I use to build production-grade Flutter apps across all platforms.',
            ),
            const SizedBox(height: AppSizes.xxl),
            if (state is SkillsLoading)
              const CircularProgressIndicator(color: AppColors.primary)
            else if (state is SkillsError)
              Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              )
            else if (state is SkillsLoaded)
              _SkillsGrid(categories: state.categories),
          ],
        );
      },
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  final List<SkillCategoryEntity> categories;
  const _SkillsGrid({required this.categories});

  @override
  Widget build(BuildContext context) {
    final cols = context.isDesktop ? 3 : (context.isTablet ? 2 : 1);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: AppSizes.lg,
        mainAxisSpacing: AppSizes.lg,
        childAspectRatio: context.isDesktop ? 1.1 : 1.2,
      ),
      itemCount: categories.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: 120 * i),
        child: _SkillCategoryCard(category: categories[i]),
      ),
    );
  }
}

class _SkillCategoryCard extends StatelessWidget {
  final SkillCategoryEntity category;
  const _SkillCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppSizes.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSizes.md),
          Expanded(
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: category.skills
                  .map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: _AnimatedSkillBar(skill: s),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSkillBar extends StatefulWidget {
  final SkillEntity skill;
  const _AnimatedSkillBar({required this.skill});

  @override
  State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<_AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.skill.name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => Text(
                '${(_animation.value * widget.skill.proficiency * 100).round()}%',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (_, __) => LinearProgressIndicator(
              value: _animation.value * widget.skill.proficiency,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(
                  AppColors.primary,
                  AppColors.secondary,
                  widget.skill.proficiency,
                )!,
              ),
              minHeight: 6,
            ),
          ),
        ),
      ],
    );
  }
}
