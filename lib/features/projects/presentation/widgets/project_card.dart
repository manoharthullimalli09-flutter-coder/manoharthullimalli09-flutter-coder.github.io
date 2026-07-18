import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/project_entity.dart';

/// Stateless — hover state is owned by [_HoverableRow] and passed in.
class ProjectCard extends StatelessWidget {
  final ProjectEntity project;
  final bool isHovered;
  final bool anyHovered;

  const ProjectCard({
    super.key,
    required this.project,
    this.isHovered = false,
    this.anyHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Image section height drives the Infosys "grow/shrink" effect
    final imageH = isHovered ? 280.0 : (anyHovered ? 180.0 : 225.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: isHovered ? Curves.easeOutCubic : Curves.easeInCubic,
      transform: Matrix4.translationValues(0, isHovered ? -20 : 0, 0),
      transformAlignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isHovered ? AppColors.primary : Colors.black)
                .withValues(alpha: isHovered ? 0.35 : 0.12),
            blurRadius: isHovered ? 56 : 16,
            offset: Offset(0, isHovered ? 32 : 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Image header — height animates on hover ─────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: isHovered ? Curves.easeOutCubic : Curves.easeInCubic,
              height: imageH,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  p.imageUrl.isNotEmpty
                      ? Image.asset(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _CategoryGradient(category: p.category),
                        )
                      : _CategoryGradient(category: p.category),
                  if (p.isFeatured)
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Featured',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Content section — always fixed below image ────────────────
            Container(
              color: isDark ? const Color(0xFF13132B) : Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimary
                          : const Color(0xFF0D0D2B),
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 62, // locks to exactly 3 lines — no reflow on hover
                    child: Text(
                      p.description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.55,
                        color: isDark
                            ? AppColors.textSecondary
                            : const Color(0xFF55556B),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...p.platforms.take(2).map(
                            (pl) => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: _PlatformBadge(platform: pl),
                            ),
                          ),
                      const Spacer(),
                      if (p.playStoreUrl?.isNotEmpty ?? false)
                        _ArrowLink(
                          label: 'Play Store',
                          url: p.playStoreUrl!,
                          color: const Color(0xFF34C759),
                        )
                      else if (p.webUrl?.isNotEmpty ?? false)
                        _ArrowLink(
                          label: 'Live Demo',
                          url: p.webUrl!,
                          color: AppColors.secondary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _CategoryGradient extends StatelessWidget {
  final String category;
  const _CategoryGradient({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = switch (category.toLowerCase()) {
      'social' => [const Color(0xFFAD1457), const Color(0xFFF06292)],
      'e-commerce' => [const Color(0xFF4527A0), const Color(0xFF9575CD)],
      'healthcare' => [const Color(0xFF00695C), const Color(0xFF4DB6AC)],
      'enterprise' => [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
      'fintech' => [const Color(0xFF0D47A1), const Color(0xFF64B5F6)],
      'logistics' => [const Color(0xFFBF360C), const Color(0xFFFF8A65)],
      _ => [const Color(0xFF263238), const Color(0xFF546E7A)],
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  final String platform;
  const _PlatformBadge({required this.platform});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (color, label) = switch (platform) {
      'android' => (const Color(0xFF4CAF50), 'Android'),
      'ios' => (isDark ? const Color(0xFFBBBBBB) : const Color(0xFF777777), 'iOS'),
      'web' => (AppColors.secondary, 'Web'),
      'desktop' => (const Color(0xFF9C27B0), 'Desktop'),
      _ => (AppColors.primary, platform),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _ArrowLink extends StatelessWidget {
  final String label;
  final String url;
  final Color color;
  const _ArrowLink(
      {required this.label, required this.url, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: color.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.arrow_outward_rounded, size: 13, color: color),
        ],
      ),
    );
  }
}
