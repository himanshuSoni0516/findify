import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String _type = 'lost';
  File? _pickedImage;
  final _picker = ImagePicker();

  final postCtrl = Get.find<PostController>();
  final authCtrl = Get.find<AuthController>();

  Future<void> _pickImage() async {
    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (result != null) {
      final picked = await _picker.pickImage(
          source: result, maxWidth: 1080, imageQuality: 80);
      if (picked != null) {
        setState(() => _pickedImage = File(picked.path));
      }
    }
  }

  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing field', 'Please enter a title',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }
    if (_locationCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing field', 'Please enter a location',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final userId = authCtrl.currentUser.value?.id ?? '';
    final success = await postCtrl.createPost(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      type: _type,
      location: _locationCtrl.text.trim(),
      imageFile: _pickedImage,
      userId: userId,
    );

    if (success) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('New Post',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type selector ─────────────────────────────
            _label('Type *'),
            Row(
              children: ['lost', 'found'].map((t) {
                final isSelected = _type == t;
                final color = t == 'lost'
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF51CF66);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: t == 'lost' ? 8 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? color : Colors.grey.shade200,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          t == 'lost' ? '🔴  Lost' : '🟢  Found',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Image picker ──────────────────────────────
            _label('Photo (optional)'),
            GestureDetector(
              onTap: _pickImage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _pickedImage != null ? 200 : 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _pickedImage != null
                        ? const Color(0xFF4F46E5)
                        : Colors.grey.shade200,
                    width: _pickedImage != null ? 2 : 1,
                  ),
                ),
                child: _pickedImage != null
                    ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_pickedImage!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _pickedImage = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_rounded,
                        size: 36, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('Tap to add a photo',
                        style: TextStyle(
                            color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Title ─────────────────────────────────────
            _label('Title *'),
            _inputField(
              controller: _titleCtrl,
              hint: 'e.g. Blue water bottle',
            ),
            const SizedBox(height: 16),

            // ── Description ───────────────────────────────
            _label('Description'),
            _inputField(
              controller: _descCtrl,
              hint: 'Add details — color, brand, when/where last seen...',
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // ── Location ──────────────────────────────────
            _label('Location *'),
            _inputField(
              controller: _locationCtrl,
              hint: 'e.g. Library 2nd floor, Canteen',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 32),

            // ── Error ─────────────────────────────────────
            Obx(() => postCtrl.errorMessage.value.isNotEmpty
                ? Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(postCtrl.errorMessage.value,
                  style:
                  TextStyle(color: Colors.red[700], fontSize: 13)),
            )
                : const SizedBox()),

            // ── Submit button ─────────────────────────────
            Obx(() => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: postCtrl.isUploading.value ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: postCtrl.isUploading.value
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Uploading...',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                )
                    : const Text('Post Item',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text,
        style:
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey[400], size: 20)
              : null,
        ),
      ),
    );
  }
}