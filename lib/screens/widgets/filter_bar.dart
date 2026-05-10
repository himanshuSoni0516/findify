import 'package:findify/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();
    final filters = ['all', 'lost', 'found', 'resolved'];
    final labels = {
      'all': 'All',
      'lost': 'Lost',
      'found': 'Found',
      'resolved': 'Resolved',
    };
    final icons = {
      'all': Icons.grid_view_rounded,
      'lost': Icons.search_off_rounded,
      'found': Icons.check_circle_outline_rounded,
      'resolved': Icons.task_alt_rounded,
    };
    final colors = {
      'all': AppTheme.primary,
      'lost': AppTheme.lostColor,
      'found': AppTheme.foundColor,
      'resolved': AppTheme.primary,
    };

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          children: filters.map((f) {
            final isActive = ctrl.selectedFilter.value == f;
            final color = colors[f]!;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  ctrl.selectedFilter.value = f;
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.withOpacity(0.15)
                        : Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive
                          ? color
                          : Colors.grey.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[f],
                        size: 20,
                        color: isActive ? color : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        labels[f]!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isActive
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isActive
                              ? (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : color)
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
