import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final divider = Theme.of(context).dividerColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
          title: const Text('About Project',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
          ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.background(context)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // ── App header ──────────────────────────────
              const SizedBox(height: 16),
              ClipRRect(
                child: Image.asset('assets/Findify_rounded_logo.png', height:
                100),
              ),
              const SizedBox(height: 12),
              const Text('Findify',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Lost & Found — College Edition',
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: Text('v1.0.0 · Flutter',
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent)),
              ),
              const SizedBox(height: 24),

              // ── About ───────────────────────────────────
              _Section(
                title: 'About the app',
                child: const Text(
                  'Findify helps college students report and discover lost & found items on campus — fast, simple, and community-driven. Post a lost item, browse recent finds, and reunite belongings with their owners.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              // ── Tech stack ──────────────────────────────
              _Section(
                title: 'Tech stack',
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.5,
                  children: const [
                    _TechChip(label: 'Frontend', value: 'Flutter'),
                    _TechChip(label: 'State management', value: 'GetX'),
                    _TechChip(label: 'Backend', value: 'Supabase'),
                    _TechChip(label: 'Database', value: 'PostgreSQL'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Features ────────────────────────────────
              _Section(
                title: 'Key features',
                child: Column(
                  children: const [
                    _FeatureRow('Post lost & found items with photos'),
                    _FeatureRow('Search & filter by category'),
                    _FeatureRow('Real-time notifications'),
                    _FeatureRow('Light & dark theme support'),
                    _FeatureRow('Secure auth via Supabase JWT'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Developer ───────────────────────────────
              _Section(
                title: 'Designed & developed by',
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.primary.withOpacity(0.12),
                          child: const Text('HS',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Himanshu Soni',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('BCA Final Year',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.primary.withOpacity(0.12),
                          child: const Text('MS',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Meet Swarnkar',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600)),
                            Text('BCA Final Year',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(height: 16),
                    // _ContactRow(
                    //   icon: Icons.email_outlined,
                    //   label: 'himanshusoni0516@gmail.com',
                    //   onTap: () => _launch('mailto:himanshusoni0516@gmail.com'),
                    // ),
                    // const SizedBox(height: 8),
                    // _ContactRow(
                    //   icon: Icons.link,
                    //   label: 'linkedin.com/in/himanshusoni0516',
                    //   onTap: () => _launch('https://www.linkedin.com/in/himanshusoni0516/'),
                    // ),
                    // const SizedBox(height: 8),
                    // _ContactRow(
                    //   icon: Icons.code,
                    //   label: 'github.com/himanshuSoni0516',
                    //   onTap: () => _launch('https://github.com/himanshuSoni0516'),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ─────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.6,
                  )),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label, value;
  const _TechChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight
                  .w500)),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(
                color: AppTheme.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactRow({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(width: 10),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppTheme.primary)),
        ],
      ),
    );
  }
}