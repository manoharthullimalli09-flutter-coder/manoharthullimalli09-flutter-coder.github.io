import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../extensions/context_extensions.dart';
import '../../features/theme_switcher/presentation/bloc/theme_cubit.dart';

class PortfolioNavBar extends StatefulWidget {
  /// Height of the sticky bar. Content scrolls beneath it, so section
  /// targets and the leading spacer both have to account for it.
  static const double height = 72;

  /// Gap left between the bar and the top of the section it reveals.
  static const double _scrollMargin = 16;

  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  const PortfolioNavBar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  /// Brings [key]'s section to rest just below the bar.
  ///
  /// `Scrollable.ensureVisible` aligns the target's top edge with the
  /// viewport's top edge — which on this page is behind the bar, hiding
  /// every section header it lands on.
  static void scrollToSection(ScrollController controller, GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !controller.hasClients) return;

    final target = controller.offset +
        box.localToGlobal(Offset.zero).dy -
        height -
        _scrollMargin;

    controller.animateTo(
      target.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  State<PortfolioNavBar> createState() => _PortfolioNavBarState();
}

class _PortfolioNavBarState extends State<PortfolioNavBar> {
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 40;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _scrollTo(GlobalKey key) =>
      PortfolioNavBar.scrollToSection(widget.scrollController, key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Opaque enough that section headers passing underneath cannot ghost
    // through the bar, with a real blur behind it for the frosted look.
    final tint = isDark ? AppColors.surface : Colors.white;

    final bar = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: _isScrolled ? tint.withValues(alpha: 0.88) : Colors.transparent,
        border: _isScrolled
            ? Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.6),
                  width: 1,
                ),
              )
            : null,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                ),
              ]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.xl,
            vertical: AppSizes.sm,
          ),
          child: context.isMobile
              ? _MobileNav(onTap: _scrollTo, sectionKeys: widget.sectionKeys)
              : _DesktopNav(onTap: _scrollTo, sectionKeys: widget.sectionKeys),
        ),
      ),
    );

    // Mounted only while the bar is actually tinted. A BackdropFilter costs a
    // saveLayer every frame even at sigma 0, and at the top of the page there
    // is nothing behind the bar to frost.
    if (!_isScrolled) return bar;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: bar,
      ),
    );
  }
}

class _DesktopNav extends StatelessWidget {
  final void Function(GlobalKey) onTap;
  final List<GlobalKey> sectionKeys;

  const _DesktopNav({required this.onTap, required this.sectionKeys});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientLogo(),
        const Spacer(),
        _NavLink(label: 'Home', onTap: () => onTap(sectionKeys[0])),
        _NavLink(label: 'Projects', onTap: () => onTap(sectionKeys[1])),
        _NavLink(label: 'Skills', onTap: () => onTap(sectionKeys[2])),
        _NavLink(label: 'Contact', onTap: () => onTap(sectionKeys[3])),
        const SizedBox(width: AppSizes.md),
        _ThemeToggle(),
      ],
    );
  }
}

class _MobileNav extends StatelessWidget {
  final void Function(GlobalKey) onTap;
  final List<GlobalKey> sectionKeys;

  const _MobileNav({required this.onTap, required this.sectionKeys});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GradientLogo(),
        const Spacer(),
        _ThemeToggle(),
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu_rounded),
          onSelected: (i) => onTap(sectionKeys[i]),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 0, child: Text('Home')),
            PopupMenuItem(value: 1, child: Text('Projects')),
            PopupMenuItem(value: 2, child: Text('Skills')),
            PopupMenuItem(value: 3, child: Text('Contact')),
          ],
        ),
      ],
    );
  }
}

class GradientLogo extends StatelessWidget {
  const GradientLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (b) => const LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
      ).createShader(b),
      child: Text(
        'MT.',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: _hover ? AppColors.primary : AppColors.textSecondary,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (ctx, mode) => IconButton(
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            mode == ThemeMode.dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            key: ValueKey(mode),
            color: AppColors.textSecondary,
          ),
        ),
        onPressed: () => ctx.read<ThemeCubit>().toggleTheme(),
        tooltip: 'Toggle theme',
      ),
    );
  }
}
