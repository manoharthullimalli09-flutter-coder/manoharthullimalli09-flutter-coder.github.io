import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import 'playground_shared.dart';

/// Shared two-pane frame for the calculator tools: inputs on one side,
/// chart and results on the other, stacking to a single column on mobile.
class ToolLayout extends StatelessWidget {
  final List<Widget> controls;
  final List<Widget> results;
  final Widget? chart;
  final String? error;

  const ToolLayout({
    super.key,
    required this.controls,
    required this.results,
    this.chart,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in controls) ...[c, const SizedBox(height: AppSizes.xs)],
        if (error != null) ...[
          const SizedBox(height: AppSizes.sm),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: AppColors.error),
              const SizedBox(width: AppSizes.xs + 2),
              Expanded(
                child: Text(
                  error!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );

    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (chart != null) ...[
          Center(child: chart!),
          const SizedBox(height: AppSizes.lg),
        ],
        for (final r in results) ...[r, const SizedBox(height: AppSizes.sm)],
      ],
    );

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [left, const SizedBox(height: AppSizes.lg), right],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: left),
        const SizedBox(width: AppSizes.xl),
        Expanded(flex: 4, child: right),
      ],
    );
  }
}

/// A short, plain-language caveat shown under a tool that makes assumptions
/// a visitor cannot see — a tax regime, a CTC split, an expected return.
class ToolNote extends StatelessWidget {
  final String text;

  const ToolNote({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 15,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.5,
                color: mutedOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
