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
        duration: const Duration(milliseconds: 280),
        curve: _hovered ? Curves.easeOutBack : Curves.easeOut,
        transform: Matrix4.translationValues(0, _hovered ? -10 : 0, 0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (_hovered ? AppColors.primary : Colors.black)
                  .withValues(alpha: _hovered ? 0.22 : 0.10),
              blurRadius: _hovered ? 32 : 10,
              offset: Offset(0, _hovered ? 16 : 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image header ─────────────────────────────────────────
              Expanded(
                flex: 55,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (p.imageUrl.isNotEmpty)
                      Image.asset(
                        p.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _CategoryGradient(category: p.category),
                      )
                    else
                      _CategoryGradient(category: p.category),
                    if (p.isFeatured)
                      Positioned(
                        top: 12,
                        right: 12,
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

              // ── Content body ──────────────────────────────────────────
              Expanded(
                flex: 45,
                child: Container(
                  width: double.infinity,
                  color: isDark ? AppColors.surface : Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        p.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimary
                              : const Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Description
                      Expanded(
                        child: Text(
                          p.description,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.55,
                            color: isDark
                                ? AppColors.textSecondary
                                : const Color(0xFF555555),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Footer row: badges + link
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...p.platforms.take(2).map(
                                (pl) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: _PlatformBadge(platform: pl),
                                ),
                              ),
                          const Spacer(),
                          if (p.playStoreUrl?.isNotEmpty ?? false)
                            _ArrowLink(
                              label: 'Play Store',
                              url: p.playStoreUrl!,
                              color: const Color(0xFF2ECC71),
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
    );
  }
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────────

class _CategoryGradient extends StatelessWidget {
  final String category;
  const _CategoryGradient({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = switch (category.toLowerCase()) {
      'social' => [const Color(0xFFAD1457), const Color(0xFFF06292)],
      'e-commerce' => [const Color(0xFF5C6BC0), const Color(0xFF9E97FF)],
      'healthcare' => [const Color(0xFF00897B), const Color(0xFF4DB6AC)],
      'fintech' => [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
      'logistics' => [const Color(0xFFE65100), const Color(0xFFFF8A65)],
      _ => [const Color(0xFF37474F), const Color(0xFF78909C)],
    };
    return Container(
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
    final color = switch (platform) {
      'android' => const Color(0xFF4CAF50),
      'ios' => const Color(0xFF9E9E9E),
      'web' => AppColors.secondary,
      'desktop' => const Color(0xFF9C27B0),
      _ => AppColors.primary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        platform.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ArrowLink extends StatelessWidget {
  final String label;
  final String url;
  final Color color;
  const _ArrowLink({required this.label, required this.url, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.arrow_outward_rounded, size: 13, color: color),
        ],
      ),
    );
  }
}
