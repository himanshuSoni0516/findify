import 'package:flutter/material.dart';

import '../home_screen.dart';
import '../profile_screen.dart';
import 'glass_nav_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  // Defined on the widget class — never changes, no reason to live in State
  static const _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Feed',
    ),
    NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  // IndexedStack keeps all screens mounted (good for preserving scroll state).
  // If a screen becomes expensive to build, switch to a lazy approach instead.
  static const _screens = [HomeScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _screens),
          Positioned(
            left: 30,
            right: 30,
            bottom: bottomPad + 10,
            child: GlassNavBar(
              currentIndex: _index,
              items: MainShell._navItems,
              onTap: (i) => setState(() => _index = i),
            ),
          ),
        ],
      ),
    );
  }
}
