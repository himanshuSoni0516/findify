class UserModel {
  final String id;
  final String email;
  final String name;
  final String? course;
  final String? semester;
  final String? phone;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.course,
    this.semester,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      course: json['course'],
      semester: json['semester'],
      phone: json['phone'],
    );
  }
}