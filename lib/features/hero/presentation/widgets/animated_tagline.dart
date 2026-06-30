import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AnimatedTagline extends StatefulWidget {
  final List<String> phrases;
  final TextAlign textAlign;

  const AnimatedTagline({
    super.key,
    required this.phrases,
    this.textAlign = TextAlign.start,
  });

  @override
  State<AnimatedTagline> createState() => _AnimatedTaglineState();
}

class _AnimatedTaglineState extends State<AnimatedTagline> {
  int _phraseIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  String _display = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _tick() {
    final phrase = widget.phrases[_phraseIndex];
    _timer = Timer(Duration(milliseconds: _isDeleting ? 40 : 80), () {
      if (!mounted) return;
      setState(() {
        if (_isDeleting) {
          _charIndex--;
          _display = phrase.substring(0, _charIndex);
          if (_charIndex == 0) {
            _isDeleting = false;
            _phraseIndex = (_phraseIndex + 1) % widget.phrases.length;
          }
        } else {
          _charIndex++;
          _display = phrase.substring(0, _charIndex);
          if (_charIndex == phrase.length) {
            Future.delayed(const Duration(milliseconds: 1800), () {
              if (mounted) setState(() => _isDeleting = true);
            });
            return;
          }
        }
      });
      _tick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            _display,
            textAlign: widget.textAlign,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _Cursor(),
      ],
    );
  }
}

class _Cursor extends StatefulWidget {
  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 2,
        height: 22,
        margin: const EdgeInsets.only(left: 2),
        color: AppColors.secondary,
      ),
    );
  }
}
