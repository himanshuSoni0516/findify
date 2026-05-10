import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launch(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open link',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.background(context)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroHeader(isDark: isDark),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('About'),
                    const SizedBox(height: 8),
                    _Card(
                      child: Text(
                        'Findify helps college students report and discover lost & found items on campus — fast, simple, and community-driven. Post a lost item, browse recent finds, and reunite belongings with their owners.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.65,
                          color: isDark
                              ? Colors.white70
                              : Colors.black.withOpacity(0.65),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _SectionLabel('Built with'),
                    const SizedBox(height: 8),
                    _Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _TechItem(
                                icon: Icons.phone_android_rounded,
                                label: 'Flutter',
                                sub: 'Frontend',
                                color: const Color(0xFF54C5F8),
                              ),
                              const SizedBox(width: 10),
                              _TechItem(
                                icon: Icons.bolt_rounded,
                                label: 'GetX',
                                sub: 'State',
                                color: const Color(0xFFAB85F5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _TechItem(
                                icon: Icons.cloud_rounded,
                                label: 'Supabase',
                                sub: 'Backend',
                                color: const Color(0xFF3ECF8E),
                              ),
                              const SizedBox(width: 10),
                              _TechItem(
                                icon: Icons.storage_rounded,
                                label: 'PostgreSQL',
                                sub: 'Database',
                                color: const Color(0xFF336791),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _SectionLabel('Key Features'),
                    const SizedBox(height: 8),
                    _Card(
                      child: Column(
                        children: const [
                          _FeatureRow(
                            icon: Icons.add_photo_alternate_outlined,
                            text: 'Post lost & found items with photos',
                          ),
                          _FeatureRow(
                            icon: Icons.search_rounded,
                            text: 'Search & filter by category',
                          ),
                          _FeatureRow(
                            icon: Icons.notifications_none_rounded,
                            text: 'Real-time notifications',
                          ),
                          _FeatureRow(
                            icon: Icons.dark_mode_outlined,
                            text: 'Light & dark theme support',
                          ),
                          _FeatureRow(
                            icon: Icons.lock_outline_rounded,
                            text: 'Secure auth via Supabase JWT',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _SectionLabel('Designed & Developed by'),
                    const SizedBox(height: 8),
                    _DeveloperCard(
                      initials: 'HS',
                      name: 'Himanshu Soni',
                      role: 'BCA Final Year',
                      email: 'himanshusoni0516@gmail.com',
                      linkedin: 'https://www.linkedin.com/in/himanshusoni0516/',
                      github: 'https://github.com/himanshuSoni0516',
                      onLaunch: _launch,
                    ),
                    const SizedBox(height: 10),
                    _DeveloperCard(
                      initials: 'MS',
                      name: 'Meet Swarnkar',
                      role: 'BCA Final Year',
                      email: 'meetswarnkar@gmail.com',
                      linkedin: 'https://www.linkedin.com/in/meetswarnkar/',
                      github: 'https://github.com/meetswarnkar',
                      onLaunch: _launch,
                    ),
                    const SizedBox(height: 28),

                    Center(
                      child: Text(
                        'Made with ❤️ at college',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── All subwidgets below are unchanged ────────────────────────

class _HeroHeader extends StatelessWidget {
  final bool isDark;
  const _HeroHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withOpacity(isDark ? 0.35 : 0.18),
            const Color(0xFF90D46C).withOpacity(isDark ? 0.2 : 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withOpacity(0.6),
                  const Color(0xFF90D46C).withOpacity(0.6),
                ],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/Findify_rounded_logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Findify',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Lost & Found — College Edition',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary.withOpacity(0.15),
                  const Color(0xFF90D46C).withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
            ),
            child: const Text(
              'v1.0.0 · Flutter',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, Color(0xFF90D46C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white60
                : Colors.black45,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TechItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;

  const _TechItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.12 : 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;

  const _FeatureRow({
    required this.icon,
    required this.text,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ],
        ),
        if (!isLast)
          Divider(
            height: 20,
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
          ),
      ],
    );
  }
}

class _DeveloperCard extends StatelessWidget {
  final String initials;
  final String name;
  final String role;
  final String? email;
  final String? linkedin;
  final String? github;
  final void Function(String) onLaunch;

  const _DeveloperCard({
    required this.initials,
    required this.name,
    required this.role,
    this.email,
    this.linkedin,
    this.github,
    required this.onLaunch,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasLinks = email != null || linkedin != null || github != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.07),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, Color(0xFF90D46C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.white,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      role,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (hasLinks) ...[
            const SizedBox(height: 14),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.white.withOpacity(0.07)
                  : Colors.black.withOpacity(0.07),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (email != null)
                  _LinkChip(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    onTap: () => onLaunch('mailto:$email'),
                  ),
                if (email != null && linkedin != null) const SizedBox(width: 8),
                if (linkedin != null)
                  _LinkChip(
                    icon: Icons.link_rounded,
                    label: 'LinkedIn',
                    onTap: () => onLaunch(linkedin!),
                  ),
                if (linkedin != null && github != null)
                  const SizedBox(width: 8),
                if (github != null)
                  _LinkChip(
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    onTap: () => onLaunch(github!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _LinkChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
