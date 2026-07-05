import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class PortfolioChatbot extends StatefulWidget {
  const PortfolioChatbot({super.key});

  @override
  State<PortfolioChatbot> createState() => _PortfolioChatbotState();
}

class _PortfolioChatbotState extends State<PortfolioChatbot>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          "Hi! I'm Manohar's assistant 👋\nAsk me anything about his experience, skills, or projects!",
      isBot: true,
    ),
  ];

  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _messages.add(_ChatMessage(text: _getResponse(text), isBot: true));
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getResponse(String input) {
    final q = input.toLowerCase();

    if (_matches(q, ['hello', 'hi', 'hey', 'greet', 'good morning', 'good evening'])) {
      return "Hello! 👋 I'm here to tell you all about Manohar. What would you like to know?";
    }
    if (_matches(q, ['experience', 'years', 'how long', 'exp', 'senior'])) {
      return "Manohar has 5+ years of professional Flutter experience, shipping production apps across Android, iOS, Web, and Desktop for clients in e-commerce, healthcare, fintech, logistics, and social platforms.";
    }
    if (_matches(q, ['skill', 'tech', 'stack', 'technology', 'know', 'expertise', 'language'])) {
      return "Core stack:\n• Flutter & Dart (all platforms)\n• State: BLoC/Cubit, Riverpod, Provider\n• Backend: Firebase, REST APIs, Dio\n• Architecture: Clean Architecture, SOLID\n• Testing: Unit, Widget, Integration\n• CI/CD: GitHub Actions, Codemagic, Fastlane";
    }
    if (_matches(q, ['project', 'work', 'built', 'app', 'portfolio', 'showcase'])) {
      return "Manohar has built 20+ production apps:\n• E-Commerce platform (10k+ users)\n• Healthcare Patient Portal\n• FinTech Invoice Manager (500+ SMEs)\n• Logistics Tracking Platform\n• Community Social App (25k+ users)\n• HR Productivity Dashboard\n\nScroll up to Projects to see full details!";
    }
    if (_matches(q, ['available', 'hire', 'open', 'job', 'role', 'opportunity', 'work with', 'recruit', 'looking'])) {
      return "Yes! Manohar is currently open to Senior Flutter Developer and Lead Flutter roles. He's open to remote and India-based positions. Reach out via the Contact section!";
    }
    if (_matches(q, ['location', 'where', 'country', 'india', 'remote', 'based'])) {
      return "Manohar is based in India and is open to remote work worldwide. He's worked with international clients across South Asia and beyond.";
    }
    if (_matches(q, ['contact', 'email', 'reach', 'message', 'talk', 'connect'])) {
      return "You can reach Manohar at:\n📧 manohar.thullimalli09@gmail.com\n\nOr use the Contact form at the bottom of this page — he typically responds within 24 hours.";
    }
    if (_matches(q, ['resume', 'cv', 'download', 'pdf'])) {
      return "You can download Manohar's resume using the 'Download Resume' button in the Contact section at the bottom of this page!";
    }
    if (_matches(q, ['github', 'code', 'open source', 'repository', 'repo'])) {
      return "Manohar's GitHub: github.com/manoharthullimalli09-flutter-coder\n\nThis portfolio app itself is open source — built with Flutter, BLoC, and Clean Architecture!";
    }
    if (_matches(q, ['linkedin', 'profile', 'social'])) {
      return "Connect with Manohar on LinkedIn:\nlinkedin.com/in/manohar-t-68a32231a";
    }
    if (_matches(q, ['flutter', 'dart', 'cross platform', 'mobile'])) {
      return "Flutter is Manohar's primary technology. He's been building with it since early versions, shipping apps on all 6 platforms (Android, iOS, Web, macOS, Windows, Linux) from a single codebase.";
    }
    if (_matches(q, ['bloc', 'state management', 'riverpod', 'provider', 'getx'])) {
      return "Manohar's preferred state management is BLoC/Cubit — used across all his enterprise projects. He's also proficient in Riverpod (88%), Provider (85%), and GetX (80%).";
    }
    if (_matches(q, ['firebase', 'backend', 'api', 'database'])) {
      return "Manohar has extensive Firebase experience (Auth, Firestore, FCM, Cloud Functions) and works with REST APIs via Dio, WebSockets for real-time features, and has GraphQL experience too.";
    }
    if (_matches(q, ['architecture', 'clean', 'solid', 'pattern', 'design'])) {
      return "Manohar follows Clean Architecture with strict SOLID principles — separating Presentation, Domain, and Data layers. Every project has BLoC for state, UseCases for business logic, and Repository pattern for data.";
    }
    if (_matches(q, ['test', 'testing', 'tdd', 'unit test', 'quality'])) {
      return "Manohar practices TDD and writes unit, widget, and integration tests. This portfolio app has 67 passing tests with full CI/CD on GitHub Actions — tests run before every deployment.";
    }
    if (_matches(q, ['salary', 'rate', 'cost', 'price', 'ctc', 'pay'])) {
      return "For salary/rate details, please reach out directly at manohar.thullimalli09@gmail.com — Manohar is happy to discuss based on the role and company.";
    }
    if (_matches(q, ['playstore', 'play store', 'app store', 'publish', 'released', 'live'])) {
      return "Yes! Manohar has published apps on both Google Play Store and Apple App Store. He handles the full release pipeline including signing, ProGuard, App Store Connect, and CI/CD automation.";
    }
    if (_matches(q, ['thank', 'thanks', 'awesome', 'great', 'nice', 'cool', 'good'])) {
      return "Thank you! 😊 Feel free to ask anything else, or reach out to Manohar directly — he'd love to hear from you!";
    }

    return "Great question! I don't have a specific answer for that, but you can ask Manohar directly at manohar.thullimalli09@gmail.com — or try asking about his experience, skills, projects, or availability! 😊";
  }

  bool _matches(String input, List<String> keywords) =>
      keywords.any((k) => input.contains(k));

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Chat window
        ScaleTransition(
          scale: _scaleAnim,
          alignment: Alignment.bottomRight,
          child: _isOpen ? _ChatWindow(
            messages: _messages,
            controller: _controller,
            scrollController: _scrollController,
            onSend: _send,
            onClose: _toggle,
          ) : const SizedBox.shrink(),
        ),

        // FAB
        GestureDetector(
          onTap: _toggle,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isOpen ? Icons.close_rounded : Icons.chat_rounded,
                key: ValueKey(_isOpen),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatWindow extends StatelessWidget {
  final List<_ChatMessage> messages;
  final TextEditingController controller;
  final ScrollController scrollController;
  final VoidCallback onSend;
  final VoidCallback onClose;

  const _ChatWindow({
    required this.messages,
    required this.controller,
    required this.scrollController,
    required this.onSend,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 440,
      margin: const EdgeInsets.only(bottom: 72),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusLg),
                topRight: Radius.circular(AppSizes.radiusLg),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white24,
                  child: Text('MT', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: AppSizes.sm),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manohar\'s Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Ask me anything!', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSizes.sm),
              itemCount: messages.length,
              itemBuilder: (_, i) => _BubbleWidget(message: messages[i]),
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => onSend(),
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Ask something...',
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: AppSizes.xs,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.xs),
                GestureDetector(
                  onTap: onSend,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleWidget extends StatelessWidget {
  final _ChatMessage message;
  const _BubbleWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: const BoxConstraints(maxWidth: 240),
        decoration: BoxDecoration(
          color: message.isBot ? AppColors.surfaceVariant : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(message.isBot ? 2 : 12),
            bottomRight: Radius.circular(message.isBot ? 12 : 2),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isBot ? AppColors.textPrimary : Colors.white,
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isBot;
  _ChatMessage({required this.text, required this.isBot});
}
