import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/project_entity.dart';
import '../bloc/projects_bloc.dart';
import 'project_card.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectsBloc>()..add(LoadProjects()),
      child: const _ProjectsContent(),
    );
  }
}

class _ProjectsContent extends StatelessWidget {
  const _ProjectsContent();

  static const _filters = ['All', 'Android', 'iOS', 'Web', 'Desktop'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        return Column(
          children: [
            const SectionHeader(
              title: 'My Projects',
              subtitle:
                  'Real-world apps shipped across meditation, real estate, and enterprise platforms.',
            ),
            const SizedBox(height: AppSizes.xl),
            // Filter chips
            FadeInUp(
              delay: const Duration(milliseconds: 200),
              child: Wrap(
                spacing: AppSizes.sm,
                runSpacing: AppSizes.sm,
                alignment: WrapAlignment.center,
                children: _filters.map((f) {
                  final active = state is ProjectsLoaded
                      ? (f == 'All'
                          ? state.activeFilter == null
                          : state.activeFilter == f.toLowerCase())
                      : f == 'All';
                  return _FilterChip(
                    label: f,
                    isActive: active,
                    onTap: () {
                      final bloc = context.read<ProjectsBloc>();
                      if (f == 'All') {
                        bloc.add(ClearProjectFilter());
                      } else {
                        bloc.add(FilterProjectsByPlatform(f.toLowerCase()));
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            if (state is ProjectsLoading)
              const Padding(
                padding: EdgeInsets.all(AppSizes.xxxl),
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            else if (state is ProjectsError)
              Text(state.message,
                  style: const TextStyle(color: AppColors.error))
            else if (state is ProjectsLoaded)
              _ProjectGrid(projects: state.projects),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
      side: BorderSide(
        color: isActive ? AppColors.primary : AppColors.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
    );
  }
}

// ── Grid ─────────────────────────────────────────────────────────────────────

class _ProjectGrid extends StatelessWidget {
  final List<ProjectEntity> projects;
  const _ProjectGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    // Mobile: single column, no hover needed
    if (context.isMobile) {
      return Column(
        children: [
          for (var i = 0; i < projects.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            FadeInUp(
              delay: Duration(milliseconds: 80 * i),
              child: ProjectCard(project: projects[i]),
            ),
          ],
        ],
      );
    }

    // Desktop: 3 per row | Tablet: 2 per row
    final chunkSize = context.isDesktop ? 3 : 2;
    final chunks = <List<ProjectEntity>>[];
    for (var i = 0; i < projects.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, projects.length);
      chunks.add(projects.sublist(i, end));
    }

    return Column(
      children: [
        for (var i = 0; i < chunks.length; i++) ...[
          if (i > 0) const SizedBox(height: 28),
          FadeInUp(
            delay: Duration(milliseconds: 120 * i),
            child: _HoverableRow(projects: chunks[i], slots: chunkSize),
          ),
        ],
      ],
    );
  }
}

/// Coordinated hover for a row of cards: the hovered card takes a larger
/// share of the row's width and its siblings give the same amount back.
///
/// Width is the only thing this row animates. Each [ProjectCard] turns that
/// into artwork that scales on every side while its panel stays level with
/// the rest of the row — see that class for the split.
class _HoverableRow extends StatefulWidget {
  final List<ProjectEntity> projects;

  /// Cards are sized against the row's capacity, not its contents, so a
  /// partial final row matches the rows above it instead of stretching.
  final int slots;

  const _HoverableRow({required this.projects, required this.slots});

  @override
  State<_HoverableRow> createState() => _HoverableRowState();
}

class _HoverableRowState extends State<_HoverableRow>
    with SingleTickerProviderStateMixin {
  static const _gap = 24.0;

  /// Extra width the hovered card takes, as a fraction of an even share.
  static const _growth = 0.20;
  static const _duration = Duration(milliseconds: 420);

  late final AnimationController _controller;
  late List<double> _from;
  late List<double> _to;
  int? _hovered;

  int get _count => widget.projects.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _duration, vsync: this)
      ..value = 1;
    _from = _sharesFor(null);
    _to = _from;
  }

  @override
  void didUpdateWidget(_HoverableRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Filter chips change the row's length and a resize changes its slot
    // count; stale share lists would index out of range on the next frame.
    if (oldWidget.projects.length != _count ||
        oldWidget.slots != widget.slots) {
      _hovered = null;
      _from = _sharesFor(null);
      _to = _from;
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The shares always add up to the same total, whichever card is hovered,
  /// so the row's width is constant on every frame — otherwise dragging the
  /// pointer straight from one card to the next overflows the Row mid-tween.
  List<double> _sharesFor(int? hovered) {
    final base = 1 / widget.slots;
    if (hovered == null || _count < 2) return List.filled(_count, base);
    final gain = base * _growth;
    return [
      for (var i = 0; i < _count; i++)
        i == hovered ? base + gain : base - gain / (_count - 1),
    ];
  }

  List<double> get _shares {
    final t = Curves.easeOutCubic.transform(_controller.value);
    return [
      for (var i = 0; i < _count; i++) _from[i] + (_to[i] - _from[i]) * t,
    ];
  }

  void _hover(int? index) {
    if (_hovered == index) return;
    setState(() {
      _from = _shares;
      _to = _sharesFor(index);
      _hovered = index;
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth - _gap * (widget.slots - 1);
        final base = available / widget.slots;

        // Artwork height at rest and at full hover. The card uses both to
        // reserve a constant-height box, so the panels stay level while the
        // artwork inside is free to grow past them.
        //
        // The headroom is reserved even in a row that cannot grow — a lone
        // card in a partial final row must still box out to the same height
        // as the full rows above it.
        final baseImageHeight = base / ProjectCard.imageAspect;
        final maxImageHeight =
            base * (1 + _growth) / ProjectCard.imageAspect;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final shares = _shares;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _count; i++) ...[
                  if (i > 0) const SizedBox(width: _gap),
                  SizedBox(
                    width: available * shares[i],
                    child: MouseRegion(
                      onEnter: (_) => _hover(i),
                      onExit: (_) => _hover(null),
                      cursor: SystemMouseCursors.click,
                      child: ProjectCard(
                        project: widget.projects[i],
                        isHovered: _hovered == i,
                        baseImageHeight: baseImageHeight,
                        maxImageHeight: maxImageHeight,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
