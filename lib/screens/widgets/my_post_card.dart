import 'package:findify/core/app_theme.dart';
import 'package:flutter/material.dart';
import '../../models/post_model.dart';

class MyPostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onMarkResolved;

  const MyPostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onDelete,
    this.onMarkResolved,
  });

  @override
  Widget build(BuildContext context) {
    final isLost = post.type == 'lost';
    final typeColor =
    isLost ? AppTheme.lostColor : AppTheme.foundColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail or icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: post.imageUrl != null
                  ? Image.network(
                post.imageUrl!,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(typeColor),
              )
                  : _placeholder(typeColor),
            ),
            const SizedBox(width: 5),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _badge(isLost ? 'LOST' : 'FOUND', typeColor),
                      if (post.isResolved) ...[
                        const SizedBox(width: 6),
                        _badge('RESOLVED', Colors.blueAccent),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(post.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(post.location,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),

            // Actions menu
            PopupMenuButton<String>(
              color: Theme.of(context).cardColor,
              elevation: 5,
              icon: Icon(Icons.more_vert, color: Colors.grey[400]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              onSelected: (val) {
                if (val == 'resolve' && onMarkResolved != null) {
                  onMarkResolved!();
                } else if (val == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (_) => [
                if (!post.isResolved)
                  const PopupMenuItem(
                    value: 'resolve',
                    child: Row(children: [
                      Icon(Icons.check_circle_outline,
                          color: AppTheme.foundColor, size: 18),
                      SizedBox(width: 10),
                      Text('Mark resolved'),
                    ]),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_outline,
                        color: AppTheme.lostColor, size: 18),
                    SizedBox(width: 10),
                    Text('Delete',
                        style: TextStyle(color: AppTheme.lostColor)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(Color color) => Container(
    width: 75,
    height: 75,
    color: color.withOpacity(0.08),
    child:
    Icon(Icons.inventory_2_outlined, color: color.withOpacity(0.5)),
  );

  Widget _badge(String label, Color color) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(2),
    ),
    child: Text(label,
        style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: 0.3)),
  );
}