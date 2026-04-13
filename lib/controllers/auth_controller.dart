import 'dart:convert';
import 'package:get/get.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../core/storage_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // ── Sign Up ──────────────────────────────────────────────
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String? course,
    String? semester,
    String? phone,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // 1. Create auth user
      final authRes = await ApiClient.post(
        AppConstants.signUpUrl,
        {'email': email, 'password': password},
      );

      final authData = jsonDecode(authRes.body);

      if (authRes.statusCode != 200) {
        errorMessage.value = authData['msg'] ?? 'Signup failed';
        return;
      }

      final userId = authData['user']['id'];
      final token = authData['access_token'];

      // 2. Save token immediately so next call works
      await StorageService.saveToken(token);
      await StorageService.saveUserId(userId);

      // 3. Insert profile row
      final profileRes = await ApiClient.post(
        AppConstants.profilesUrl,
        {
          'id': userId,
          'name': name,
          'course': course ?? '',
          'semester': semester ?? '',
          'phone': phone ?? '',
        },
        requiresAuth: true,
      );

      if (profileRes.statusCode != 201) {
        errorMessage.value = 'Profile creation failed';
        return;
      }

      currentUser.value = UserModel(
        id: userId,
        email: email,
        name: name,
        course: course,
        semester: semester,
        phone: phone,
      );

      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = 'Something went wrong. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Sign In ──────────────────────────────────────────────
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await ApiClient.post(
        AppConstants.signInUrl,
        {'email': email, 'password': password},
      );

      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        errorMessage.value = data['error_description'] ?? 'Login failed';
        return;
      }

      final token = data['access_token'];
      final userId = data['user']['id'];

      await StorageService.saveToken(token);
      await StorageService.saveUserId(userId);

      // Fetch profile
      await _loadProfile(userId);

      Get.offAllNamed('/home');
    } catch (e) {
      errorMessage.value = 'Something went wrong. Check your connection.';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Load profile from DB ─────────────────────────────────
  Future<void> _loadProfile(String userId) async {
    final res = await ApiClient.get(
      '${AppConstants.profilesUrl}?id=eq.$userId',
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data.isNotEmpty) {
        final token = await StorageService.getToken();
        currentUser.value = UserModel.fromJson({
          ...data[0],
          'email': '', // not stored in profiles table
        });
      }
    }
  }

  // ── Sign Out ─────────────────────────────────────────────
  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await ApiClient.post(AppConstants.signOutUrl, {}, requiresAuth: true);
    } finally {
      await StorageService.clearAll();
      currentUser.value = null;
      isLoading.value = false;
      Get.offAllNamed('/login');
    }
  }

  // ── Auto-login check ─────────────────────────────────────
  Future<bool> isLoggedIn() async {
    final token = await StorageService.getToken();
    return token != null && token.isNotEmpty;
  }
}