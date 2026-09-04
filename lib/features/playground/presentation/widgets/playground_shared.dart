import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

final _inr = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

String formatInr(double v) => _inr.format(v.round());

/// Indian short scale — a ₹25,00,000 loan reads as ₹25.0L, not ₹2.5M.
String formatCompactInr(double v) {
  final a = v.abs();
  if (a >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
  if (a >= 100000) return '₹${(v / 100000).toStringAsFixed(2)} L';
  if (a >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
  return '₹${v.round()}';
}

Color surfaceOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.surfaceVariant
        : const Color(0xFFF4F5FA);

Color textOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.textPrimary
        : const Color(0xFF14142B);

Color mutedOf(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? AppColors.textSecondary
        : const Color(0xFF6A6A85);

// ── Inputs ───────────────────────────────────────────────────────────────────

class LabeledSlider extends StatelessWidget {
  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  const LabeledSlider({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(fontSize: 13, color: mutedOf(context)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              valueLabel,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.primary.withValues(alpha: 0.18),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ── Results ──────────────────────────────────────────────────────────────────

class ResultTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool emphasise;

  const ResultTile({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.emphasise = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm + 2,
      ),
      decoration: BoxDecoration(
        color: emphasise
            ? (color ?? AppColors.primary).withValues(alpha: 0.12)
            : surfaceOf(context),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: emphasise
            ? Border.all(
                color: (color ?? AppColors.primary).withValues(alpha: 0.35),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: mutedOf(context)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: emphasise ? 20 : 15,
                fontWeight: FontWeight.w700,
                color: emphasise ? (color ?? AppColors.primary) : textOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Donut ────────────────────────────────────────────────────────────────────

class DonutSlice {
  final double value;
  final Color color;
  final String label;

  const DonutSlice({
    required this.value,
    required this.color,
    required this.label,
  });
}

/// Animated ring chart. Redrawn via [AnimatedBuilder] on a controller rather
/// than by rebuilding the tree, and isolated behind a [RepaintBoundary].
class DonutChart extends StatefulWidget {
  final List<DonutSlice> slices;
  final String centerLabel;
  final String centerValue;
  final double size;

  const DonutChart({
    super.key,
    required this.slices,
    required this.centerLabel,
    required this.centerValue,
    this.size = 170,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-sweep whenever the split actually changes, so dragging a slider
    // animates the ring instead of snapping it.
    final before = oldWidget.slices.map((s) => s.value).toList();
    final after = widget.slices.map((s) => s.value).toList();
    if (before.length != after.length ||
        !List.generate(after.length, (i) => before[i] == after[i]).every((e) => e)) {
      _controller.forward(from: 0.75);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _DonutPainter(
              slices: widget.slices,
              progress: Curves.easeOutCubic.transform(_controller.value),
              trackColor: surfaceOf(context),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.centerLabel,
                    style: TextStyle(fontSize: 11, color: mutedOf(context)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.centerValue,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: textOf(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSlice> slices;
  final double progress;
  final Color trackColor;

  const _DonutPainter({
    required this.slices,
    required this.progress,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.13;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width - stroke) / 2,
    );

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = trackColor,
    );

    final total = slices.fold<double>(0, (sum, s) => sum + s.value);
    if (total <= 0) return;

    var start = -math.pi / 2;
    for (final slice in slices) {
      final sweep = (slice.value / total) * math.pi * 2 * progress;
      if (sweep <= 0) continue;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt
          ..color = slice.color,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress ||
      old.trackColor != trackColor ||
      old.slices.length != slices.length ||
      List.generate(slices.length, (i) => old.slices[i].value != slices[i].value)
          .any((changed) => changed);
}

class DonutLegend extends StatelessWidget {
  final List<DonutSlice> slices;

  const DonutLegend({super.key, required this.slices});

  @override
  Widget build(BuildContext context) {
    // A Wrap sizes each child to its natural width, so a long label inside an
    // unbounded Row overflows rather than wrapping. Capping each entry at the
    // legend's own width lets the label ellipsize instead.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: AppSizes.md,
          runSpacing: AppSizes.xs,
          children: [
            for (final s in slices)
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: AppSizes.xs + 2),
                    Flexible(
                      child: Text(
                        s.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: mutedOf(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
