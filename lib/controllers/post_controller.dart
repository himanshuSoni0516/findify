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
  final selectedFilter = 'all'.obs; // 'all', 'lost', 'found', 'resolved'
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
    switch (selectedFilter.value) {
      case 'lost':
        result = result
            .where((p) => p.type == 'lost' && !p.isResolved)
            .toList();
        break;
      case 'found':
        result = result
            .where((p) => p.type == 'found' && !p.isResolved)
            .toList();
        break;
      case 'resolved':
        result = result.where((p) => p.isResolved).toList();
        break;
      case 'all':
      default:
        break;
    }

    // Search filter
    final q = searchQuery.value.toLowerCase();
    if (q.isNotEmpty) {
      result = result
          .where(
            (p) =>
                p.title.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q) ||
                p.location.toLowerCase().contains(q),
          )
          .toList();
    }

    filteredPosts.value = result;
  }

  // ── Upload image to Supabase Storage ─────────────────────
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final token = await StorageService.getToken();
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
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

  // ── Delete image from Supabase Storage ───────────────────
  // Extracts the file path from the public URL and calls the
  // Storage delete endpoint so the bucket stays clean.
  Future<void> _deleteImage(String imageUrl) async {
    try {
      // imageUrl looks like:
      //   https://xxx.supabase.co/storage/v1/object/public/posts/userId/timestamp.jpg
      // storagePublicUrl looks like:
      //   https://xxx.supabase.co/storage/v1/object/public/posts
      //
      // Stripping the prefix gives us: userId/timestamp.jpg
      final filePath = imageUrl.replaceFirst(
        '${AppConstants.storagePublicUrl}/',
        '',
      );

      // Storage delete endpoint:
      //   DELETE /storage/v1/object/{bucket}/{filePath}
      // storageUrl looks like:
      //   https://xxx.supabase.co/storage/v1/object/posts
      final deleteUrl = '${AppConstants.storageUrl}/$filePath';

      final token = await StorageService.getToken();

      await http.delete(
        Uri.parse(deleteUrl),
        headers: {
          'apikey': AppConstants.supabaseAnonKey,
          'Authorization': 'Bearer $token',
        },
      );
      // We don't throw on storage delete failure — the post
      // row delete still proceeds. Worst case: orphaned image.
    } catch (_) {
      // Silent — storage cleanup is best-effort
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

      if (imageFile != null) {
        imageUrl = await uploadImage(imageFile, userId);
        if (imageUrl == null) return false;
      }

      final res = await ApiClient.post(AppConstants.postsUrl, {
        'user_id': userId,
        'title': title,
        'description': description,
        'type': type,
        'location': location,
        'image_url': imageUrl,
        'is_resolved': false,
      }, requiresAuth: true);

      if (res.statusCode == 201) {
        await fetchPosts();
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
      await ApiClient.patch('${AppConstants.postsUrl}?id=eq.$postId', {
        'is_resolved': true,
      });
      // Update locally — avoids a full network round trip
      final idx = posts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        posts[idx] = posts[idx].copyWith(isResolved: true);
      }
    } catch (e) {
      errorMessage.value = 'Could not update post';
    }
  }

  // ── Delete post ──────────────────────────────────────────
  Future<void> deletePost(String postId) async {
    try {
      // 1. Find the post so we can grab its imageUrl before removing it
      final post = posts.firstWhereOrNull((p) => p.id == postId);

      // 2. Delete the database row
      await ApiClient.delete('${AppConstants.postsUrl}?id=eq.$postId');

      // 3. Remove from local list immediately (optimistic UI)
      posts.removeWhere((p) => p.id == postId);

      // 4. Delete image from Storage if one exists
      if (post?.imageUrl != null && post!.imageUrl!.isNotEmpty) {
        await _deleteImage(post.imageUrl!);
      }
    } catch (e) {
      errorMessage.value = 'Could not delete post';
    }
  }
}
