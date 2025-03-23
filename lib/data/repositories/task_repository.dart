import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:flutter_fullstack/data/services/task_service.dart';

class TaskRepository {
  final TaskService _taskService = TaskService();
  
  // Singleton pattern
  static final TaskRepository _instance = TaskRepository._internal();
  
  factory TaskRepository() {
    return _instance;
  }
  
  TaskRepository._internal();

  // Get all tasks
  Future<List<TaskModel>> getTasks() async {
    try {
      return await _taskService.getTasks();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  // Get task by ID
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      return await _taskService.getTaskById(taskId);
    } catch (e) {
      throw Exception('Failed to get task by ID: $e');
    }
  }

  // Create task
  Future<TaskModel> createTask(String title, String? description, DateTime dueDate) async {
    try {
      return await _taskService.createTask(title, description, dueDate);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Update task
  Future<TaskModel> updateTask(
    String taskId, {
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? dueDate,
  }) async {
    try {
      return await _taskService.updateTask(
        taskId,
        title: title,
        description: description,
        isCompleted: isCompleted,
        dueDate: dueDate,
      );
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Toggle task completion
  Future<TaskModel> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      return await _taskService.updateTask(taskId, isCompleted: isCompleted);
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
} 