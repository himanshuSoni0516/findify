// glass_nav_bar.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class GlassNavBar extends StatefulWidget {
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  }) : assert(items.length >= 2, 'GlassNavBar requires at least 2 items');

  @override
  State<GlassNavBar> createState() => _GlassNavBarState();
}

class _GlassNavBarState extends State<GlassNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  double get _normalizedIndex => widget.items.length > 1
      ? widget.currentIndex / (widget.items.length - 1)
      : 0.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: _normalizedIndex,
    );
  }

  @override
  void didUpdateWidget(GlassNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _ctrl.animateTo(_normalizedIndex, curve: Curves.easeInOutCubic);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? const Color(0xFF0D1F15).withValues(alpha: 0.22)
        : Colors.white.withValues(alpha: 0.18);

    final borderColor = isDark
        ? const Color(0xFF2A6040).withValues(alpha: 0.12)
        : const Color(0xFF1A7A45).withValues(alpha: 0.06);

    final activeGreen = isDark
        ? const Color(0xFF3DBF72)
        : const Color(0xFF1A8A4A);

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: bgColor,
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.30)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 24,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.04)
                    : Colors.white.withValues(alpha: 0.50),
                blurRadius: 0,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final pillW = constraints.maxWidth / widget.items.length;
                  final slideX = _ctrl.value * (constraints.maxWidth - pillW);

                  return Stack(
                    children: [
                      Positioned(
                        left: slideX,
                        top: 0,
                        width: pillW,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: isDark
                                ? const Color(
                                    0xFF3DBF72,
                                  ).withValues(alpha: 0.09)
                                : const Color(
                                    0xFF1A8A4A,
                                  ).withValues(alpha: 0.07),
                            border: Border.all(
                              color: isDark
                                  ? const Color(
                                      0xFF3DBF72,
                                    ).withValues(alpha: 0.08)
                                  : const Color(
                                      0xFF1A8A4A,
                                    ).withValues(alpha: 0.07),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: List.generate(widget.items.length, (i) {
                          return Expanded(
                            child: _NavPill(
                              item: widget.items[i],
                              isActive: i == widget.currentIndex,
                              isDark: isDark,
                              activeColor: activeGreen,
                              onTap: () {
                                HapticFeedback.lightImpact();
                                widget.onTap(i);
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final bool isDark;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavPill({
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.22)
        : Colors.black.withValues(alpha: 0.18);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: ScaleTransition(scale: anim, child: child),
                ),
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  key: ValueKey('${item.label}_$isActive'),
                  color: isActive ? activeColor : inactiveColor,
                  size: 22,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 220),
                  style: TextStyle(
                    color: isActive ? activeColor : inactiveColor,
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'Fredoka',
                    letterSpacing: 0.2,
                  ),
                  child: Text(item.label),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
