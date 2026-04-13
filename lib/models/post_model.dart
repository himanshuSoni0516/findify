class PostModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String type; // 'lost' or 'found'
  final String location;
  final String? imageUrl;
  final bool isResolved;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.location,
    this.imageUrl,
    required this.isResolved,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? 'lost',
      location: json['location'] ?? '',
      imageUrl: json['image_url'],
      isResolved: json['is_resolved'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'title': title,
    'description': description,
    'type': type,
    'location': location,
    'image_url': imageUrl,
    'is_resolved': isResolved,
  };
}