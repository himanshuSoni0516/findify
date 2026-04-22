import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import '../core/api_client.dart';
import '../core/app_theme.dart';
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
    isLost ? AppTheme.lostColor : AppTheme.foundColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            title: Text("Post Details",
              style: TextStyle(fontSize: 20,
                fontWeight: FontWeight.w500),),
            elevation: 0,
            scrolledUnderElevation: 0.5,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),

// ── Image Section ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: post.imageUrl != null
                    ? Image.network(
                  post.imageUrl!,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback(typeColor, isLost),
                )
                    : _imageFallback(typeColor, isLost),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                        _badge('RESOLVED', Colors.blueAccent),
                      ],
                      const Spacer(),
                      Text(
                        _formatDate(post.createdAt),
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),

                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),

                  // Location chip
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 20, color: Colors.red),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post.location,
                          style: TextStyle(
                              fontSize: 20, color: Colors.grey[700]),
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
                            fontSize: 18,
                            color: Colors.grey[800],
                            ),
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
                        child: CircularProgressIndicator(color: AppTheme.primary),
                      ),
                    )
                        : ownerProfile == null
                        ? Text('Owner info not available',
                        style: TextStyle(color: Colors.grey[500]))
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Always show: name + course ──────────
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                              AppTheme.primary.withOpacity(0.1),
                              child: Text(
                                (ownerProfile!['name'] as String)
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ownerProfile!['name'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  if (ownerProfile!['course'] != null &&
                                      (ownerProfile!['course'] as String)
                                          .isNotEmpty)
                                    Text(
                                      '${ownerProfile!['course']} · Sem ${ownerProfile!['semester'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[500]),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // ── Contact details: only for OTHER user's posts ──
                        if (!isOwner) ...[
                          const Divider(height: 28),

                          if (ownerProfile!['phone'] != null &&
                              (ownerProfile!['phone'] as String)
                                  .isNotEmpty) ...[
                            _contactRow(
                              icon: Icons.phone_rounded,
                              label: ownerProfile!['phone'],
                              color: AppTheme.foundColor,
                              onTap: () => _copyToClipboard(
                                  ownerProfile!['phone'],
                                  'Phone number copied'),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // ── "No contact info" fallback ──────────
                          if ((ownerProfile!['phone'] == null ||
                              (ownerProfile!['phone'] as String).isEmpty))
                            Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16, color: Colors.grey[400]),
                                const SizedBox(width: 8),
                                Text(
                                  'Owner has not added contact details',
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                        ],

                        // ── If it IS your post, show a label ─────
                        if (isOwner) ...[
                          const Divider(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_note_rounded,
                                  color: Colors.grey[400], size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'You posted this item',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[400]),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Owner actions ───────────────────────
                  if (isOwner) ...[
                    if (!post.isResolved)
                      _actionButton(
                        label: 'Mark as Resolved ✓',
                        color: AppTheme.foundColor,
                        onTap: _markResolved,
                      ),
                    const SizedBox(height: 12),
                    _actionButton(
                      label: 'Delete Post',
                      color: AppTheme.lostColor,
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

  Widget _imageFallback(Color typeColor, bool isLost) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLost
                ? Icons.search_rounded
                : Icons.volunteer_activism_rounded,
            size: 64,
            color: typeColor.withOpacity(0.35),
          ),
          const SizedBox(height: 5),
          Text(
            isLost ? 'Lost Item' : 'Found Item',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: typeColor.withOpacity(0.4),
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
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2));
  }

  void _markResolved() async {
    final confirm = await _showConfirmDialog(
      title: 'Mark as Resolved?',
      message: 'This will let others know the item has been recovered.',
      confirmLabel: 'Yes, mark resolved',
      confirmColor: AppTheme.foundColor,
    );
    if (confirm == true) {
      await postCtrl.markResolved(post.id);
      Get.back();
      Get.snackbar('Done!', 'Post marked as resolved',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.foundColor,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16));
    }
  }

  void _confirmDelete() async {
    final confirm = await _showConfirmDialog(
      title: 'Delete Post?',
      message: 'This cannot be undone.',
      confirmLabel: 'Delete',
      confirmColor: AppTheme.lostColor,
    );
    if (confirm == true) {
      await postCtrl.deletePost(post.id);
      Get.back();
      Get.snackbar('Deleted', 'Your post has been removed',
          snackPosition: SnackPosition.TOP,
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
            fontSize: 16, fontWeight: FontWeight.w500)),
  );

  Widget _card({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.copy_rounded, size: 20, color: Colors.grey[400]),
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
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w500)),
        )
            : ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
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