import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../injection_container.dart';
import '../bloc/salary_cubit.dart';
import 'playground_shared.dart';
import 'tool_layout.dart';

class SalaryTool extends StatelessWidget {
  const SalaryTool({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalaryCubit>(),
      child: BlocBuilder<SalaryCubit, SalaryState>(
        builder: (context, state) {
          final cubit = context.read<SalaryCubit>();
          final r = state.result;

          final slices = r == null
              ? const <DonutSlice>[]
              : [
                  DonutSlice(
                    value: r.annualInHand,
                    color: AppColors.success,
                    label: 'In hand',
                  ),
                  DonutSlice(
                    value: r.incomeTax,
                    color: AppColors.error,
                    label: 'Income tax',
                  ),
                  DonutSlice(
                    value: r.employeePf + r.professionalTax,
                    color: AppColors.secondary,
                    label: 'PF + PT',
                  ),
                  DonutSlice(
                    value: r.employerPf + r.gratuity,
                    color: AppColors.textMuted,
                    label: 'Employer share',
                  ),
                ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ToolLayout(
                controls: [
                  LabeledSlider(
                    label: 'Annual CTC',
                    valueLabel: formatCompactInr(state.ctc),
                    value: state.ctc,
                    min: 200000,
                    max: 10000000,
                    divisions: 196,
                    onChanged: cubit.setCtc,
                  ),
                  LabeledSlider(
                    label: 'Basic pay (% of CTC)',
                    valueLabel:
                        '${(state.basicPercent * 100).toStringAsFixed(0)}%',
                    value: state.basicPercent,
                    min: 0.20,
                    max: 0.60,
                    divisions: 40,
                    onChanged: cubit.setBasicPercent,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: AppSizes.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Metro city (HRA at 50% of basic)',
                            style: TextStyle(
                              fontSize: 13,
                              color: mutedOf(context),
                            ),
                          ),
                        ),
                        Switch(
                          value: state.isMetro,
                          activeColor: AppColors.primary,
                          onChanged: cubit.setMetro,
                        ),
                      ],
                    ),
                  ),
                ],
                error: state.error,
                results: r == null
                    ? const []
                    : [
                        ResultTile(
                          label: 'Monthly in-hand (approx.)',
                          value: formatInr(r.monthlyInHand),
                          color: AppColors.success,
                          emphasise: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ResultTile(
                                label: 'Annual in-hand',
                                value: formatCompactInr(r.annualInHand),
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: ResultTile(
                                label: 'Income tax / yr',
                                value: formatCompactInr(r.incomeTax),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ResultTile(
                                label: 'Basic',
                                value: formatCompactInr(r.basic),
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: ResultTile(
                                label: 'HRA',
                                value: formatCompactInr(r.hra),
                              ),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: ResultTile(
                                label: 'Your PF',
                                value: formatCompactInr(r.employeePf),
                              ),
                            ),
                          ],
                        ),
                      ],
                chart: r == null
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DonutChart(
                            slices: slices,
                            centerLabel: 'Per month',
                            centerValue: formatCompactInr(r.monthlyInHand),
                            size: context.isMobile ? 150 : 175,
                          ),
                          const SizedBox(height: AppSizes.md),
                          DonutLegend(slices: slices),
                        ],
                      ),
              ),
              const SizedBox(height: AppSizes.lg),
              const ToolNote(
                text: 'Estimate using the New Tax Regime (FY 2025-26): '
                    '₹75,000 standard deduction, full rebate up to ₹12L taxable '
                    'income, 4% cess, and ₹200/month professional tax. Your '
                    'actual take-home depends on your employer\'s exact CTC '
                    'structure and your state\'s professional tax.',
              ),
            ],
          );
        },
      ),
    );
  }
}
