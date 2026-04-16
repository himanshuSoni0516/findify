import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../core/storage_service.dart';
import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final notifications   = <NotificationModel>[].obs;
  final isLoading       = false.obs;
  final unreadCount     = 0.obs;

  Timer? _pollTimer;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    _startPolling();         // poll every 15 s for new notifications
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  // ── Fetch all notifications for current user ─────────────
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final res = await ApiClient.get(
        '${AppConstants.notificationsUrl}'
            '?order=created_at.desc'
            '&limit=50',
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        notifications.value =
            data.map((e) => NotificationModel.fromJson(e)).toList();
        _updateUnreadCount();
      }
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }

  // ── Mark a single notification as read ───────────────────
  Future<void> markAsRead(String notificationId) async {
    try {
      await ApiClient.patch(
        '${AppConstants.notificationsUrl}?id=eq.$notificationId',
        {'is_read': true},
      );
      // Update local state immediately — no need to refetch
      final idx =
      notifications.indexWhere((n) => n.id == notificationId);
      if (idx != -1) {
        final old = notifications[idx];
        notifications[idx] = NotificationModel(
          id:        old.id,
          userId:    old.userId,
          postId:    old.postId,
          title:     old.title,
          body:      old.body,
          isRead:    true,
          createdAt: old.createdAt,
        );
        _updateUnreadCount();
      }
    } catch (_) {}
  }

  // ── Mark ALL as read ─────────────────────────────────────
  Future<void> markAllAsRead() async {
    try {
      final userId = await StorageService.getUserId();
      await ApiClient.patch(
        '${AppConstants.notificationsUrl}'
            '?user_id=eq.$userId&is_read=eq.false',
        {'is_read': true},
      );
      // Refresh local list
      await fetchNotifications();
    } catch (_) {}
  }

  void _updateUnreadCount() {
    unreadCount.value =
        notifications.where((n) => !n.isRead).length;
  }

  // ── Poll every 15 seconds for new notifications ──────────
  void _startPolling() {
    _pollTimer = Timer.periodic(
      const Duration(seconds: 15),
          (_) => fetchNotifications(),
    );
  }
}