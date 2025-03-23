class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime dueDate;
  final DateTime createdAt;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.dueDate,
    required this.createdAt,
    required this.userId,
  });

  // Factory constructor to create a TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool,
      dueDate: DateTime.parse(json['due_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      userId: json['user_id'] as String,
    );
  }

  // Method to convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'due_date': dueDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
    };
  }

  // Copy with method for immutability
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
    String? userId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
} 