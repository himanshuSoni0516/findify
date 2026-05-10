import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';
import '../core/constants.dart';
import '../core/storage_service.dart';
import '../models/post_model.dart';
import '../models/post_image_model.dart';

class PostController extends GetxController {
  final posts = <PostModel>[].obs;
  final filteredPosts = <PostModel>[].obs;
  final isLoading = false.obs;
  final isUploading = false.obs;
  final errorMessage = ''.obs;

  // Filter state
  final selectedFilter = 'all'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    ever(selectedFilter, (_) => _applyFilters());
    ever(searchQuery, (_) => _applyFilters());
    ever(posts, (_) => _applyFilters());
  }

  // ── Fetch all posts ──────────────────────────────────────
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

  // ── Fetch extra images for a post ────────────────────────
  // Call this in the post detail screen to load additional images
  Future<List<PostImageModel>> fetchPostImages(String postId) async {
    try {
      final res = await ApiClient.get(
        '${AppConstants.postImagesUrl}?post_id=eq.$postId&order=order.asc',
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => PostImageModel.fromJson(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  // ── Apply filter + search ────────────────────────────────
  void _applyFilters() {
    var result = posts.toList();

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
      default:
        break;
    }

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

  // ── Upload single image to Supabase Storage ──────────────
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

  // ── Delete single image from Storage ────────────────────
  Future<void> _deleteImage(String imageUrl) async {
    try {
      final filePath = imageUrl.replaceFirst(
        '${AppConstants.storagePublicUrl}/',
        '',
      );
      final deleteUrl = '${AppConstants.storageUrl}/$filePath';
      final token = await StorageService.getToken();
      await http.delete(
        Uri.parse(deleteUrl),
        headers: {
          'apikey': AppConstants.supabaseAnonKey,
          'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {}
  }

  // ── Create new post with multiple images ─────────────────
  Future<bool> createPost({
    required String title,
    required String description,
    required String type,
    required String location,
    List<File> imageFiles = const [], // <-- was File? imageFile
    required String userId,
  }) async {
    isUploading.value = true;
    errorMessage.value = '';

    try {
      // 1. Upload all images, collect URLs
      final List<String> uploadedUrls = [];
      for (final file in imageFiles) {
        final url = await uploadImage(file, userId);
        if (url == null) return false; // stop if any upload fails
        uploadedUrls.add(url);
      }

      // 2. First URL = cover image stored directly in posts table
      //    (keeps backward compatibility with existing posts)
      final coverUrl = uploadedUrls.isNotEmpty ? uploadedUrls.first : null;

      // 3. Create the post row
      //    IMPORTANT: add 'Prefer: return=representation' so Supabase
      //    returns the created row including its auto-generated id
      final res = await ApiClient.post(
        AppConstants.postsUrl,
        {
          'user_id': userId,
          'title': title,
          'description': description,
          'type': type,
          'location': location,
          'image_url': coverUrl,
          'is_resolved': false,
        },
        requiresAuth: true,
        // Make sure your ApiClient.post passes this header,
        // or add it manually — see note below
        extraHeaders: {'Prefer': 'return=representation'},
      );

      if (res.statusCode != 201) {
        final data = jsonDecode(res.body);
        errorMessage.value = data['message'] ?? 'Failed to create post';
        return false;
      }

      // 4. Get the new post's id from the response
      final List responseData = jsonDecode(res.body);
      final newPostId = responseData[0]['id'] as String;

      // 5. Insert extra images (index 1 onwards) into post_images table
      final extraUrls = uploadedUrls.skip(1).toList();
      for (int i = 0; i < extraUrls.length; i++) {
        await ApiClient.post(AppConstants.postImagesUrl, {
          'post_id': newPostId,
          'image_url': extraUrls[i],
          'order': i, // 0-based order among extra images
        }, requiresAuth: true);
      }

      await fetchPosts();
      return true;
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
      final idx = posts.indexWhere((p) => p.id == postId);
      if (idx != -1) {
        posts[idx] = posts[idx].copyWith(isResolved: true);
      }
    } catch (e) {
      errorMessage.value = 'Could not update post';
    }
  }

  // ── Delete post + all its images ─────────────────────────
  Future<void> deletePost(String postId) async {
    try {
      final post = posts.firstWhereOrNull((p) => p.id == postId);

      // 1. Fetch extra images before deleting so we can clean Storage
      final extraImages = await fetchPostImages(postId);

      // 2. Delete post row (CASCADE will delete post_images rows too)
      await ApiClient.delete('${AppConstants.postsUrl}?id=eq.$postId');

      // 3. Remove from local list immediately
      posts.removeWhere((p) => p.id == postId);

      // 4. Delete cover image from Storage
      if (post?.imageUrl != null && post!.imageUrl!.isNotEmpty) {
        await _deleteImage(post.imageUrl!);
      }

      // 5. Delete extra images from Storage
      for (final img in extraImages) {
        await _deleteImage(img.imageUrl);
      }
    } catch (e) {
      errorMessage.value = 'Could not delete post';
    }
  }
}
