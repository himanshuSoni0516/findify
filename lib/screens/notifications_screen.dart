import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';
import '../controllers/post_controller.dart';
import '../core/app_theme.dart';
import '../models/notification_model.dart';
import 'post_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl    = Get.find<NotificationController>();
    final postCtrl = Get.find<PostController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.grey),
                  ),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  // Mark all read button
                  Obx(() => ctrl.unreadCount.value > 0
                      ? TextButton(
                    onPressed: ctrl.markAllAsRead,
                    child: const Text(
                      'Mark all read',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primary),
                    ),
                  )
                      : const SizedBox()),
                ],
              ),
            ),

            // ── List ─────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value &&
                    ctrl.notifications.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppTheme.primary),
                  );
                }

                if (ctrl.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none_rounded,
                            size: 60,
                            color: Colors.grey[300]),
                        const SizedBox(height: 14),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 15),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'You\'ll be notified when someone posts',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: ctrl.fetchNotifications,
                  color: AppTheme.primary,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12),
                    itemCount: ctrl.notifications.length,
                    itemBuilder: (_, i) {
                      final notif = ctrl.notifications[i];
                      return _NotifCard(
                        notif: notif,
                        onTap: () async {
                          // 1. Mark as read
                          if (!notif.isRead) {
                            await ctrl.markAsRead(notif.id);
                          }

                          // 2. Find the post and navigate
                          final post = postCtrl.posts
                              .firstWhereOrNull(
                                  (p) => p.id == notif.postId);

                          if (post != null) {
                            Get.to(
                                  () => const PostDetailScreen(),
                              arguments: post,
                            );
                          } else {
                            // Post might not be loaded yet — fetch and retry
                            await postCtrl.fetchPosts();
                            final freshPost = postCtrl.posts
                                .firstWhereOrNull(
                                    (p) => p.id == notif.postId);
                            if (freshPost != null) {
                              Get.to(
                                    () => const PostDetailScreen(),
                                arguments: freshPost,
                              );
                            } else {
                              Get.snackbar(
                                'Not found',
                                'This post may have been deleted',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Individual notification card ──────────────────────────────
class _NotifCard extends StatelessWidget {
  final NotificationModel notif;
  final VoidCallback onTap;

  const _NotifCard({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLost  = notif.title.contains('Lost');
    final dotColor = isLost ? AppTheme.lostColor : AppTheme.foundColor;
    final cardColor = Theme.of(context).cardColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: notif.isRead
              ? cardColor
              : AppTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notif.isRead
                ? Theme.of(context).dividerColor
                : AppTheme.primary.withOpacity(0.2),
            width: notif.isRead ? 1 : 1.5,
          ),
          boxShadow: notif.isRead
              ? []
              : [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: dotColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLost
                      ? Icons.search_rounded
                      : Icons.volunteer_activism_rounded,
                  color: dotColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Unread blue dot
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notif.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _timeAgo(notif.createdAt),
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Arrow
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.grey[500], size: 25),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    if (diff.inDays < 7)     return '${diff.inDays}d ago';
    final months = ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}