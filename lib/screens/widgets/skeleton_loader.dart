import 'package:flutter/material.dart';

// ── Shimmer skeleton box ──────────────────────────────────────
class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.radius = 8,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
    isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8);
    final shimmerColor =
    isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: Color.lerp(baseColor, shimmerColor, _anim.value),
        ),
      ),
    );
  }
}

// ── Single card skeleton — vertical layout (image top, content below)
class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Full-width image placeholder ──
          const ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            child: SkeletonBox(height: 180, radius: 0),
          ),

          // ── Content ───────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges + date row
                Row(
                  children: [
                    const SkeletonBox(width: 52, height: 20, radius: 5),
                    const SizedBox(width: 6),
                    const SkeletonBox(width: 72, height: 20, radius: 5),
                    const Spacer(),
                    const SkeletonBox(width: 48, height: 12, radius: 4),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                const SkeletonBox(height: 15, radius: 6),
                const SizedBox(height: 5),
                const SkeletonBox(width: 160, height: 15, radius: 6),
                const SizedBox(height: 10),

                // Location
                Row(
                  children: [
                    const SkeletonBox(width: 14, height: 14, radius: 7),
                    const SizedBox(width: 5),
                    const SkeletonBox(width: 120, height: 12, radius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Full feed skeleton ────────────────────────────────────────
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) => const PostCardSkeleton(),
    );
  }
}