import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import 'add_post_screen.dart';
import 'widgets/filter_bar.dart';
import 'widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postCtrl = Get.find<PostController>();
    final authCtrl = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        'Hey, ${authCtrl.currentUser.value?.name.split(' ').first ?? 'there'} 👋',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      Text('Find what you\'re looking for',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[500])),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => authCtrl.signOut(),
                    icon: const Icon(Icons.logout_rounded),
                    tooltip: 'Logout',
                  ),
                ],
              ),
            ),

            // ── Search bar ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  onChanged: (v) => postCtrl.searchQuery.value = v,
                  decoration: InputDecoration(
                    hintText: 'Search by title, keyword, location...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon:
                    Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Filter bar ───────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft, child: FilterBar()),
            ),
            const SizedBox(height: 16),

            // ── Post list ────────────────────────────────
            Expanded(
              child: Obx(() {
                if (postCtrl.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFF4F46E5)));
                }

                if (postCtrl.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off_rounded,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        Text(postCtrl.errorMessage.value,
                            style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: postCtrl.fetchPosts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (postCtrl.filteredPosts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded,
                            size: 56, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          postCtrl.searchQuery.value.isNotEmpty
                              ? 'No posts match your search'
                              : 'No posts yet. Be the first!',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: postCtrl.fetchPosts,
                  color: const Color(0xFF4F46E5),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: postCtrl.filteredPosts.length,
                    itemBuilder: (_, i) {
                      final post = postCtrl.filteredPosts[i];
                      return PostCard(
                        post: post,
                        onTap: () => Get.toNamed('/post-detail',
                            arguments: post),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      // ── FAB — Add post ───────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Get.to(() => const AddPostScreen());
          if (created == true) {
            Get.snackbar(
              'Posted!',
              'Your item has been added to the feed',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF51CF66),
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          }
        },
        backgroundColor: const Color(0xFF4F46E5),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Post',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}