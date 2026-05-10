import 'dart:io';
import 'package:findify/screens/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../controllers/post_controller.dart';
import '../core/app_theme.dart';

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

  // Changed: was File? _pickedImage
  final List<File> _pickedImages = [];
  static const int _maxImages = 5;

  final _picker = ImagePicker();
  final postCtrl = Get.find<PostController>();
  final authCtrl = Get.find<AuthController>();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  // ── Pick one image and add to list ───────────────────────
  Future<void> _pickImage() async {
    if (_pickedImages.length >= _maxImages) {
      Get.snackbar(
        'Limit reached',
        'You can only add up to $_maxImages photos',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                borderRadius: BorderRadius.circular(2),
              ),
            ),
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

    if (source != null) {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _pickedImages.add(File(picked.path)));
      }
    }
  }

  // ── Remove image at index ────────────────────────────────
  void _removeImage(int index) {
    setState(() => _pickedImages.removeAt(index));
  }

  // ── Submit ───────────────────────────────────────────────
  Future<void> _submit() async {
    if (_titleCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Missing field',
        'Please enter a title',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (_locationCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Missing field',
        'Please enter a location',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final userId = authCtrl.currentUser.value?.id ?? '';
    final success = await postCtrl.createPost(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      type: _type,
      location: _locationCtrl.text.trim(),
      imageFiles: _pickedImages, // <-- pass the list
      userId: userId,
    );

    if (success) Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'New Post',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.background(context)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Type selector ──────────────────────────────
              _label('Type -'),
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
                          color: isSelected
                              ? color
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            t == 'lost' ? 'Lost' : 'Found',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // ── Photos section ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label('Photos (optional)'),
                  // Counter: "2 / 5"
                  Text(
                    '${_pickedImages.length} / $_maxImages',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Horizontal scroll strip
              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // ── Existing picked images ───────────────
                    ..._pickedImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final file = entry.value;
                      return _buildImageThumbnail(file, index);
                    }),

                    // ── "Add more" button ────────────────────
                    // Only show if under the limit
                    if (_pickedImages.length < _maxImages) _buildAddButton(),
                  ],
                ),
              ),

              // Hint text below strip
              if (_pickedImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'First photo is used as cover image',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ),

              const SizedBox(height: 20),

              // ── Text fields ────────────────────────────────
              AppTextField(
                controller: _titleCtrl,
                label: 'Title -',
                hint: 'e.g. Blue water bottle',
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _descCtrl,
                label: 'Description -',
                hint: 'Add details — color, brand, when/where last seen...',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _locationCtrl,
                label: 'Location -',
                hint: 'e.g. Library 2nd floor, Canteen',
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 20),

              // ── Error ──────────────────────────────────────
              Obx(
                () => postCtrl.errorMessage.value.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          postCtrl.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 13,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),

              // ── Submit ─────────────────────────────────────
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: postCtrl.isUploading.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: postCtrl.isUploading.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                // Shows "Uploading 3 photos..." dynamically
                                _pickedImages.isEmpty
                                    ? 'Uploading...'
                                    : 'Uploading ${_pickedImages.length} '
                                          '${_pickedImages.length == 1 ? "photo" : "photos"}...',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Post Item',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Image thumbnail with remove button ───────────────────
  Widget _buildImageThumbnail(File file, int index) {
    return Container(
      width: 100,
      height: 110,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(file, width: 100, height: 110, fit: BoxFit.cover),
          ),

          // "Cover" badge on first image
          if (index == 0)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cover',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Remove (×) button
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── "Add photo" button ───────────────────────────────────
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 110,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 32,
              color: Colors.grey[500],
            ),
            const SizedBox(height: 6),
            Text(
              'Add photo',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    ),
  );
}
