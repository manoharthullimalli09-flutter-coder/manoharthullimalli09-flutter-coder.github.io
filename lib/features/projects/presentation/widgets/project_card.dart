import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/glass_card.dart';
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
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0.0, _hovered ? -6.0 : 0.0, 0.0),
        child: GlassCard(
          padding: EdgeInsets.zero,
          borderColor: _hovered
              ? _categoryGradient(p.category).first.withValues(alpha: 0.6)
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project image / gradient header
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusMd),
                ),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _categoryGradient(p.category),
                          ),
                        ),
                      ),
                      // Full logo — contained, never cropped
                      if (p.imageUrl.isNotEmpty)
                        Image.asset(
                          p.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            _categoryIcon(p.category),
                            size: 56,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        )
                      else
                        Icon(
                          _categoryIcon(p.category),
                          size: 56,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      if (p.isFeatured)
                        Positioned(
                          top: AppSizes.sm,
                          right: AppSizes.sm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.sm,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusXl,
                              ),
                            ),
                            child: Text(
                              'Featured',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      p.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.sm),
                      // Platform badges
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: p.platforms
                            .map((pl) => _PlatformBadge(platform: pl))
                            .toList(),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      // Tech stack chips
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: p.techStack
                            .take(4)
                            .map((t) => _TechChip(label: t))
                            .toList(),
                      ),
                      // Store links
                      if ((p.playStoreUrl?.isNotEmpty ?? false) ||
                          (p.appStoreUrl?.isNotEmpty ?? false) ||
                          (p.webUrl?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: AppSizes.sm),
                        const Divider(color: AppColors.border, height: 1),
                        const SizedBox(height: AppSizes.sm),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (p.playStoreUrl?.isNotEmpty ?? false)
                              _StoreButton(
                                label: 'Play Store',
                                icon: Icons.android_rounded,
                                color: const Color(0xFF4CAF50),
                                url: p.playStoreUrl!,
                              ),
                            if (p.appStoreUrl?.isNotEmpty ?? false)
                              _StoreButton(
                                label: 'App Store',
                                icon: Icons.apple_rounded,
                                color: AppColors.textSecondary,
                                url: p.appStoreUrl!,
                              ),
                            if (p.webUrl?.isNotEmpty ?? false)
                              _StoreButton(
                                label: 'Live Demo',
                                icon: Icons.open_in_browser_rounded,
                                color: AppColors.secondary,
                                url: p.webUrl!,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _categoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'e-commerce':
        return [const Color(0xFF6C63FF), const Color(0xFF9E97FF)];
      case 'healthcare':
        return [const Color(0xFF00897B), const Color(0xFF4DB6AC)];
      case 'fintech':
        return [const Color(0xFF1565C0), const Color(0xFF42A5F5)];
      case 'logistics':
        return [const Color(0xFFE65100), const Color(0xFFFF8A65)];
      case 'social':
        return [const Color(0xFFAD1457), const Color(0xFFF06292)];
      default:
        return [const Color(0xFF37474F), const Color(0xFF78909C)];
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'e-commerce':
        return Icons.shopping_bag_outlined;
      case 'healthcare':
        return Icons.local_hospital_outlined;
      case 'fintech':
        return Icons.account_balance_outlined;
      case 'logistics':
        return Icons.local_shipping_outlined;
      case 'social':
        return Icons.people_outline_rounded;
      default:
        return Icons.dashboard_outlined;
    }
  }
}

class _StoreButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String url;
  const _StoreButton({required this.label, required this.icon, required this.color, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _color().withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _color().withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        platform.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _color(),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _color() {
    switch (platform) {
      case 'android':
        return const Color(0xFF4CAF50);
      case 'ios':
        return const Color(0xFF9E9E9E);
      case 'web':
        return const Color(0xFF00D4FF);
      case 'desktop':
        return const Color(0xFF9C27B0);
      default:
        return AppColors.primary;
    }
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  const _TechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.primary,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Infosys-style panel card (desktop) ───────────────────────────────────────

class ProjectPanelCard extends StatelessWidget {
  final ProjectEntity project;
  final bool isHovered;
  final bool anyHovered;

  const ProjectPanelCard({
    super.key,
    required this.project,
    required this.isHovered,
    required this.anyHovered,
  });

  @override
  Widget build(BuildContext context) {
    final p = project;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: isHovered ? Curves.easeOutBack : Curves.easeOut,
      transformAlignment: Alignment.center,
      transform: Matrix4.identity()
        ..translate(0.0, isHovered ? -14.0 : (anyHovered ? 5.0 : 0.0))
        ..scale(isHovered ? 1.04 : (anyHovered ? 0.97 : 1.0)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isHovered ? AppColors.primary : Colors.black)
                .withValues(alpha: isHovered ? 0.28 : 0.10),
            blurRadius: isHovered ? 36 : 10,
            offset: Offset(0, isHovered ? 18 : 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image top (60%) ──────────────────────────────────
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (p.imageUrl.isNotEmpty)
                    Image.asset(
                      p.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _GradientBg(category: p.category),
                    )
                  else
                    _GradientBg(category: p.category),
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
                        child: Text(
                          'Featured',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Content bottom (40%) ─────────────────────────────
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: isDark ? AppColors.surface : Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimary
                            : const Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        p.description,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.5,
                          color: isDark
                              ? AppColors.textSecondary
                              : const Color(0xFF555555),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Platform badges
                        ...p.platforms.take(2).map((pl) => Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: _PlatformBadge(platform: pl),
                            )),
                        const Spacer(),
                        // Store / demo link
                        if (p.playStoreUrl?.isNotEmpty ?? false)
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(p.playStoreUrl!),
                                mode: LaunchMode.externalApplication),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Play Store',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(width: 2),
                                const Icon(Icons.arrow_outward_rounded,
                                    size: 12, color: AppColors.primary),
                              ],
                            ),
                          )
                        else if (p.webUrl?.isNotEmpty ?? false)
                          GestureDetector(
                            onTap: () => launchUrl(Uri.parse(p.webUrl!),
                                mode: LaunchMode.externalApplication),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Live Demo',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(width: 2),
                                const Icon(Icons.arrow_outward_rounded,
                                    size: 12, color: AppColors.secondary),
                              ],
                            ),
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
    );
  }
}

class _GradientBg extends StatelessWidget {
  final String category;
  const _GradientBg({required this.category});

  @override
  Widget build(BuildContext context) {
    final colors = switch (category.toLowerCase()) {
      'e-commerce' => [const Color(0xFF6C63FF), const Color(0xFF9E97FF)],
      'healthcare' => [const Color(0xFF00897B), const Color(0xFF4DB6AC)],
      'social' => [const Color(0xFFAD1457), const Color(0xFFF06292)],
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
