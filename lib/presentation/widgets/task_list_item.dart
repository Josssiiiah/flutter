import 'package:flutter/material.dart';
import 'package:flutter_fullstack/data/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskListItem extends StatelessWidget {
  final TaskModel task;
  final Function(bool) onToggle;
  final VoidCallback onTap;

  const TaskListItem({
    Key? key,
    required this.task,
    required this.onToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isOverdue
            ? BorderSide(color: Colors.red.shade300, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onToggle(value ?? false),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: Colors.green,
              ),
              const SizedBox(width: 8),
              // Task details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    if (task.description != null && task.description!.isNotEmpty)
                      Text(
                        task.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isOverdue ? Colors.red : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(task.dueDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverdue ? Colors.red : Colors.grey,
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isOverdue) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Overdue',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 