import 'package:coalworks/screens/handoverscreen/task_verification_screen.dart';
import 'package:coalworks/widgets/handoverscreen/task_card_model.dart';
import 'package:flutter/material.dart';
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskCard({
    required this.task,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: () {
            if (task.requiresVerification) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TaskVerificationPage(
                    task: task,
                    onVerified: () {
                      // No need to handle task completion here
                    },
                  ),
                ),
              );
            } else {
              onTap();
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
