import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:flutter_fullstack/data/repositories/task_repository.dart';
import 'package:flutter_fullstack/presentation/providers/task_provider.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final bool isEditing;
  final String? taskId;

  const TaskFormScreen({
    Key? key,
    required this.isEditing,
    this.taskId,
  }) : super(key: key);

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;
  String? _errorMessage;
  late final TaskRepository _taskRepository;
  TaskModel? _task;

  @override
  void initState() {
    super.initState();
    _taskRepository = TaskRepository();
    
    if (widget.isEditing && widget.taskId != null) {
      _loadTask();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTask() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      _task = await _taskRepository.getTaskById(widget.taskId!);
      
      if (_task != null) {
        _titleController.text = _task!.title;
        _descriptionController.text = _task!.description ?? '';
        _dueDate = _task!.dueDate;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load task: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.isEditing && _task != null) {
        // Update existing task
        await ref.read(taskProvider.notifier).updateTask(
              _task!.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              dueDate: _dueDate,
            );
      } else {
        // Create new task
        await ref.read(taskProvider.notifier).createTask(
              _titleController.text.trim(),
              _descriptionController.text.trim(),
              _dueDate,
            );
      }
      
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save task: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter task title',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Enter task description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Due date
                    GestureDetector(
                      onTap: _pickDueDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Due Date',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('EEEE, MMM d, yyyy').format(_dueDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Save button
                    ElevatedButton.icon(
                      onPressed: _saveTask,
                      icon: const Icon(Icons.save),
                      label: Text(widget.isEditing ? 'Update Task' : 'Create Task'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    
                    if (widget.isEditing) ...[
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => context.go('/tasks/${widget.taskId}'),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
} 