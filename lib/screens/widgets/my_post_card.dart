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
    isLost ? const Color(0xFFFF6B6B) : const Color(0xFF51CF66);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
              borderRadius: BorderRadius.circular(10),
              child: post.imageUrl != null
                  ? Image.network(
                post.imageUrl!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(typeColor),
              )
                  : _placeholder(typeColor),
            ),
            const SizedBox(width: 14),

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
                        _badge('RESOLVED', Colors.grey),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(post.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
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
              icon: Icon(Icons.more_vert, color: Colors.grey[400]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                          color: Color(0xFF51CF66), size: 18),
                      SizedBox(width: 10),
                      Text('Mark resolved'),
                    ]),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete_outline,
                        color: Color(0xFFFF6B6B), size: 18),
                    SizedBox(width: 10),
                    Text('Delete',
                        style: TextStyle(color: Color(0xFFFF6B6B))),
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
    width: 64,
    height: 64,
    color: color.withOpacity(0.08),
    child:
    Icon(Icons.inventory_2_outlined, color: color.withOpacity(0.5)),
  );

  Widget _badge(String label, Color color) => Container(
    padding:
    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(label,
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.3)),
  );
}