import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/project_entity.dart';
import 'project_chips.dart';
import 'project_detail_dialog.dart';

typedef _CardLink = ({String label, String url, Color color});

/// Full-bleed image with a content panel floating over its lower edge.
///
/// The two halves respond to hover differently, which is what gives the
/// effect its shape:
///
///  * the **artwork** scales on every side — it keeps [imageAspect] against
///    the card's animated width and grows about a fixed centre line, so it
///    rises above its neighbours as it widens;
///  * the **panel** only ever changes width. It sits at a constant offset
///    from the top of a constant-height card box, so every panel in a row
///    stays level and the row itself never changes height.
class ProjectCard extends StatelessWidget {
  /// Artwork shape. Lower is taller — 16/9 reads as a thin banner strip, so
  /// this sits nearer 4/3 to give the screenshot real presence on the card.
  static const imageAspect = 4 / 3;

  static const _radius = 16.0;
  static const _panelInset = 14.0;
  static const _panelOverlap = 26.0;
  static const _duration = Duration(milliseconds: 420);

  final ProjectEntity project;
  final bool isHovered;

  /// Artwork height at the row's even share, and at full hover. A row passes
  /// both so the card box can be sized once for the largest the artwork will
  /// ever get; a card laid out on its own derives them from its own width.
  final double? baseImageHeight;
  final double? maxImageHeight;

  const ProjectCard({
    super.key,
    required this.project,
    this.isHovered = false,
    this.baseImageHeight,
    this.maxImageHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Touch devices never fire hover, so the link cannot depend on it there.
    final showLink = isHovered || context.isMobile;

    return Semantics(
      button: true,
      label: '${project.title}. ${project.category} project. '
          'Open for full details.',
      child: GestureDetector(
        onTap: () => ProjectDetailDialog.show(context, project),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Tracks the card's animated width.
            final imageH = constraints.maxWidth / imageAspect;
            final baseH = baseImageHeight ?? imageH;
            final maxH = maxImageHeight ?? imageH;

            // Growing about this line makes the artwork expand upward and
            // downward by equal amounts as it widens.
            final centreY = maxH / 2;

            // Constant for every card in the row, so the panel never shifts
            // and the card box is always tall enough for the largest artwork.
            final panelOffset = (baseH + maxH) / 2 - _panelOverlap;

            return Stack(
              // The artwork rises above the box, and the panel's drop shadow
              // falls below it.
              clipBehavior: Clip.none,
              children: [
                // Listed first so it paints behind the floating panel;
                // positioned so it adds nothing to the Stack's height.
                Positioned(
                  top: centreY - imageH / 2,
                  left: 0,
                  right: 0,
                  height: imageH,
                  child: _ImageHeader(project: project, isHovered: isHovered),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: panelOffset),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: _panelInset),
                      child: _ContentPanel(
                        project: project,
                        isHovered: isHovered,
                        showLink: showLink,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ── Image header ─────────────────────────────────────────────────────────────

class _ImageHeader extends StatelessWidget {
  final ProjectEntity project;
  final bool isHovered;

  const _ImageHeader({required this.project, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ProjectCard._duration,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ProjectCard._radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.28 : 0.12),
            blurRadius: isHovered ? 38 : 16,
            offset: Offset(0, isHovered ? 16 : 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ProjectCard._radius),
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
            // Platform badges live on the artwork so the panel below can
            // spend its space on the tech stack instead.
            Positioned(
              top: 12,
              left: 12,
              child: Wrap(
                spacing: 5,
                children: [
                  for (final p in project.platforms)
                    PlatformBadge(platform: p, onImage: true),
                ],
              ),
            ),
            if (project.isFeatured)
              const Positioned(top: 12, right: 12, child: _FeaturedBadge()),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
    );
  }
}

// ── Content panel ────────────────────────────────────────────────────────────

class _ContentPanel extends StatelessWidget {
  final ProjectEntity project;
  final bool isHovered;
  final bool showLink;

  const _ContentPanel({
    required this.project,
    required this.isHovered,
    required this.showLink,
  });

  static _CardLink? _linkFor(ProjectEntity p) {
    if (p.playStoreUrl?.isNotEmpty ?? false) {
      return (
        label: 'Play Store',
        url: p.playStoreUrl!,
        color: const Color(0xFF34C759),
      );
    }
    if (p.webUrl?.isNotEmpty ?? false) {
      return (label: 'Live Demo', url: p.webUrl!, color: AppColors.secondary);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final p = project;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final link = _linkFor(p);

    return AnimatedContainer(
      duration: ProjectCard._duration,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF13132B) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: isHovered ? 0.16 : 0.06)
              : Colors.black.withValues(alpha: isHovered ? 0.08 : 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.20 : 0.10),
            blurRadius: isHovered ? 28 : 14,
            offset: Offset(0, isHovered ? 12 : 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.25,
              color: isHovered
                  ? AppColors.primary
                  : (isDark ? AppColors.textPrimary : const Color(0xFF0D0D2B)),
            ),
            child: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 62, // locks to 3 lines — panel height is hover-invariant
            child: Text(
              p.description,
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color:
                    isDark ? AppColors.textSecondary : const Color(0xFF55556B),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          _TechRow(techStack: p.techStack),
          const SizedBox(height: 10),
          // Height is reserved whether or not a link exists, so revealing it
          // cannot reflow the panel and every card in a row stays level.
          SizedBox(
            height: 18,
            child: link == null
                ? null
                : IgnorePointer(
                    ignoring: !showLink,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 320),
                      curve: Curves.easeOutCubic,
                      offset: showLink ? Offset.zero : const Offset(0, 0.6),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 260),
                        opacity: showLink ? 1 : 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _ArrowLink(
                            label: link.label,
                            url: link.url,
                            color: link.color,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// One row of tech chips, laid out freely and clipped to a single line.
///
/// Clipping at a row boundary means a wider card simply shows more of the
/// stack — no ellipsised technology names, and no overflow to handle.
class _TechRow extends StatelessWidget {
  final List<String> techStack;

  static const _rowHeight = 22.0;

  const _TechRow({required this.techStack});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: _rowHeight,
        child: OverflowBox(
          alignment: Alignment.topLeft,
          maxHeight: 400,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [for (final t in techStack) TechChip(label: t)],
          ),
        ),
      ),
    );
  }
}

class _ArrowLink extends StatelessWidget {
  final String label;
  final String url;
  final Color color;

  const _ArrowLink({
    required this.label,
    required this.url,
    required this.color,
  });

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
