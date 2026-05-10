import 'dart:ui';

import 'package:findify/screens/about_screen.dart';
import 'package:findify/screens/widgets/glass_nav_bar.dart';
import 'package:findify/screens/widgets/main_shell.dart';
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
        Get.put(NotificationController());
      }),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        GetPage(
          name: '/signup',
          page: () => const SignupScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        GetPage(
          name: '/home',
          page: () => const MainShell(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 250),
          binding: BindingsBuilder(() {
            Get.lazyPut<PostController>(() => PostController());
          }),
        ),
        GetPage(
          name: '/post-detail',
          page: () => const PostDetailScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        GetPage(
          name: '/about',
          page: () => const AboutScreen(),
          transition: Transition.rightToLeftWithFade,
          transitionDuration: const Duration(milliseconds: 250),
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 250),
        ),
      ],
    );
  }
}
