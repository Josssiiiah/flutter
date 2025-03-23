import 'dart:math';
import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:flutter_fullstack/data/services/auth_service.dart';

class TaskService {
  final AuthService _authService = AuthService();
  final List<TaskModel> _mockTasks = [];
  final Random _random = Random();
  
  // Singleton pattern
  static final TaskService _instance = TaskService._internal();
  
  factory TaskService() {
    return _instance;
  }
  
  TaskService._internal() {
    // Initialize with some mock tasks
    _initializeMockTasks();
  }

  void _initializeMockTasks() {
    final now = DateTime.now();
    
    _mockTasks.addAll([
      TaskModel(
        id: 'task_1',
        title: 'Complete project documentation',
        description: 'Write comprehensive documentation for the Flutter project',
        isCompleted: false,
        dueDate: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 1)),
        userId: 'mock_user_id',
      ),
      TaskModel(
        id: 'task_2',
        title: 'Fix UI bugs',
        description: 'Address UI issues on the dashboard page',
        isCompleted: true,
        dueDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 3)),
        userId: 'mock_user_id',
      ),
      TaskModel(
        id: 'task_3',
        title: 'Implement new feature',
        description: 'Add dark mode support to the application',
        isCompleted: false,
        dueDate: now.add(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 2)),
        userId: 'mock_user_id',
      ),
    ]);
  }

  // Get all tasks for the current user
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    final user = await _authService.getCurrentUser();
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    return _mockTasks.where((task) => task.userId == user.id).toList();
  }

  // Get a specific task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    return _mockTasks.firstWhere(
      (task) => task.id == taskId,
      orElse: () => throw Exception('Task not found'),
    );
  }

  // Create a new task
  Future<TaskModel> createTask(String title, String? description, DateTime dueDate) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    final user = await _authService.getCurrentUser();
    if (user == null) {
      throw Exception('User not authenticated');
    }
    
    final newTask = TaskModel(
      id: 'task_${_mockTasks.length + 1}_${_random.nextInt(1000)}',
      title: title,
      description: description,
      isCompleted: false,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      userId: user.id,
    );
    
    _mockTasks.add(newTask);
    
    return newTask;
  }

  // Update an existing task
  Future<TaskModel> updateTask(String taskId, {
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    final taskIndex = _mockTasks.indexWhere((task) => task.id == taskId);
    
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    
    final oldTask = _mockTasks[taskIndex];
    final updatedTask = TaskModel(
      id: oldTask.id,
      title: title ?? oldTask.title,
      description: description ?? oldTask.description,
      isCompleted: isCompleted ?? oldTask.isCompleted,
      dueDate: dueDate ?? oldTask.dueDate,
      createdAt: oldTask.createdAt,
      userId: oldTask.userId,
    );
    
    _mockTasks[taskIndex] = updatedTask;
    
    return updatedTask;
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network delay
    
    final taskIndex = _mockTasks.indexWhere((task) => task.id == taskId);
    
    if (taskIndex == -1) {
      throw Exception('Task not found');
    }
    
    _mockTasks.removeAt(taskIndex);
  }
} 