import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../bloc/playground_cubit.dart';
import 'breathing_tool.dart';
import 'emi_tool.dart';
import 'playground_shared.dart';
import 'salary_tool.dart';
import 'sip_tool.dart';
import 'tally_tool.dart';

typedef _ToolSpec = ({
  PlaygroundTool tool,
  IconData icon,
  String label,
  String blurb,
});

const _tools = <_ToolSpec>[
  (
    tool: PlaygroundTool.tally,
    icon: Icons.account_balance_wallet_outlined,
    label: 'Money Tally',
    blurb: 'Log what comes in and what goes out, and see where the money '
        'actually goes.',
  ),
  (
    tool: PlaygroundTool.salary,
    icon: Icons.payments_outlined,
    label: 'In-Hand Salary',
    blurb: 'Turn a CTC offer into what actually lands in your account.',
  ),
  (
    tool: PlaygroundTool.emi,
    icon: Icons.home_work_outlined,
    label: 'EMI',
    blurb: 'Monthly instalment, total interest, and what the loan really costs.',
  ),
  (
    tool: PlaygroundTool.sip,
    icon: Icons.trending_up_rounded,
    label: 'SIP',
    blurb: 'Project what a monthly investment could grow into.',
  ),
  (
    tool: PlaygroundTool.breathe,
    icon: Icons.self_improvement_rounded,
    label: 'Breathe',
    blurb: 'A guided breathing timer. Box, 4-7-8, or a calm continuous cycle.',
  ),
];

class PlaygroundSection extends StatelessWidget {
  const PlaygroundSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaygroundCubit(),
      child: const _PlaygroundContent(),
    );
  }
}

class _PlaygroundContent extends StatelessWidget {
  const _PlaygroundContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaygroundCubit, PlaygroundTool>(
      builder: (context, selected) {
        final spec = _tools.firstWhere((t) => t.tool == selected);

        return Column(
          children: [
            const SectionHeader(
              title: 'Playground',
              subtitle:
                  'Working tools, not screenshots. Everything here runs in your '
                  'browser from the same Flutter codebase as the rest of this page.',
            ),
            const SizedBox(height: AppSizes.xl),
            FadeInUp(
              delay: const Duration(milliseconds: 150),
              child: const _ToolTabs(),
            ),
            const SizedBox(height: AppSizes.lg),
            FadeInUp(
              delay: const Duration(milliseconds: 250),
              child: GlassCard(
                padding: EdgeInsets.all(
                  context.isMobile ? AppSizes.md : AppSizes.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      spec.blurb,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: mutedOf(context),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    // Keyed so switching tools cross-fades rather than
                    // morphing one tool's widgets into the next.
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: KeyedSubtree(
                        key: ValueKey(selected),
                        child: switch (selected) {
                          PlaygroundTool.tally => const TallyTool(),
                          PlaygroundTool.salary => const SalaryTool(),
                          PlaygroundTool.emi => const EmiTool(),
                          PlaygroundTool.sip => const SipTool(),
                          PlaygroundTool.breathe => const BreathingTool(),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ToolTabs extends StatelessWidget {
  const _ToolTabs();

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<PlaygroundCubit>().state;

    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      alignment: WrapAlignment.center,
      children: [
        for (final t in _tools)
          _ToolTab(
            spec: t,
            isActive: t.tool == selected,
            onTap: () => context.read<PlaygroundCubit>().select(t.tool),
          ),
      ],
    );
  }
}

class _ToolTab extends StatelessWidget {
  final _ToolSpec spec;
  final bool isActive;
  final VoidCallback onTap;

  const _ToolTab({
    required this.spec,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isActive,
      label: spec.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm + 2,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                spec.icon,
                size: 16,
                color: isActive ? AppColors.primary : mutedOf(context),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                spec.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primary : mutedOf(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
