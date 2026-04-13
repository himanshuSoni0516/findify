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
      'all': const Color(0xFF4F46E5),
      'lost': const Color(0xFFFF6B6B),
      'found': const Color(0xFF51CF66),
    };

    return Obx(() => Row(
      children: filters.map((f) {
        final isActive = ctrl.selectedFilter.value == f;
        final color = colors[f]!;
        return GestureDetector(
          onTap: () => ctrl.selectedFilter.value = f,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? color : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? color : Colors.grey.shade200,
              ),
            ),
            child: Text(
              labels[f]!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}