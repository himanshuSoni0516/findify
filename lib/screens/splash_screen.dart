import 'package:findify/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../core/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    final auth = Get.find<AuthController>();

    final hasToken = await auth.isLoggedIn();

    if (!hasToken) {
      Get.offAllNamed('/login');
      return;
    }

    // Token exists but may be expired — try to refresh it
    final refreshed = await auth.refreshSession();

    if (refreshed) {
      Get.offAllNamed('/home');
    } else {
      // Refresh failed (token too old or invalid) — clear stale data
      await StorageService.clearAll();
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.background(context)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Findify_rounded_logo.png", width: 150),
              const SizedBox(height: 24),
              Text(
                'Findify',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lost & Found — College Edition',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 48),
              CircularProgressIndicator(color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }
}