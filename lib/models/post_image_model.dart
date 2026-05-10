class PostImageModel {
  final String id;
  final String postId;
  final String imageUrl;
  final int order;

  PostImageModel({
    required this.id,
    required this.postId,
    required this.imageUrl,
    this.order = 0,
  });

  factory PostImageModel.fromJson(Map<String, dynamic> json) => PostImageModel(
    id: json['id'] as String,
    postId: json['post_id'] as String,
    imageUrl: json['image_url'] as String,
    order: json['order'] as int? ?? 0,
  );
}
