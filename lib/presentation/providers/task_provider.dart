import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:flutter_fullstack/data/repositories/task_repository.dart';

// Task state
enum TaskStatus {
  initial,
  loading,
  loaded,
  error,
}

// Task state class
class TaskState {
  final TaskStatus status;
  final List<TaskModel> tasks;
  final String? errorMessage;

  TaskState({
    required this.status,
    required this.tasks,
    this.errorMessage,
  });

  factory TaskState.initial() {
    return TaskState(
      status: TaskStatus.initial,
      tasks: [],
    );
  }

  TaskState copyWith({
    TaskStatus? status,
    List<TaskModel>? tasks,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Task notifier
class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _taskRepository = TaskRepository();

  TaskNotifier() : super(TaskState.initial()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    state = state.copyWith(status: TaskStatus.loading);
    try {
      final tasks = await _taskRepository.getTasks();
      state = state.copyWith(
        status: TaskStatus.loaded,
        tasks: tasks,
      );
    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> createTask(String title, String? description, DateTime dueDate) async {
    try {
      state = state.copyWith(status: TaskStatus.loading);
      final newTask = await _taskRepository.createTask(title, description, dueDate);
      state = state.copyWith(
        status: TaskStatus.loaded,
        tasks: [...state.tasks, newTask],
      );
    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateTask(
    String taskId, {
    String? title,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      state = state.copyWith(status: TaskStatus.loading);
      final updatedTask = await _taskRepository.updateTask(
        taskId,
        title: title,
        description: description,
        dueDate: dueDate,
      );
      
      state = state.copyWith(
        status: TaskStatus.loaded,
        tasks: state.tasks.map((task) {
          return task.id == taskId ? updatedTask : task;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      state = state.copyWith(status: TaskStatus.loading);
      final updatedTask = await _taskRepository.toggleTaskCompletion(taskId, isCompleted);
      
      state = state.copyWith(
        status: TaskStatus.loaded,
        tasks: state.tasks.map((task) {
          return task.id == taskId ? updatedTask : task;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      state = state.copyWith(status: TaskStatus.loading);
      await _taskRepository.deleteTask(taskId);
      
      state = state.copyWith(
        status: TaskStatus.loaded,
        tasks: state.tasks.where((task) => task.id != taskId).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        status: TaskStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

// Provider
final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier();
}); 