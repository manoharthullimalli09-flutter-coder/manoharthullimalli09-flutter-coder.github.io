import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../injection_container.dart';
import '../bloc/sip_cubit.dart';
import 'playground_shared.dart';
import 'tool_layout.dart';

class SipTool extends StatelessWidget {
  const SipTool({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SipCubit>(),
      child: BlocBuilder<SipCubit, SipState>(
        builder: (context, state) {
          final cubit = context.read<SipCubit>();
          final r = state.result;

          final slices = r == null
              ? const <DonutSlice>[]
              : [
                  DonutSlice(
                    value: r.investedAmount,
                    color: AppColors.primary,
                    label: 'Invested',
                  ),
                  DonutSlice(
                    value: r.estimatedReturns,
                    color: AppColors.success,
                    label: 'Returns',
                  ),
                ];

          return ToolLayout(
            controls: [
              LabeledSlider(
                label: 'Monthly investment',
                valueLabel: formatCompactInr(state.monthly),
                value: state.monthly,
                min: 500,
                max: 200000,
                divisions: 199,
                onChanged: cubit.setMonthly,
              ),
              LabeledSlider(
                label: 'Expected return (p.a.)',
                valueLabel: '${state.returnRate.toStringAsFixed(1)}%',
                value: state.returnRate,
                min: 1,
                max: 30,
                divisions: 58,
                onChanged: cubit.setReturnRate,
              ),
              LabeledSlider(
                label: 'Time period',
                valueLabel: '${state.years} yr',
                value: state.years.toDouble(),
                min: 1,
                max: 40,
                divisions: 39,
                onChanged: (v) => cubit.setYears(v.round()),
              ),
            ],
            error: state.error,
            results: r == null
                ? const []
                : [
                    ResultTile(
                      label: 'Estimated value',
                      value: formatInr(r.totalValue),
                      color: AppColors.success,
                      emphasise: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ResultTile(
                            label: 'You invest',
                            value: formatCompactInr(r.investedAmount),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: ResultTile(
                            label: 'Est. returns',
                            value: formatCompactInr(r.estimatedReturns),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Returns make up '
                      '${(r.returnsShare * 100).toStringAsFixed(0)}% of the '
                      'final corpus. Projections only — markets are not linear.',
                      style: TextStyle(fontSize: 12, color: mutedOf(context)),
                    ),
                  ],
            chart: r == null
                ? null
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DonutChart(
                        slices: slices,
                        centerLabel: 'Corpus',
                        centerValue: formatCompactInr(r.totalValue),
                        size: context.isMobile ? 150 : 175,
                      ),
                      const SizedBox(height: AppSizes.md),
                      DonutLegend(slices: slices),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
