import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Platform indicator. [onImage] switches to a translucent dark treatment for
/// use as an overlay on a screenshot, where an outlined chip would disappear
/// against arbitrary artwork.
class PlatformBadge extends StatelessWidget {
  final String platform;
  final bool onImage;

  const PlatformBadge({
    super.key,
    required this.platform,
    this.onImage = false,
  });

  static (Color, String) _style(String platform, bool isDark) =>
      switch (platform) {
        'android' => (const Color(0xFF4CAF50), 'Android'),
        'ios' => (
            isDark ? const Color(0xFFBBBBBB) : const Color(0xFF777777),
            'iOS'
          ),
        'web' => (AppColors.secondary, 'Web'),
        'desktop' => (const Color(0xFF9C27B0), 'Desktop'),
        _ => (AppColors.primary, platform),
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (color, label) = _style(platform, isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: onImage
            ? Colors.black.withValues(alpha: 0.55)
            : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: onImage
              ? Colors.white.withValues(alpha: 0.25)
              : color.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: onImage ? Colors.white : color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

/// A single technology in a project's stack — the keywords a reviewer scans
/// a portfolio for, so they are rendered rather than left in the data file.
class TechChip extends StatelessWidget {
  final String label;

  /// Renders the muted "+N more" affordance instead of a named technology.
  final bool isOverflow;

  const TechChip({super.key, required this.label, this.isOverflow = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isOverflow
        ? (isDark ? AppColors.textMuted : const Color(0xFF8A8AA3))
        : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.14 : 0.09),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isDark ? color : Color.lerp(color, Colors.black, 0.25),
          fontSize: 10,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }
}

/// Stands in for a project screenshot. Carries a category gradient and a
/// watermark glyph so a project without artwork still reads as designed
/// rather than broken.
class CategoryArtwork extends StatelessWidget {
  final String category;

  const CategoryArtwork({super.key, required this.category});

  static (List<Color>, IconData) _style(String category) =>
      switch (category.toLowerCase()) {
        'social' => (
            [const Color(0xFFAD1457), const Color(0xFFF06292)],
            Icons.forum_rounded
          ),
        'e-commerce' => (
            [const Color(0xFF4527A0), const Color(0xFF9575CD)],
            Icons.shopping_bag_rounded
          ),
        'healthcare' => (
            [const Color(0xFF00695C), const Color(0xFF4DB6AC)],
            Icons.favorite_rounded
          ),
        'enterprise' => (
            [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
            Icons.dashboard_rounded
          ),
        'fintech' => (
            [const Color(0xFF0D47A1), const Color(0xFF64B5F6)],
            Icons.account_balance_wallet_rounded
          ),
        'logistics' => (
            [const Color(0xFFBF360C), const Color(0xFFFF8A65)],
            Icons.local_shipping_rounded
          ),
        _ => (
            [const Color(0xFF263238), const Color(0xFF546E7A)],
            Icons.apps_rounded
          ),
      };

  @override
  Widget build(BuildContext context) {
    final (colors, icon) = _style(category);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: Icon(
            icon,
            size: constraints.maxHeight * 0.34,
            color: Colors.white.withValues(alpha: 0.22),
          ),
        ),
      ),
    );
  }
}
