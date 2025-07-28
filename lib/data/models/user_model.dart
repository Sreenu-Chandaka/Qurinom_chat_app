class UserModel {
  final String id;
  final String email;
  final String role;
  final String? name;
  final String? token;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      name: json['name'] ?? json['username'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'name': name,
      'token': token,
    };
  }
}
