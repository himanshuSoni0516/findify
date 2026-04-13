import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';
import '../core/constants.dart';
import '../core/storage_service.dart';
import '../models/post_model.dart';

class PostController extends GetxController {
  final posts = <PostModel>[].obs;
  final filteredPosts = <PostModel>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final errorMessage = ''.obs;

  // Filter state
  final selectedFilter = 'all'.obs; // 'all', 'lost', 'found'
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    // Auto-filter whenever filter or search changes
    ever(selectedFilter, (_) => _applyFilters());
    ever(searchQuery, (_) => _applyFilters());
    ever(posts, (_) => _applyFilters());
  }

  // ── Fetch all posts (newest first) ───────────────────────
  Future<void> fetchPosts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await ApiClient.get(
        '${AppConstants.postsUrl}?order=created_at.desc',
        extraHeaders: {'Prefer': 'return=representation'},
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        posts.value = data.map((e) => PostModel.fromJson(e)).toList();
      } else {
        errorMessage.value = 'Failed to load posts';
      }
    } catch (e) {
      errorMessage.value = 'Check your connection';
    } finally {
      isLoading.value = false;
    }
  }

  // ── Apply filter + search ────────────────────────────────
  void _applyFilters() {
    var result = posts.toList();

    // Type filter
    if (selectedFilter.value != 'all') {
      result = result
          .where((p) => p.type == selectedFilter.value)
          .toList();
    }

    // Search filter
    final q = searchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where((p) =>
      p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.location.toLowerCase().contains(q))
          .toList();
    }

    filteredPosts.value = result;
  }

  // ── Upload image to Supabase Storage ─────────────────────
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final token = await StorageService.getToken();
      final fileName =
          '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final uploadUrl = '${AppConstants.storageUrl}/$fileName';

      final bytes = await imageFile.readAsBytes();

      final res = await http.post(
        Uri.parse(uploadUrl),
        headers: {
          'apikey': AppConstants.supabaseAnonKey,
          'Authorization': 'Bearer $token',
          'Content-Type': 'image/jpeg',
        },
        body: bytes,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Return the public URL
        return '${AppConstants.storagePublicUrl}/$fileName';
      } else {
        errorMessage.value = 'Image upload failed';
        return null;
      }
    } catch (e) {
      errorMessage.value = 'Image upload error';
      return null;
    }
  }

  // ── Create new post ──────────────────────────────────────
  Future<bool> createPost({
    required String title,
    required String description,
    required String type,
    required String location,
    File? imageFile,
    required String userId,
  }) async {
    isUploading.value = true;
    errorMessage.value = '';
    try {
      String? imageUrl;

      // Upload image first if provided
      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile, userId);
        if (imageUrl == null) return false;
      }

      final res = await ApiClient.post(
        AppConstants.postsUrl,
        {
          'user_id': userId,
          'title': title,
          'description': description,
          'type': type,
          'location': location,
          'image_url': imageUrl,
          'is_resolved': false,
        },
        requiresAuth: true,
      );

      if (res.statusCode == 201) {
        await fetchPosts(); // Refresh feed
        return true;
      } else {
        final data = jsonDecode(res.body);
        errorMessage.value = data['message'] ?? 'Failed to create post';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong';
      return false;
    } finally {
      isUploading.value = false;
    }
  }

  // ── Mark post as resolved ────────────────────────────────
  Future<void> markResolved(String postId) async {
    try {
      await ApiClient.patch(
        '${AppConstants.postsUrl}?id=eq.$postId',
        {'is_resolved': true},
      );
      await fetchPosts();
    } catch (e) {
      errorMessage.value = 'Could not update post';
    }
  }

  // ── Delete post ──────────────────────────────────────────
  Future<void> deletePost(String postId) async {
    try {
      await ApiClient.delete('${AppConstants.postsUrl}?id=eq.$postId');
      posts.removeWhere((p) => p.id == postId);
    } catch (e) {
      errorMessage.value = 'Could not delete post';
    }
  }
}