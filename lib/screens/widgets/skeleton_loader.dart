import 'package:flutter/material.dart';

// ── Shared skeleton color helpers ─────────────────────────────
Color _skeletonBase(bool isDark) =>
    isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8);

Color _skeletonShimmer(bool isDark) =>
    isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

Color _cardBorderColor(bool isDark) => isDark
    ? Colors.white.withValues(alpha: 0.06)
    : Colors.black.withValues(alpha: 0.06);

Color _cardShadowColor(bool isDark) => isDark
    ? Colors.black.withValues(alpha: 0.18)
    : Colors.black.withValues(alpha: 0.06);

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

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: Color.lerp(
            _skeletonBase(isDark),
            _skeletonShimmer(isDark),
            _anim.value,
          ),
        ),
      ),
    );
  }
}

// ── PostCard skeleton — vertical layout (image top, content below) ──
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
        border: Border.all(color: _cardBorderColor(isDark), width: 1),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor(isDark),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Full-width image placeholder ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: SkeletonBox(height: 180, radius: 0),
          ),

          // ── Content ──
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badges + date row
                const Row(
                  children: [
                    SkeletonBox(width: 52, height: 20, radius: 5),
                    SizedBox(width: 6),
                    SkeletonBox(width: 72, height: 20, radius: 5),
                    Spacer(),
                    SkeletonBox(width: 48, height: 12, radius: 4),
                  ],
                ),
                const SizedBox(height: 10),

                // Title
                const SkeletonBox(height: 15, radius: 6),
                const SizedBox(height: 5),
                const SkeletonBox(width: 160, height: 15, radius: 6),
                const SizedBox(height: 10),

                // Description
                const SkeletonBox(height: 13, radius: 5),
                const SizedBox(height: 5),
                const SkeletonBox(width: 200, height: 13, radius: 5),
                const SizedBox(height: 10),

                // Location
                const Row(
                  children: [
                    SkeletonBox(width: 14, height: 14, radius: 7),
                    SizedBox(width: 5),
                    SkeletonBox(width: 120, height: 12, radius: 4),
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

// ── MyPostCard skeleton — horizontal layout (thumbnail left, info right) ──
class MyPostCardSkeleton extends StatelessWidget {
  const MyPostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorderColor(isDark), width: 1),
        boxShadow: [
          BoxShadow(
            color: _cardShadowColor(isDark),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Thumbnail placeholder (matches the 75×75 image in MyPostCard) ──
          const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: SkeletonBox(width: 75, height: 75, radius: 8),
          ),
          const SizedBox(width: 5),

          // ── Info column ──
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row (type + optional resolved)
                Row(
                  children: [
                    SkeletonBox(width: 44, height: 18, radius: 2),
                    SizedBox(width: 6),
                    SkeletonBox(width: 66, height: 18, radius: 2),
                  ],
                ),
                SizedBox(height: 8),

                // Title
                SkeletonBox(height: 14, radius: 5),
                SizedBox(height: 5),
                SkeletonBox(width: 100, height: 14, radius: 5),
                SizedBox(height: 6),

                // Location
                SkeletonBox(width: 90, height: 12, radius: 4),
              ],
            ),
          ),

          // ── Three-dot menu placeholder ──
          const Padding(
            padding: EdgeInsets.only(left: 8),
            child: SkeletonBox(width: 20, height: 20, radius: 10),
          ),
        ],
      ),
    );
  }
}

// ── Feed skeleton — pass [style] to switch between card layouts ──
enum FeedSkeletonStyle { postCard, myPostCard }

class FeedSkeleton extends StatelessWidget {
  /// Number of placeholder cards to render.
  final int itemCount;

  /// Which card layout to mimic.
  final FeedSkeletonStyle style;

  const FeedSkeleton({
    super.key,
    this.itemCount = 4,
    this.style = FeedSkeletonStyle.postCard,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, __) => style == FeedSkeletonStyle.myPostCard
          ? const MyPostCardSkeleton()
          : const PostCardSkeleton(),
    );
  }
}
