import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/tally_bloc.dart';
import 'playground_shared.dart';
import 'tool_layout.dart';

const _categories = [
  'Food',
  'Travel',
  'Rent',
  'Bills',
  'Shopping',
  'Health',
  'Other',
];

const _categoryColors = <String, Color>{
  'Food': Color(0xFFFF8A65),
  'Travel': AppColors.secondary,
  'Rent': AppColors.primary,
  'Bills': Color(0xFFFFB300),
  'Shopping': Color(0xFFF06292),
  'Health': AppColors.success,
  'Other': Color(0xFF90A4AE),
};

class TallyTool extends StatelessWidget {
  const TallyTool({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TallyBloc>()..add(const LoadTransactions()),
      child: const _TallyView(),
    );
  }
}

class _TallyView extends StatelessWidget {
  const _TallyView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TallyBloc, TallyState>(
      builder: (context, state) {
        final s = state.summary;

        final slices = s.spendByCategory.entries
            .map(
              (e) => DonutSlice(
                value: e.value,
                color: _categoryColors[e.key] ?? AppColors.primary,
                label: e.key,
              ),
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ToolLayout(
              controls: [
                const _EntryForm(),
                const SizedBox(height: AppSizes.md),
                _TransactionList(transactions: state.transactions),
              ],
              results: [
                ResultTile(
                  label: 'Balance',
                  value: formatInr(s.balance),
                  color: s.balance == 0
                      ? AppColors.primary
                      : (s.balance > 0 ? AppColors.success : AppColors.error),
                  emphasise: true,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ResultTile(
                        label: 'Income',
                        value: formatCompactInr(s.totalIncome),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: ResultTile(
                        label: 'Spent',
                        value: formatCompactInr(s.totalExpense),
                      ),
                    ),
                  ],
                ),
                if (state.transactions.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _confirmClear(context),
                      icon: const Icon(Icons.delete_sweep_outlined, size: 16),
                      label: const Text('Clear all'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
              ],
              chart: slices.isEmpty
                  ? null
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DonutChart(
                          slices: slices,
                          centerLabel: 'Spent',
                          centerValue: formatCompactInr(s.totalExpense),
                          size: context.isMobile ? 150 : 175,
                        ),
                        const SizedBox(height: AppSizes.md),
                        DonutLegend(slices: slices),
                      ],
                    ),
            ),
            const SizedBox(height: AppSizes.lg),
            const ToolNote(
              text: 'Everything you enter stays in this browser only — it is '
                  'saved to local storage on your device and never sent '
                  'anywhere. Clearing your browser data clears it too.',
            ),
          ],
        );
      },
    );
  }
}

// ── Entry form ───────────────────────────────────────────────────────────────

class _EntryForm extends StatefulWidget {
  const _EntryForm();

  @override
  State<_EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<_EntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  String _category = 'Food';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final txn = TransactionEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      type: _type,
      category: _type == TransactionType.income ? 'Income' : _category,
      date: DateTime.now(),
    );

    context.read<TallyBloc>().add(AddTransaction(txn));
    _titleController.clear();
    _amountController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TypeToggle(
            value: _type,
            onChanged: (t) => setState(() => _type = t),
          ),
          const SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'What was it for?',
              isDense: true,
            ),
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Add a short label' : null,
          ),
          const SizedBox(height: AppSizes.sm),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '₹ ',
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onFieldSubmitted: (_) => _submit(),
            validator: (v) {
              final parsed = double.tryParse(v?.trim() ?? '');
              if (parsed == null) return 'Enter a number';
              if (parsed <= 0) return 'Must be above zero';
              return null;
            },
          ),
          if (_type == TransactionType.expense) ...[
            const SizedBox(height: AppSizes.md),
            Wrap(
              spacing: AppSizes.xs + 2,
              runSpacing: AppSizes.xs + 2,
              children: [
                for (final c in _categories)
                  ChoiceChip(
                    label: Text(c),
                    selected: _category == c,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _category = c),
                    labelStyle: TextStyle(
                      fontSize: 11,
                      color: _category == c
                          ? _categoryColors[c]
                          : mutedOf(context),
                      fontWeight:
                          _category == c ? FontWeight.w700 : FontWeight.w400,
                    ),
                    selectedColor:
                        (_categoryColors[c] ?? AppColors.primary)
                            .withValues(alpha: 0.15),
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: _category == c
                          ? (_categoryColors[c] ?? AppColors.primary)
                              .withValues(alpha: 0.5)
                          : AppColors.border,
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSizes.md),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add entry'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
            ),
          ),
        ],
      ),
    );
  }
}

// ── List ─────────────────────────────────────────────────────────────────────

class _TransactionList extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: surfaceOf(context),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 17,
              color: mutedOf(context),
            ),
            const SizedBox(width: AppSizes.sm + 2),
            Expanded(
              child: Text(
                'No entries yet. Add your first one above and the '
                'breakdown appears here.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: mutedOf(context),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Capped and scrollable: the tool sits inside a page-level scroll view,
    // so an unbounded list here would grow the section without limit.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 260),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSizes.xs + 2),
        itemBuilder: (context, i) => _TransactionRow(txn: transactions[i]),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final TransactionEntity txn;

  const _TransactionRow({required this.txn});

  @override
  Widget build(BuildContext context) {
    final isIncome = txn.type == TransactionType.income;
    final accent = isIncome
        ? AppColors.success
        : (_categoryColors[txn.category] ?? AppColors.primary);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm + 2,
        vertical: AppSizes.sm,
      ),
      decoration: BoxDecoration(
        color: surfaceOf(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 30,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSizes.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  txn.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textOf(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  txn.category,
                  style: TextStyle(fontSize: 11, color: mutedOf(context)),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          Text(
            '${isIncome ? '+' : '−'}${formatInr(txn.amount)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isIncome ? AppColors.success : textOf(context),
            ),
          ),
          IconButton(
            onPressed: () =>
                context.read<TallyBloc>().add(DeleteTransaction(txn.id)),
            icon: const Icon(Icons.close_rounded, size: 15),
            color: mutedOf(context),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}

// ── Type toggle ──────────────────────────────────────────────────────────────

/// Expense/Income switch, drawn rather than themed.
///
/// A stock [SegmentedButton] paints its selected segment from
/// `colorScheme.secondaryContainer`, which Material derives from the cyan
/// secondary — a bright block that reads as an error against this palette.
/// Drawing it here also lets the colour carry meaning: red for money out,
/// green for money in.
class _TypeToggle extends StatelessWidget {
  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;

  const _TypeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: surfaceOf(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm + 2),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleHalf(
              key: const Key('tally-type-expense'),
              label: 'Expense',
              // A minus is unambiguous; an up arrow reads as "gain" to most
              // people even when it means "money leaving".
              icon: Icons.remove_rounded,
              accent: AppColors.error,
              isSelected: value == TransactionType.expense,
              onTap: () => onChanged(TransactionType.expense),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _ToggleHalf(
              key: const Key('tally-type-income'),
              label: 'Income',
              icon: Icons.add_rounded,
              accent: AppColors.success,
              isSelected: value == TransactionType.income,
              onTap: () => onChanged(TransactionType.income),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleHalf extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleHalf({
    super.key,
    required this.label,
    required this.icon,
    required this.accent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.sm + 2),
          decoration: BoxDecoration(
            color: isSelected
                ? accent.withValues(alpha: 0.16)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            border: Border.all(
              color: isSelected
                  ? accent.withValues(alpha: 0.55)
                  : Colors.transparent,
            ),
          ),
          // The halves are Expanded, so the label must be allowed to shrink;
          // at 390px the icon plus full word otherwise overruns its half.
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? accent : mutedOf(context),
              ),
              const SizedBox(width: AppSizes.xs + 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? accent : mutedOf(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _confirmClear(BuildContext context) async {
  final bloc = context.read<TallyBloc>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Clear all entries?'),
      content: const Text(
        'This removes every entry from this browser. It cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('Clear all'),
        ),
      ],
    ),
  );

  if (confirmed ?? false) bloc.add(const ClearTransactions());
}
