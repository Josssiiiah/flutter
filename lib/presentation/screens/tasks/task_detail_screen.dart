import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:flutter_fullstack/data/repositories/task_repository.dart';
import 'package:flutter_fullstack/presentation/providers/task_provider.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  late Future<TaskModel?> _taskFuture;
  final TaskRepository _taskRepository = TaskRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  void _loadTask() {
    _taskFuture = _taskRepository.getTaskById(widget.taskId);
  }

  Future<void> _toggleTaskCompletion(TaskModel task, bool isCompleted) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(taskProvider.notifier).toggleTaskCompletion(
            task.id,
            isCompleted,
          );
      _loadTask(); // Reload the task
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTask(TaskModel task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await ref.read(taskProvider.notifier).deleteTask(task.id);
        if (mounted) {
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/tasks/${widget.taskId}/edit'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<TaskModel?>(
              future: _taskFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _loadTask(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final task = snapshot.data;
                if (task == null) {
                  return const Center(
                    child: Text('Task not found'),
                  );
                }

                final isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task status
                      Row(
                        children: [
                          Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: task.isCompleted ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.isCompleted ? 'Completed' : 'In Progress',
                            style: TextStyle(
                              color: task.isCompleted ? Colors.green : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isOverdue) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Overdue',
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        task.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      // Due date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Created date
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Created: ${DateFormat('MMM d, yyyy').format(task.createdAt)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        child: Text(
                          task.description?.isNotEmpty == true
                              ? task.description!
                              : 'No description provided',
                          style: TextStyle(
                            fontSize: 16,
                            color: task.description?.isNotEmpty == true
                                ? Colors.black87
                                : Colors.grey,
                            fontStyle: task.description?.isNotEmpty == true
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _toggleTaskCompletion(task, !task.isCompleted),
                              icon: Icon(
                                task.isCompleted
                                    ? Icons.refresh
                                    : Icons.check,
                              ),
                              label: Text(
                                task.isCompleted
                                    ? 'Mark as Incomplete'
                                    : 'Mark as Complete',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: task.isCompleted
                                    ? Colors.orange
                                    : Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => _deleteTask(task),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
} 