import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/particles_background.dart';
import '../../../core/widgets/portfolio_nav_bar.dart';
import '../../contact/presentation/widgets/contact_section.dart';
import '../../hero/presentation/widgets/hero_section.dart';
import '../../projects/presentation/widgets/projects_section.dart';
import '../../skills/presentation/widgets/skills_section.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _scrollController = ScrollController();
  final _heroKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad = context.isDesktop
        ? AppSizes.xxxl * 1.5
        : (context.isTablet ? AppSizes.xl : AppSizes.md);

    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // NavBar space
              const SliverToBoxAdapter(child: SizedBox(height: 72)),

              // Hero
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: ParticlesBackground(
                    child: _Section(
                      key: _heroKey,
                      minHeight: context.screenHeight * 0.9,
                      padding: EdgeInsets.symmetric(
                        horizontal: hPad,
                        vertical: AppSizes.xxxl,
                      ),
                      child: HeroSection(
                        onViewWork: () => _scrollTo(_projectsKey),
                        onHireMe: () => _scrollTo(_contactKey),
                      ),
                    ),
                  ),
                ),
              ),

              // Divider
              const SliverToBoxAdapter(child: _SectionDivider()),

              // Projects
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _Section(
                    key: _projectsKey,
                    padding: EdgeInsets.symmetric(
                      horizontal: hPad,
                      vertical: AppSizes.sectionPaddingV,
                    ),
                    child: _MaxWidth(child: const ProjectsSection()),
                  ),
                ),
              ),

              // Divider
              const SliverToBoxAdapter(child: _SectionDivider()),

              // Skills
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _Section(
                    key: _skillsKey,
                    padding: EdgeInsets.symmetric(
                      horizontal: hPad,
                      vertical: AppSizes.sectionPaddingV,
                    ),
                    child: _MaxWidth(child: const SkillsSection()),
                  ),
                ),
              ),

              // Divider
              const SliverToBoxAdapter(child: _SectionDivider()),

              // Contact
              SliverToBoxAdapter(
                child: RepaintBoundary(
                  child: _Section(
                    key: _contactKey,
                    padding: EdgeInsets.symmetric(
                      horizontal: hPad,
                      vertical: AppSizes.sectionPaddingV,
                    ),
                    child: _MaxWidth(child: const ContactSection()),
                  ),
                ),
              ),

              // Footer
              SliverToBoxAdapter(child: _Footer()),
            ],
          ),

          // Sticky NavBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PortfolioNavBar(
              scrollController: _scrollController,
              sectionKeys: [_heroKey, _projectsKey, _skillsKey, _contactKey],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? minHeight;

  const _Section({
    super.key,
    required this.child,
    required this.padding,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _MaxWidth extends StatelessWidget {
  final Widget child;
  const _MaxWidth({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: child,
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.xxxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.border,
            AppColors.border,
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.xl,
        horizontal: AppSizes.lg,
      ),
      child: Column(
        children: [
          const Divider(color: AppColors.border),
          const SizedBox(height: AppSizes.md),
          Text(
            '© ${DateTime.now().year} Manohar Thullimalli · Built with Flutter',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Web · Android · iOS · Desktop · from one codebase',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.primary.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
