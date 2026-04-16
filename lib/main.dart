import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/post_controller.dart';
import 'core/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/post_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

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
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: BindingsBuilder(() {
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
      ],
    );
  }
}

// ── Bottom nav shell with notification badge ─────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    // NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final notifCtrl = Get.find<NotificationController>();

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Obx(() {
        final unread = notifCtrl.unreadCount.value;
        return NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon:
              Icon(Icons.home_rounded, color: AppTheme.primary),
              label: 'Feed',
            ),
            // NavigationDestination(
            //   icon: Badge(
            //     isLabelVisible: unread > 0,
            //     label: Text(
            //       unread > 9 ? '9+' : '$unread',
            //       style: const TextStyle(fontSize: 10),
            //     ),
            //     child: const Icon(Icons.notifications_outlined),
            //   ),
            //   selectedIcon: Badge(
            //     isLabelVisible: unread > 0,
            //     label: Text(
            //       unread > 9 ? '9+' : '$unread',
            //       style: const TextStyle(fontSize: 10),
            //     ),
            //     child: const Icon(Icons.notifications_rounded,
            //         color: AppTheme.primary),
            //   ),
            //   label: 'Notifications',
            // ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon:
              Icon(Icons.person_rounded, color: AppTheme.primary),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}