import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackType { success, error, info, warning }

class AppSnackbar {
  static void show({
    required String message,
    SnackType type = SnackType.success,
    String? title,
    IconData? icon,
    Color? color,
  }) {
    final resolvedColor = color ?? _colorFor(type);
    final resolvedIcon = icon ?? _iconFor(type);
    final resolvedDot = _dotColorFor(type);

    Get.snackbar(
      '',
      '',
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            )
          : const SizedBox.shrink(),
      messageText: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(resolvedIcon, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: resolvedDot,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: resolvedColor,
      borderRadius: 14,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      duration: const Duration(milliseconds: 2500),
      animationDuration: const Duration(milliseconds: 220),
      isDismissible: true,
      snackStyle: SnackStyle.FLOATING,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  static Color _colorFor(SnackType type) {
    switch (type) {
      case SnackType.success:
        return const Color(0xFF534AB7);
      case SnackType.error:
        return const Color(0xFFA32D2D);
      case SnackType.warning:
        return const Color(0xFF854F0B);
      case SnackType.info:
        return const Color(0xFF185FA5);
    }
  }

  static Color _dotColorFor(SnackType type) {
    switch (type) {
      case SnackType.success:
        return const Color(0xFFAFA9EC);
      case SnackType.error:
        return const Color(0xFFF09595);
      case SnackType.warning:
        return const Color(0xFFEF9F27);
      case SnackType.info:
        return const Color(0xFF85B7EB);
    }
  }

  static IconData _iconFor(SnackType type) {
    switch (type) {
      case SnackType.success:
        return Icons.check_rounded;
      case SnackType.error:
        return Icons.delete_rounded;
      case SnackType.warning:
        return Icons.warning_rounded;
      case SnackType.info:
        return Icons.info_rounded;
    }
  }
}

// HOW TO USE IN APP -

// // success (default)
// AppSnackbar.show(message: 'Marked as resolved');
//
// // error
// AppSnackbar.show(
// message: 'Post deleted',
// type: SnackType.error,
// );
//
// // warning
// AppSnackbar.show(
// message: 'Please fill all fields',
// type: SnackType.warning,
// );
//
// // info
// AppSnackbar.show(
// message: 'New posts available',
// type: SnackType.info,
// );
//
// // fully custom icon + color
// AppSnackbar.show(
// message: 'Image uploaded',
// icon: Icons.image_rounded,
// color: const Color(0xFF1D9E75),
// );
