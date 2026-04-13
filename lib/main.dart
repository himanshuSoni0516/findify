import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/post_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const FindifyApp());
}

class FindifyApp extends StatelessWidget {
  const FindifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Findify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(PostController());
      }),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash',      page: () => const SplashScreen()),
        GetPage(name: '/login',       page: () => const LoginScreen()),
        GetPage(name: '/signup',      page: () => const SignupScreen()),
        GetPage(name: '/home',        page: () => const MainShell()),
        GetPage(name: '/post-detail', page: () => const PostDetailScreen()),
      ],
    );
  }
}

// ── Bottom nav shell — wraps Home + Profile ─────────────────
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF4F46E5).withOpacity(0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded,
                color: Color(0xFF4F46E5)),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded,
                color: Color(0xFF4F46E5)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}