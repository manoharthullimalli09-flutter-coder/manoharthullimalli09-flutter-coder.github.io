import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/project_entity.dart';

class ProjectCard extends StatefulWidget {
  final ProjectEntity project;
  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: _hovered ? Curves.easeOutBack : Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -14 : 0, 0),
        transformAlignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (_hovered ? AppColors.primary : Colors.black)
                  .withValues(alpha: _hovered ? 0.32 : 0.14),
              blurRadius: _hovered ? 52 : 16,
              offset: Offset(0, _hovered ? 28 : 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox.expand(
            child: Stack(
              children: [
                // ── Full-card image ─────────────────────────────────────────
                Positioned.fill(
                  child: p.imageUrl.isNotEmpty
                      ? Image.asset(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _CategoryGradient(category: p.category),
                        )
                      : _CategoryGradient(category: p.category),
                ),

                // ── Gradient scrim at bottom (helps content panel contrast) ─
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 200,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.18),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Featured badge ──────────────────────────────────────────
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
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                // ── Content panel — floats at card bottom over the image ────
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF12122A).withValues(alpha: 0.96)
                          : Colors.white.withValues(alpha: 0.97),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          p.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimary
                                : const Color(0xFF0D0D2B),
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 7),

                        // Description
                        Text(
                          p.description,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.55,
                            color: isDark
                                ? AppColors.textSecondary
                                : const Color(0xFF4A4A6A),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),

                        // Footer: platform badges + store link
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ─────────────────────────────────────────────────────────────

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
    final (color, label) = switch (platform) {
      'android' => (const Color(0xFF4CAF50), 'Android'),
      'ios' => (const Color(0xFF9E9E9E), 'iOS'),
      'web' => (AppColors.secondary, 'Web'),
      'desktop' => (const Color(0xFF9C27B0), 'Desktop'),
      _ => (AppColors.primary, platform),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.45)),
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
              fontSize: 11,
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
