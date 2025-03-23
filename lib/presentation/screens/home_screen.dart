import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:flutter_fullstack/presentation/providers/auth_provider.dart';
import 'package:flutter_fullstack/presentation/providers/task_provider.dart';
import 'package:flutter_fullstack/presentation/widgets/task_list_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User greeting
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    user?.name.isNotEmpty == true
                        ? user!.name.substring(0, 1).toUpperCase()
                        : 'U',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${user?.name ?? 'User'}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Here are your tasks for today',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Task list
          Expanded(
            child: _buildTaskList(context, ref, taskState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/tasks/create'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, WidgetRef ref, TaskState taskState) {
    if (taskState.status == TaskStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (taskState.status == TaskStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${taskState.errorMessage}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(taskProvider.notifier).fetchTasks(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (taskState.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a new task to get started',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/tasks/create'),
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(taskProvider.notifier).fetchTasks(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: taskState.tasks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final task = taskState.tasks[index];
          return TaskListItem(
            task: task,
            onToggle: (value) {
              ref.read(taskProvider.notifier).toggleTaskCompletion(task.id, value);
            },
            onTap: () => context.go('/tasks/${task.id}'),
          );
        },
      ),
    );
  }
} 