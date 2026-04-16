import 'package:findify/screens/widgets/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/notification_controller.dart';
import '../controllers/post_controller.dart';
import '../core/app_theme.dart';
import 'add_post_screen.dart';
import 'notifications_screen.dart';
import 'widgets/filter_bar.dart';
import 'widgets/post_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final postCtrl = Get.find<PostController>();
    final authCtrl = Get.find<AuthController>();
    postCtrl.fetchPosts();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────
            Padding(
              padding:
              const EdgeInsets.all(12),
              child: Row(
                children: [
                  Image.asset("assets/Findify_rounded_logo.png",height: 40,),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        'Hi, ${authCtrl.currentUser.value?.name.split(' ')
                            .first ?? 'there'} 👋',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                      Text('Find what you\'re looking for',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[500])),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Obx(() {
                        final notifCtrl = Get.find<NotificationController>();
                        final unread = notifCtrl.unreadCount.value;

                        return IconButton(
                          onPressed: () {
                            Get.to(() => const NotificationsScreen());
                          },
                          icon: Badge(
                            isLabelVisible: unread > 0,
                            label: Text(
                              unread > 9 ? '9+' : '$unread',
                              style: const TextStyle(fontSize: 10),
                            ),
                            child: const Icon(Icons.notifications_none_outlined,
                              size: 30,),
                          ),
                          tooltip: 'Notifications',
                        );
                      }),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () => (),
                        icon: const Icon(Icons.dark_mode_outlined, size: 30),
                        tooltip: 'Theme switch',
                      ),
                    ],
                  )
                ],
              ),
            ),

            // ── Search bar ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                onChanged: (v) => postCtrl.searchQuery.value = v,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.3),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.35)
                        : Colors.black.withOpacity(0.35),
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Filter bar ───────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft, child: FilterBar()),
            ),
            const SizedBox(height: 12),

            // ── Post list ────────────────────────────────
            Expanded(
              child: Obx(() {
                if (postCtrl.isLoading.value) {
                  return const FeedSkeleton();
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
                  color: AppTheme.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
      floatingActionButton: _GradientFAB(
        onPressed: () async {
          final created = await Get.to(() => const AddPostScreen());
          if (created == true) {
            Get.find<NotificationController>().fetchNotifications();
            Get.snackbar(
              'Posted!',
              'Your item has been added to the feed',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppTheme.foundColor,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          }
        },
      ),
    );
  }
}
class _GradientFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final List<Color> colors;

  const _GradientFAB({
    required this.onPressed,
    this.label = 'Add Post',
    this.icon = Icons.add,
    this.colors = const [Color(0xFF4898AB), Color(0xFF90D46C)],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}