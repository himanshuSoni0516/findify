import 'dart:ui';

import 'package:findify/screens/about_screen.dart';
import 'package:findify/screens/widgets/glass_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/post_controller.dart';
import 'controllers/theme_controller.dart';
import 'core/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FindifyApp());
}

class FindifyApp extends StatelessWidget {
  const FindifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Findify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: BindingsBuilder(() {
        Get.put(ThemeController());
        Get.put(AuthController());
        Get.put(PostController());
        Get.put(NotificationController());
      }),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash',      page: () => const SplashScreen()),
        GetPage(name: '/login',       page: () => const LoginScreen()),
        GetPage(name: '/signup',      page: () => const SignupScreen()),
        GetPage(name: '/home',        page: () => const MainShell()),
        GetPage(name: '/post-detail', page: () => const PostDetailScreen()),
        GetPage(name: '/about',       page: () => const AboutScreen()),
      ],
    );
  }
}

// ── Main shell ────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    ProfileScreen(),
  ];

  static const _navItems = [
    NavItem(icon: Icons.home_outlined,  activeIcon: Icons.home_rounded,   label: 'Feed'),
    NavItem(icon: Icons.person_outline, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _screens),
          Positioned(
            left: 27,
            right: 27,
            bottom: bottomPad + 10,
            child: GlassNavBar(
              currentIndex: _index,
              items: _navItems,
              onTap: (i) => setState(() => _index = i),
            ),
          ),
        ],
      ),
    );
  }
}