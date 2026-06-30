import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../injection_container.dart';
import '../../../hero/domain/usecases/download_resume_usecase.dart';
import '../../domain/entities/contact_form_entity.dart';
import '../bloc/contact_bloc.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContactBloc>(),
      child: const _ContactContent(),
    );
  }
}

class _ContactContent extends StatelessWidget {
  const _ContactContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SectionHeader(
          title: 'Contact',
          subtitle:
              'Open to Senior / Lead Flutter roles. Let\'s build something great together.',
        ),
        const SizedBox(height: AppSizes.xxl),
        context.isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: _ContactInfo()),
                  const SizedBox(width: AppSizes.xxl),
                  const Expanded(flex: 6, child: _ContactForm()),
                ],
              )
            : Column(
                children: [
                  _ContactInfo(),
                  const SizedBox(height: AppSizes.xl),
                  const _ContactForm(),
                ],
              ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Work Together",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            "I'm currently open to Senior Flutter Developer and Lead roles. Whether you have a project in mind or just want to connect, drop me a message.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          _ContactTile(
            icon: Icons.mail_outline_rounded,
            label: 'manohar.professional.flutter@gmail.com',
          ),
          const SizedBox(height: AppSizes.md),
          _ContactTile(
            icon: Icons.location_on_outlined,
            label: 'India · Remote Available',
          ),
          const SizedBox(height: AppSizes.xxl),
          const _SocialLinks(),
          const SizedBox(height: AppSizes.md),
          const _DownloadResumeButton(),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ContactTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: AppSizes.md),
        Flexible(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _SocialLinks extends StatelessWidget {
  const _SocialLinks();

  static const _github =
      'https://github.com/manoharthullimalli09-flutter-coder';
  static const _linkedin = 'https://www.linkedin.com/in/manohar-t-68a32231a';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.md,
      runSpacing: AppSizes.sm,
      children: [
        _SocialBtn(icon: Icons.code_rounded, label: 'GitHub', url: _github),
        _SocialBtn(
          icon: Icons.work_outline_rounded,
          label: 'LinkedIn',
          url: _linkedin,
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => launchUrl(Uri.parse(url)),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}

class _DownloadResumeButton extends StatelessWidget {
  const _DownloadResumeButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => sl<DownloadResumeUseCase>().call(NoParams()),
      icon: const Icon(Icons.download_rounded, size: 18),
      label: const Text('Download Resume'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.xl,
          vertical: AppSizes.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        elevation: 0,
      ),
    );
  }
}

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<ContactBloc>().add(
      SubmitContactForm(
        ContactFormEntity(
          name: _name.text.trim(),
          email: _email.text.trim(),
          subject: _subject.text.trim(),
          message: _message.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
      child: GlassCard(
        child: BlocConsumer<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ContactSuccess) {
              _name.clear();
              _email.clear();
              _subject.clear();
              _message.clear();
            }
          },
          builder: (context, state) {
            if (state is ContactSuccess)
              return _SuccessView(
                onReset: () =>
                    context.read<ContactBloc>().add(ResetContactForm()),
              );
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _Field(
                          controller: _name,
                          label: 'Your Name',
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Expanded(
                        child: _Field(
                          controller: _email,
                          label: 'Your Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => v!.isEmpty
                              ? 'Required'
                              : (!v.contains('@') ? 'Invalid email' : null),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.md),
                  _Field(
                    controller: _subject,
                    label: 'Subject',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSizes.md),
                  _Field(
                    controller: _message,
                    label: 'Message',
                    maxLines: 5,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  if (state is ContactError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: state is ContactSubmitting
                          ? null
                          : () => _submit(context),
                      icon: state is ContactSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                        state is ContactSubmitting
                            ? 'Sending...'
                            : 'Send Message',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onReset;
  const _SuccessView({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 64,
        ),
        const SizedBox(height: AppSizes.lg),
        Text("Message sent!", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSizes.sm),
        Text(
          "I'll get back to you soon.",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSizes.xl),
        TextButton(
          onPressed: onReset,
          child: const Text("Send another message"),
        ),
      ],
    );
  }
}
