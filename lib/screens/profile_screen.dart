import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import '../core/app_theme.dart';
import '../models/post_model.dart';
import 'post_detail_screen.dart';
import 'widgets/my_post_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final postCtrl = Get.find<PostController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.background(context)),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [

              // ── Header ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Text(
                        'My Profile',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight
                            .w600),
                      ),
                      const Spacer(),
                      _LogoutButton(authCtrl: authCtrl),
                    ],
                  ),
                ),
              ),

              // ── Avatar + Info card ───────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  final user = authCtrl.currentUser.value;
                  final initial = (user?.name.isNotEmpty == true)
                      ? user!.name.trim().substring(0, 1).toUpperCase()
                      : '?';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 75,
                            height: 75,
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Name + details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                if (user?.course != null && user!.course!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.school_outlined,
                                          size: 18, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${user.course} · Sem ${user.semester ?? ''}',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors
                                              .grey[500]),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.phone_outlined,
                                          size: 18, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          user.phone!,
                                          style: TextStyle(
                                              fontSize: 14, color: Colors
                                              .grey[500]),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              // ── Stats row ────────────────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  final user = authCtrl.currentUser.value;
                  final myPosts = _getMyPosts(postCtrl.posts, user?.id);
                  final active = myPosts.where((p) => !p.isResolved).length;
                  final resolved = myPosts.where((p) => p.isResolved).length;

                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        _StatCard(
                          label: 'Total',
                          value: myPosts.length.toString(),
                          color: Colors.blueAccent,
                          icon: Icons.grid_view_outlined,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Active',
                          value: active.toString(),
                          color: AppTheme.lostColor,
                          icon: Icons.radio_button_checked_rounded,
                        ),
                        const SizedBox(width: 10),
                        _StatCard(
                          label: 'Resolved',
                          value: resolved.toString(),
                          color: AppTheme.foundColor,
                          icon: Icons.check_circle_outline_rounded,
                        ),
                      ],
                    ),
                  );
                }),
              ),

              // ── My Posts header ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  child: Row(
                    children: [
                      const Text(
                        'My Posts',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight
                            .w500),
                      ),
                      const Spacer(),
                      Obx(() {
                        final count = _getMyPosts(
                            postCtrl.posts, authCtrl.currentUser.value?.id)
                            .length;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count posts',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),


              // ── Posts list ───────────────────────────────────
              Obx(() {
                final myPosts = _getMyPosts(
                    postCtrl.posts, authCtrl.currentUser.value?.id);

                if (postCtrl.isLoading.value) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(
                          child: CircularProgressIndicator(color: AppTheme.primary)),
                    ),
                  );
                }

                if (myPosts.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.post_add_rounded,
                                size: 34, color: Colors.grey[350]),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            "No posts yet",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Your lost & found posts will appear here",
                            style:
                            TextStyle(fontSize: 13, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: MyPostCard(
                        post: myPosts[i],
                        onTap: () => Get.to(
                              () => const PostDetailScreen(),
                          arguments: myPosts[i],
                        ),
                        onDelete: () =>
                            _confirmDelete(myPosts[i], postCtrl),
                        onMarkResolved: myPosts[i].isResolved
                            ? null
                            : () => _confirmResolve(myPosts[i], postCtrl),
                      ),
                    ),
                    childCount: myPosts.length,
                  ),
                );
              }),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  List<PostModel> _getMyPosts(List<PostModel> all, String? userId) {
    if (userId == null) return [];
    return all.where((p) => p.userId == userId).toList();
  }

  void _confirmDelete(PostModel post, PostController ctrl) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Post?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:
            const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lostColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16));
    }
  }

  void _confirmResolve(PostModel post, PostController ctrl) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Mark as Resolved?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
        const Text('This lets others know the item was recovered.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:
            const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.foundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.foundColor,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16));
    }
  }
}

// ── Extracted widgets ────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: color,
                height: 1,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final AuthController authCtrl;

  const _LogoutButton({required this.authCtrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmLogout(authCtrl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.lostColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border:
          Border.all(color: AppTheme.lostColor.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout_rounded, size: 15, color: AppTheme.lostColor),
            const SizedBox(width: 6),
            Text(
              'Log Out',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.lostColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(AuthController auth) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
        const Text('You will be returned to the login screen.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child:
            const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lostColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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