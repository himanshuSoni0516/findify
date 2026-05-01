import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_theme.dart';

// ── Nav item model ────────────────────────────────────────────
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

// ── Static nav bar ────────────────────────────────────────────
class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final List<NavItem> items;
  final ValueChanged<int> onTap;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? const Color(0xFF1C1B2E)
        : const Color(0xFFFFFFFF);

    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.07);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: bgColor,
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.35)
                : Colors.black.withOpacity(0.07),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max, // stretch to fill Positioned width
        children: List.generate(items.length, (i) {
          return Expanded(  // each pill gets equal share
            child: _NavPill(
              item: items[i],
              isActive: i == currentIndex,
              isDark: isDark,
              onTap: () {
                HapticFeedback.lightImpact();
                onTap(i);
              },
            ),
          );
        }),
      ),
    );
  }
}

// ── Single pill ───────────────────────────────────────────────
class _NavPill extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavPill({
    super.key,
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.primary;

    final inactiveColor = isDark
        ? Colors.white.withOpacity(0.35)
        : Colors.black.withOpacity(0.28);

    final activeBg = isDark
        ? AppTheme.primary.withOpacity(0.18)
        : AppTheme.primary.withOpacity(0.12);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: isActive ? activeBg : Colors.transparent,
        ),
        // Center the icon+label inside the equal-width cell
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
                    fontSize: 13,
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