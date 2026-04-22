import 'package:findify/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/post_controller.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<PostController>();
    final filters = ['all', 'lost', 'found'];
    final labels = {'all': 'All', 'lost': 'Lost', 'found': 'Found'};
    final colors = {
      'all': AppTheme.primary,
      'lost': AppTheme.lostColor,
      'found': AppTheme.foundColor,
    };

    return Obx(() => Row(
      children: filters.map((f) {
        final isActive = ctrl.selectedFilter.value == f;
        final color = colors[f]!;
        return GestureDetector(
          onTap: () => ctrl.selectedFilter.value = f,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 10),
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? color : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? color : Colors.transparent,
              ),
            ),
            child: Text(
              labels[f]!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}