import 'package:findify/core/app_theme.dart';
import 'package:flutter/material.dart';
import '../../models/post_model.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;

  const PostCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isLost = post.type == 'lost';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (if exists)
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.all( Radius.circular(6)),
                  child: Image.network(
                    post.imageUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[100],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge + resolved badge
                  Row(
                    children: [
                      _badge(
                        isLost ? 'LOST' : 'FOUND',
                        isLost
                            ? AppTheme.lostColor
                            : AppTheme.foundColor,
                      ),
                      if (post.isResolved) ...[
                        const SizedBox(width: 8),
                        _badge('RESOLVED', Colors.blue),
                      ],
                      const Spacer(),
                      Text(
                        _timeAgo(post.createdAt),
                        style:
                        TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Description
                  Text(
                    post.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          post.location,
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey[500]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
            letterSpacing: 0.5),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}