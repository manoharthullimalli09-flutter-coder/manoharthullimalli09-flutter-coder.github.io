import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../injection_container.dart';
import '../bloc/emi_cubit.dart';
import 'playground_shared.dart';
import 'tool_layout.dart';

class EmiTool extends StatelessWidget {
  const EmiTool({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmiCubit>(),
      child: BlocBuilder<EmiCubit, EmiState>(
        builder: (context, state) {
          final cubit = context.read<EmiCubit>();
          final r = state.result;

          final slices = r == null
              ? const <DonutSlice>[]
              : [
                  DonutSlice(
                    value: r.principal,
                    color: AppColors.primary,
                    label: 'Principal',
                  ),
                  DonutSlice(
                    value: r.totalInterest,
                    color: AppColors.secondary,
                    label: 'Interest',
                  ),
                ];

          return ToolLayout(
            controls: [
              LabeledSlider(
                label: 'Loan amount',
                valueLabel: formatCompactInr(state.principal),
                value: state.principal,
                min: 100000,
                max: 20000000,
                divisions: 199,
                onChanged: cubit.setPrincipal,
              ),
              LabeledSlider(
                label: 'Interest rate (p.a.)',
                valueLabel: '${state.rate.toStringAsFixed(2)}%',
                value: state.rate,
                min: 0,
                max: 20,
                divisions: 200,
                onChanged: cubit.setRate,
              ),
              LabeledSlider(
                label: 'Tenure',
                valueLabel: '${state.years} yr',
                value: state.months.toDouble(),
                min: 12,
                max: 360,
                divisions: 29,
                onChanged: (v) => cubit.setMonths(v.round()),
              ),
            ],
            error: state.error,
            results: r == null
                ? const []
                : [
                    ResultTile(
                      label: 'Monthly EMI',
                      value: formatInr(r.monthlyEmi),
                      emphasise: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ResultTile(
                            label: 'Total interest',
                            value: formatCompactInr(r.totalInterest),
                          ),
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: ResultTile(
                            label: 'Total payable',
                            value: formatCompactInr(r.totalPayable),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Interest is ${(r.interestShare * 100).toStringAsFixed(0)}% '
                      'of everything you repay.',
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
                        centerLabel: 'Monthly',
                        centerValue: formatCompactInr(r.monthlyEmi),
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
