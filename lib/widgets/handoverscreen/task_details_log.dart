import 'package:flutter/material.dart';
import 'task_card_model.dart';
class TaskDetailsDialog extends StatelessWidget {
  final Task task;
  const TaskDetailsDialog({required this.task, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        task.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        task.description,
        style: const TextStyle(color: Colors.black54, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
