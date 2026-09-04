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

    if (_matches(q, ['hello', 'hi ', 'hey', 'greet', 'good morning', 'good evening'])) {
      return "Hello! 👋 I'm here to tell you all about Manohar. Ask about his experience, the teams he's led, his stack, or the apps he's shipped.";
    }
    if (_matches(q, ['available', 'hire', 'hiring', 'job', 'role', 'opportunity', 'recruit', 'looking for', 'notice period'])) {
      return "Yes — Manohar is open to Senior / Lead Flutter Engineer roles.\n\nHe's based in Hyderabad and open to remote, hybrid, and relocation. Drop him a note via the Contact form below, or email manohar.thullimalli09@gmail.com.";
    }
    if (_matches(q, ['company', 'companies', 'employer', 'worked at', 'work at', 'currently', 'brane', 'eclature', 'marami', 'codeprism', 'career', 'history'])) {
      return "Career so far:\n\n• Brane Enterprises — Senior Flutter Engineer (Lead), AI Applications · 2025–Present\n• Eclature Technologies — Senior Flutter Engineer / Frontend Team Lead · 2024–2025\n• Marami Infotech — Flutter Developer → Team Lead · 2023–2024\n• CodePrism Technologies — Junior Flutter Developer · 2021–2023\n\nAsk about any one of them for the details.";
    }
    if (_matches(q, ['lead', 'leadership', 'team', 'manage', 'mentor', 'how many engineers'])) {
      return "Manohar leads frontend teams — most recently a team of 6 Flutter engineers at Brane Enterprises, and a team of 6 at Eclature before that.\n\nHe owns architecture decisions, code review standards, estimation, release timelines, and mentoring, and works directly with clients to turn requirements into technical designs.";
    }
    if (_matches(q, ['experience', 'years', 'how long', 'senior', 'background', 'summary', 'about'])) {
      return "5+ years of production Flutter and Dart, currently Senior Flutter Engineer (Lead) at Brane Enterprises in Hyderabad.\n\nHe's shipped cross-platform apps across AI, healthcare, fintech, real estate, EdTech, and wellness — including a meditation platform that reached 1M+ global downloads — and has led frontend teams of up to 6 engineers.";
    }
    if (_matches(q, ['migration', 'migrate', 'native', 'kotlin', 'swift', 'java', 'add-to-app', 'add to app', 'platform channel', 'legacy'])) {
      return "Native integration and migration is one of Manohar's strongest areas:\n\n• Migrated a portfolio of live native Android apps (Kotlin/Java) to Flutter incrementally via add-to-app — screens went out without pausing releases\n• Re-architected a live production app from Provider to BLoC + Clean Architecture while the team kept shipping\n• Platform channels (MethodChannel, EventChannel), Pigeon, native SDK bridging, background services\n• Bridged native audio capture in Kotlin and Swift for an on-device voice assistant";
    }
    if (_matches(q, ['ai', 'voice', 'vad', 'llm', 'assistant', 'server-driven', 'server driven'])) {
      return "At Brane Enterprises, Manohar builds AI-powered mobile apps:\n\n• A custom AI voice assistant using on-device Voice Activity Detection, bridging native audio capture through Kotlin and Swift platform channels\n• A server-driven UI engine with dynamic widget serialisation, so product teams ship UI changes without an app store release\n• A Dio networking layer with interceptors for retry, error normalisation, and secure token refresh";
    }
    if (_matches(q, ['skill', 'tech', 'stack', 'technology', 'expertise', 'know'])) {
      return "Core stack:\n• Flutter & Dart — mobile, web, desktop\n• State: BLoC/Cubit, Provider, MVVM\n• Architecture: Clean Architecture, SOLID, GetIt DI, go_router, repository pattern, dartz Either\n• Networking: REST, Dio, WebSockets, Socket.IO, WebRTC, OAuth 2.0\n• Backend: Firebase (Auth, Firestore, FCM, Crashlytics, Remote Config), AWS, SQLite, Hive\n• Native: Kotlin, Java, Swift, platform channels, Pigeon, add-to-app\n• Testing: unit, widget, integration, bloc_test, mocktail\n• CI/CD: GitHub Actions, GitLab CI, Bitbucket Pipelines, Azure DevOps, Codemagic, Fastlane\n\nOther languages: Kotlin, Java, Swift, C, C++, Python, JavaScript, SQL.";
    }
    if (_matches(q, ['project', 'built', 'app', 'portfolio', 'showcase', 'shipped'])) {
      return "Shipped apps featured on this page:\n\n• HeartInTune — Heartfulness meditation platform, 1M+ downloads\n• Sampangi — real estate discovery & listings\n• My Elegant Group — premium property showcase\n• Aduri Infra — infrastructure & project updates\n• Maa Bhoomi — land records & plot discovery\n• HR Productivity Dashboard — web + desktop HR suite\n\nAt Marami he delivered 10+ production real estate apps to Play Store and App Store in a single year, and was named Employee of the Year. Scroll up for full details.";
    }
    if (_matches(q, ['performance', 'fps', 'optimis', 'optimiz', 'fast', 'memory', 'startup', 'isolate', 'concurrency'])) {
      return "Performance is a specialty:\n\n• Cut cold start time and eliminated frame drops on audio streaming and playlist screens using Flutter DevTools profiling and widget rebuild reduction\n• Dart concurrency — Isolates, Streams, Futures, async/await, the event loop\n• Memory-leak detection, 60/120 FPS rendering, app size and startup optimisation, lazy loading";
    }
    if (_matches(q, ['location', 'where', 'city', 'country', 'india', 'remote', 'based', 'relocat', 'hyderabad'])) {
      return "Manohar is based in Hyderabad, Telangana, India 🇮🇳\n\nHe's open to remote work worldwide, hybrid, and relocation, and has delivered for globally distributed teams and international markets.";
    }
    if (_matches(q, ['contact', 'email', 'reach', 'phone', 'call', 'number', 'talk', 'connect'])) {
      return "You can reach Manohar at:\n📧 manohar.thullimalli09@gmail.com\n📱 +91 63035 39396\n\nOr use the Contact form at the bottom of this page — he typically responds within 24 hours.";
    }
    if (_matches(q, ['resume', 'cv', 'download', 'pdf'])) {
      return "Grab the full resume with the 'Download Resume' button in the Contact section below — it covers the full role history, the native migration work, and the complete skills breakdown.";
    }
    if (_matches(q, ['github', 'open source', 'repository', 'repo', 'source code'])) {
      return "Manohar's GitHub: github.com/manoharthullimalli09-flutter-coder\n\nThis portfolio is open source and is itself the demo — one Flutter codebase running on Web, Android, iOS, macOS, Windows, and Linux, on Clean Architecture with BLoC, get_it, go_router, and dartz.";
    }
    if (_matches(q, ['linkedin', 'social', 'profile'])) {
      return "Connect with Manohar on LinkedIn:\nlinkedin.com/in/manohar-t-68a32231a";
    }
    if (_matches(q, ['education', 'degree', 'college', 'university', 'study', 'graduate', 'b.tech', 'btech'])) {
      return "B.Tech in Computer Science & Engineering from Eluru College of Engineering and Technology, Andhra Pradesh (2018–2021).\n\nHe started in ReactJS at CodePrism and moved to Flutter, which has been his primary technology ever since.";
    }
    if (_matches(q, ['language', 'speak', 'telugu', 'hindi', 'english', 'tamil'])) {
      return "Languages Manohar speaks:\n• Telugu — native\n• English — professional\n• Hindi — conversational\n• Tamil — basic";
    }
    if (_matches(q, ['flutter', 'dart', 'cross platform', 'cross-platform', 'mobile'])) {
      return "Flutter is Manohar's primary technology — 5+ years of production work with it, shipping from a single codebase to Android, iOS, Web, macOS, Windows, and Linux.\n\nHe also works natively in Kotlin, Java, and Swift, which is what makes the hybrid add-to-app migrations possible.";
    }
    if (_matches(q, ['bloc', 'state management', 'cubit', 'provider', 'riverpod', 'getx'])) {
      return "BLoC/Cubit is Manohar's default, paired with Clean Architecture and GetIt dependency injection.\n\nHe led a full Provider → BLoC migration on a live production app at Brane, re-architecting it onto Clean Architecture with go_router navigation while the team kept shipping features — which cut state-related production defects.";
    }
    if (_matches(q, ['firebase', 'backend', 'api', 'database', 'websocket', 'realtime', 'real-time', 'webrtc'])) {
      return "Backend and real-time work:\n\n• Firebase — Auth, Firestore, Cloud Messaging, Crashlytics, Analytics, Remote Config, App Distribution\n• REST APIs via Dio with interceptors, retry, and secure token refresh\n• WebSockets and Socket.IO for live features; WebRTC video consultation on a telemedicine platform\n• Offline-first sync with SQLite, Hive, and SharedPreferences";
    }
    if (_matches(q, ['architecture', 'clean', 'solid', 'pattern', 'design', 'scalab'])) {
      return "Manohar builds on Clean Architecture with strict SOLID separation of Presentation, Domain, and Data.\n\nBLoC for state, UseCases for business logic, repository pattern for data, GetIt for injection, and typed functional error handling with dartz Either — so feature modules stay independently unit-testable. He's also built feature-first modular and server-driven UI architectures.";
    }
    if (_matches(q, ['test', 'testing', 'tdd', 'quality', 'coverage'])) {
      return "Manohar writes unit, widget, and integration tests with bloc_test and mocktail, and wires them into CI as a release quality gate.\n\nThis portfolio has 84 passing tests with zero analyzer issues — the GitHub Actions pipeline runs analyze and test, and a failure blocks the deploy.";
    }
    if (_matches(q, ['ci', 'cd', 'devops', 'pipeline', 'deploy', 'fastlane', 'codemagic'])) {
      return "CI/CD is something he owns end to end:\n\n• GitHub Actions, GitLab CI, Bitbucket Pipelines, Azure DevOps, Codemagic, Fastlane\n• Automated build, test, and release pipelines with test execution as a quality gate\n• Build flavors and environment config, code signing, provisioning profiles, phased rollouts\n• Google Play Console, App Store Connect, TestFlight";
    }
    if (_matches(q, ['payment', 'razorpay', 'stripe', 'maps', 'google maps', 'location api', 'integration'])) {
      return "Integrations he's shipped:\n\n• Razorpay payment flows for property booking, including signature verification and failure/retry handling\n• Google Maps SDK and Places API with custom filtering, geospatial querying, and location-based search\n• Push notifications (FCM, APNs), deep linking, and AI/LLM API integration";
    }
    if (_matches(q, ['salary', 'rate', 'ctc', 'pay', 'compensation', 'package'])) {
      return "For compensation, reach out directly at manohar.thullimalli09@gmail.com — Manohar is happy to discuss based on the role, scope, and company.";
    }
    if (_matches(q, ['playstore', 'play store', 'app store', 'publish', 'released', 'live', 'download'])) {
      return "Yes — Manohar has published to both Google Play and the App Store, and owns the full release pipeline: code signing, provisioning profiles, phased rollouts, and store review compliance.\n\nThe meditation platform he contributed to reached 1M+ global downloads, and he shipped 10+ production real estate apps to both stores in a single year.";
    }
    if (_matches(q, ['thank', 'thanks', 'awesome', 'great', 'nice', 'cool', 'perfect'])) {
      return "Thank you! 😊 Ask anything else, or reach out to Manohar directly — he'd love to hear from you!";
    }

    return "I don't have a specific answer for that one, but you can ask Manohar directly at manohar.thullimalli09@gmail.com.\n\nTry asking about his experience, the teams he's led, native migration work, his stack, the apps he's shipped, or whether he's available! 😊";
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
