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
                  'Real-world apps shipped across e-commerce, healthcare, fintech, logistics & social platforms.',
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
              const CircularProgressIndicator(color: AppColors.primary)
            else if (state is ProjectsError)
              Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              )
            else if (state is ProjectsLoaded) ...[
              _ProjectGrid(projects: state.projects),
            ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: FilterChip(
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
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  final List<ProjectEntity> projects;
  const _ProjectGrid({required this.projects});

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) {
      return _ExpandingPanels(projects: projects);
    }
    final cols = context.isTablet ? 2 : 1;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: AppSizes.lg,
        mainAxisSpacing: AppSizes.lg,
        childAspectRatio: 0.9,
      ),
      itemCount: projects.length,
      itemBuilder: (_, i) => FadeInUp(
        delay: Duration(milliseconds: 100 * i),
        child: ProjectCard(project: projects[i]),
      ),
    );
  }
}

class _ExpandingPanels extends StatefulWidget {
  final List<ProjectEntity> projects;
  const _ExpandingPanels({required this.projects});

  @override
  State<_ExpandingPanels> createState() => _ExpandingPanelsState();
}

class _ExpandingPanelsState extends State<_ExpandingPanels> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final n = widget.projects.length;
    final anyHovered = _hoveredIndex != null;

    return SizedBox(
      height: 460,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.projects.asMap().entries.map((entry) {
          final i = entry.key;
          final isHovered = _hoveredIndex == i;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < n - 1 ? AppSizes.md : 0),
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = i),
                onExit: (_) => setState(() => _hoveredIndex = null),
                child: FadeInUp(
                  delay: Duration(milliseconds: 80 * i),
                  child: ProjectPanelCard(
                    project: entry.value,
                    isHovered: isHovered,
                    anyHovered: anyHovered,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
