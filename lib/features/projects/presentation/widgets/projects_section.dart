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
            child: _HoverableRow(projects: chunks[i]),
          ),
        ],
      ],
    );
  }
}

/// Tracks which card is hovered and tells all siblings, enabling the
/// Infosys-style grow/shrink coordinated animation.
class _HoverableRow extends StatefulWidget {
  final List<ProjectEntity> projects;
  const _HoverableRow({required this.projects});

  @override
  State<_HoverableRow> createState() => _HoverableRowState();
}

class _HoverableRowState extends State<_HoverableRow> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final items = widget.projects;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 20),
          Expanded(
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = i),
              onExit: (_) => setState(() => _hoveredIndex = null),
              cursor: SystemMouseCursors.click,
              child: ProjectCard(
                project: items[i],
                isHovered: _hoveredIndex == i,
                anyHovered: _hoveredIndex != null,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
