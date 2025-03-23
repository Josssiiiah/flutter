class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy with method for immutability
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 