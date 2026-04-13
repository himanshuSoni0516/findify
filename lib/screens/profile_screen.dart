import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import '../models/post_model.dart';
import 'post_detail_screen.dart';
import 'widgets/my_post_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final postCtrl = Get.find<PostController>();
    final user = authCtrl.currentUser.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Profile header ────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    // Back button + title
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 16),
                        const Text('My Profile',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                      const Color(0xFF4F46E5).withOpacity(0.1),
                      child: Text(
                        user?.name.isNotEmpty == true
                            ? user!.name.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(user?.name ?? 'Unknown',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),

                    if (user?.course != null &&
                        user!.course!.isNotEmpty)
                      Text(
                        '${user.course} · ${user.semester ?? ''}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[500]),
                      ),

                    if (user?.phone != null && user!.phone!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(user.phone!,
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[500])),
                      ),

                    const SizedBox(height: 20),

                    // Stats row
                    Obx(() {
                      final myPosts = _getMyPosts(
                          postCtrl.posts, authCtrl.currentUser.value?.id);
                      final active =
                          myPosts.where((p) => !p.isResolved).length;
                      final resolved =
                          myPosts.where((p) => p.isResolved).length;

                      return Row(
                        children: [
                          _statBox('Total', myPosts.length.toString()),
                          _divider(),
                          _statBox('Active', active.toString(),
                              color: const Color(0xFF4F46E5)),
                          _divider(),
                          _statBox('Resolved', resolved.toString(),
                              color: const Color(0xFF51CF66)),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmLogout(authCtrl),
                        icon: const Icon(Icons.logout_rounded,
                            size: 18, color: Color(0xFFFF6B6B)),
                        label: const Text('Log Out',
                            style: TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFFF6B6B), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── My Posts section ──────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: [
                    const Text('My Posts',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Obx(() {
                      final count = _getMyPosts(postCtrl.posts,
                          authCtrl.currentUser.value?.id)
                          .length;
                      return Text('$count posts',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[500]));
                    }),
                  ],
                ),
              ),
            ),

            Obx(() {
              final myPosts = _getMyPosts(
                  postCtrl.posts, authCtrl.currentUser.value?.id);

              if (postCtrl.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(
                          color: Color(0xFF4F46E5)),
                    ),
                  ),
                );
              }

              if (myPosts.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.post_add_rounded,
                              size: 52, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text("You haven't posted anything yet",
                              style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (_, i) {
                    final post = myPosts[i];
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                      child: MyPostCard(
                        post: post,
                        onTap: () => Get.to(
                              () => const PostDetailScreen(),
                          arguments: post,
                        ),
                        onDelete: () => _confirmDelete(post, postCtrl),
                        onMarkResolved: post.isResolved
                            ? null
                            : () => _confirmResolve(post, postCtrl),
                      ),
                    );
                  },
                  childCount: myPosts.length,
                ),
              );
            }),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  List<PostModel> _getMyPosts(List<PostModel> all, String? userId) {
    if (userId == null) return [];
    return all.where((p) => p.userId == userId).toList();
  }

  Widget _statBox(String label, String value, {Color? color}) =>
      Expanded(
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.black)),
            const SizedBox(height: 2),
            Text(label,
                style:
                TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      );

  Widget _divider() => Container(
      width: 1, height: 32, color: Colors.grey.shade200);

  void _confirmDelete(PostModel post, PostController ctrl) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Post?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ctrl.deletePost(post.id);
      Get.snackbar('Deleted', 'Post removed',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    }
  }

  void _confirmResolve(PostModel post, PostController ctrl) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Mark as Resolved?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
        const Text('This lets others know the item was recovered.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF51CF66),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Confirm',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ctrl.markResolved(post.id);
      Get.snackbar('Done!', 'Marked as resolved',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF51CF66),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16));
    }
  }

  void _confirmLogout(AuthController auth) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('You will be returned to the login screen.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Log Out',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) auth.signOut();
  }
}