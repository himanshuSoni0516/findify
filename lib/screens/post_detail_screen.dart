import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/post_model.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final post = Get.arguments as PostModel;
  final authCtrl = Get.find<AuthController>();
  final postCtrl = Get.find<PostController>();

  // Owner profile fetched from DB
  Map<String, dynamic>? ownerProfile;
  bool loadingOwner = true;

  @override
  void initState() {
    super.initState();
    _fetchOwnerProfile();
  }

  Future<void> _fetchOwnerProfile() async {
    try {
      final res = await ApiClient.get(
        '${AppConstants.profilesUrl}?id=eq.${post.userId}',
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data.isNotEmpty) {
          setState(() => ownerProfile = data[0]);
        }
      }
    } catch (_) {} finally {
      setState(() => loadingOwner = false);
    }
  }

  bool get isOwner =>
      authCtrl.currentUser.value?.id == post.userId;

  @override
  Widget build(BuildContext context) {
    final isLost = post.type == 'lost';
    final typeColor =
    isLost ? const Color(0xFFFF6B6B) : const Color(0xFF51CF66);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App bar with image ──────────────────────────
          SliverAppBar(
            expandedHeight: post.imageUrl != null ? 280 : 120,
            pinned: true,
            backgroundColor: Colors.white,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: post.imageUrl != null
                  ? Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[100],
                  child: const Icon(Icons.image_not_supported,
                      size: 48, color: Colors.grey),
                ),
              )
                  : Container(
                color: typeColor.withOpacity(0.08),
                child: Center(
                  child: Icon(
                    isLost
                        ? Icons.search_rounded
                        : Icons.volunteer_activism_rounded,
                    size: 72,
                    color: typeColor.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges row
                  Row(
                    children: [
                      _badge(
                        isLost ? 'LOST' : 'FOUND',
                        typeColor,
                      ),
                      if (post.isResolved) ...[
                        const SizedBox(width: 8),
                        _badge('RESOLVED', Colors.grey),
                      ],
                      const Spacer(),
                      Text(
                        _formatDate(post.createdAt),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Location chip
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 16, color: typeColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post.location,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description card
                  if (post.description.isNotEmpty) ...[
                    _sectionTitle('Description'),
                    _card(
                      child: Text(
                        post.description,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Contact / Owner info ────────────────
                  _sectionTitle(isOwner ? 'Your Post' : 'Contact Owner'),
                  _card(
                    child: loadingOwner
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            color: Color(0xFF4F46E5)),
                      ),
                    )
                        : ownerProfile == null
                        ? Text('Owner info not available',
                        style: TextStyle(color: Colors.grey[500]))
                        : Column(
                      children: [
                        // Name + course
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(
                                  0xFF4F46E5)
                                  .withOpacity(0.1),
                              child: Text(
                                (ownerProfile!['name'] as String)
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4F46E5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ownerProfile!['name'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  if (ownerProfile!['course'] !=
                                      null &&
                                      (ownerProfile!['course'] as String)
                                          .isNotEmpty)
                                    Text(
                                      '${ownerProfile!['course']} · ${ownerProfile!['semester'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500]),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Phone (only show if not your own post)
                        if (!isOwner &&
                            ownerProfile!['phone'] != null &&
                            (ownerProfile!['phone'] as String)
                                .isNotEmpty) ...[
                          const Divider(height: 24),
                          _contactRow(
                            icon: Icons.phone_rounded,
                            label: ownerProfile!['phone'],
                            color: const Color(0xFF51CF66),
                            onTap: () => _copyToClipboard(
                                ownerProfile!['phone'],
                                'Phone number copied'),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Owner actions ───────────────────────
                  if (isOwner) ...[
                    if (!post.isResolved)
                      _actionButton(
                        label: 'Mark as Resolved ✓',
                        color: const Color(0xFF51CF66),
                        onTap: _markResolved,
                      ),
                    const SizedBox(height: 12),
                    _actionButton(
                      label: 'Delete Post',
                      color: const Color(0xFFFF6B6B),
                      outlined: true,
                      onTap: _confirmDelete,
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar('Copied', message,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2));
  }

  void _markResolved() async {
    final confirm = await _showConfirmDialog(
      title: 'Mark as Resolved?',
      message: 'This will let others know the item has been recovered.',
      confirmLabel: 'Yes, mark resolved',
      confirmColor: const Color(0xFF51CF66),
    );
    if (confirm == true) {
      await postCtrl.markResolved(post.id);
      Get.back();
      Get.snackbar('Done!', 'Post marked as resolved',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF51CF66),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16));
    }
  }

  void _confirmDelete() async {
    final confirm = await _showConfirmDialog(
      title: 'Delete Post?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: const Color(0xFFFF6B6B),
    );
    if (confirm == true) {
      await postCtrl.deletePost(post.id);
      Get.back();
      Get.snackbar('Deleted', 'Your post has been removed',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    }
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(confirmLabel,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w700)),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2)),
      ],
    ),
    child: child,
  );

  Widget _badge(String label, Color color) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5)),
  );

  Widget _contactRow({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.copy_rounded, size: 16, color: Colors.grey[400]),
          ],
        ),
      );

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool outlined = false,
  }) =>
      SizedBox(
        width: double.infinity,
        height: 50,
        child: outlined
            ? OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color, width: 1.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600)),
        )
            : ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ),
      );

  String _formatDate(DateTime date) {
    final months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}