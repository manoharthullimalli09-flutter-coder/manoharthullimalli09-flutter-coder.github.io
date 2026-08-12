import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/project_entity.dart';
import 'project_card.dart';
import 'project_chips.dart';

/// Full read of a single project. The card truncates its description to keep
/// a row of cards level; this is where the untruncated copy, the complete
/// stack, and every store link live.
class ProjectDetailDialog extends StatelessWidget {
  final ProjectEntity project;

  const ProjectDetailDialog({super.key, required this.project});

  static Future<void> show(BuildContext context, ProjectEntity project) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.72),
      builder: (_) => ProjectDetailDialog(project: project),
    );
  }

  List<({String label, String url, IconData icon, Color color})> get _links => [
        if (project.playStoreUrl?.isNotEmpty ?? false)
          (
            label: 'Play Store',
            url: project.playStoreUrl!,
            icon: Icons.shop_rounded,
            color: const Color(0xFF34C759),
          ),
        if (project.appStoreUrl?.isNotEmpty ?? false)
          (
            label: 'App Store',
            url: project.appStoreUrl!,
            icon: Icons.apple_rounded,
            color: AppColors.secondary,
          ),
        if (project.webUrl?.isNotEmpty ?? false)
          (
            label: 'Live Demo',
            url: project.webUrl!,
            icon: Icons.language_rounded,
            color: AppColors.secondary,
          ),
        if (project.githubUrl?.isNotEmpty ?? false)
          (
            label: 'Source',
            url: project.githubUrl!,
            icon: Icons.code_rounded,
            color: AppColors.primaryLight,
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final media = MediaQuery.sizeOf(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSizes.md),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 620,
          maxHeight: media.height * 0.88,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: ColoredBox(
            color: isDark ? const Color(0xFF13132B) : Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(project: project),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: _Body(project: project, links: _links),
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

class _Header extends StatelessWidget {
  final ProjectEntity project;
  const _Header({required this.project});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ProjectCard.imageAspect,
      child: Stack(
        fit: StackFit.expand,
        children: [
          project.imageUrl.isNotEmpty
              ? Image.asset(
                  project.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      CategoryArtwork(category: project.category),
                )
              : CategoryArtwork(category: project.category),
          Positioned(
            top: AppSizes.md,
            left: AppSizes.md,
            child: Wrap(
              spacing: 6,
              children: [
                for (final p in project.platforms)
                  PlatformBadge(platform: p, onImage: true),
              ],
            ),
          ),
          Positioned(
            top: AppSizes.sm,
            right: AppSizes.sm,
            child: Material(
              color: Colors.black.withValues(alpha: 0.55),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.close_rounded,
                    size: 20, color: Colors.white),
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final ProjectEntity project;
  final List<({String label, String url, IconData icon, Color color})> links;

  const _Body({required this.project, required this.links});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = project;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              p.category.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            if (p.isFeatured) ...[
              const SizedBox(width: AppSizes.sm),
              const Icon(Icons.star_rounded,
                  size: 14, color: AppColors.warning),
              const SizedBox(width: 2),
              const Text(
                'Featured',
                style: TextStyle(
                  color: AppColors.warning,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          p.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: isDark ? AppColors.textPrimary : const Color(0xFF0D0D2B),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          p.description,
          style: TextStyle(
            fontSize: 14,
            height: 1.65,
            color: isDark ? AppColors.textSecondary : const Color(0xFF55556B),
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        _Label(text: 'Built with'),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [for (final t in p.techStack) TechChip(label: t)],
        ),
        if (links.isNotEmpty) ...[
          const SizedBox(height: AppSizes.lg),
          _Label(text: 'Links'),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: [
              for (final l in links)
                _LinkButton(
                  label: l.label,
                  url: l.url,
                  icon: l.icon,
                  color: l.color,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.textMuted
            : const Color(0xFF8A8AA3),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final String url;
  final IconData icon;
  final Color color;

  const _LinkButton({
    required this.label,
    required this.url,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () =>
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      icon: Icon(icon, size: 16, color: color),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.45)),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm + 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
