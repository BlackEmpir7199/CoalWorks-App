import 'package:coalworks/screens/handoverscreen/task_verification_screen.dart';
import 'package:coalworks/widgets/handoverscreen/task_card.dart';
import 'package:coalworks/widgets/handoverscreen/task_card_model.dart';
import 'package:coalworks/widgets/handoverscreen/task_details_log.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandOverPage extends StatefulWidget {
  const HandOverPage({super.key});

  @override
  State<HandOverPage> createState() => _HandOverPageState();
}

class _HandOverPageState extends State<HandOverPage> {
  List<Task> tasks = [
    Task(
      title: 'Inspect Conveyor Belt',
      description: 'Check for wear and tear, and ensure proper alignment of the conveyor belt.',
      requiresVerification: true,
    ),
    Task(
      title: 'Fire Outbreak',
      description: 'Check for Oil leak in zone 2',
      requiresVerification: true,
    ),
  ];
 @override
  void initState() {
    super.initState();
    _loadTaskCompletionState();
  }

  Future<void> _loadTaskCompletionState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = tasks.map((task) {
        final isCompleted = prefs.getBool(task.title) ?? false;
        return task.copyWith(isCompleted: isCompleted);
      }).toList();
    });
  }

  Future<void> _saveTaskCompletionState(Task task) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(task.title, task.isCompleted);

    // Update the number of completed tasks
    int completedTasks = (prefs.getInt('completedTasks') ?? 0) + (task.isCompleted ? 1 : -1);
    await prefs.setInt('completedTasks', completedTasks);
  }

  void _startTaskVerification(Task task) {
    if (task.requiresVerification) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskVerificationPage(
            task: task,
            onVerified: () {
              setState(() {
                task.isCompleted = true;
              });
              _saveTaskCompletionState(task);
              _removeCompletedTask(task);
            },
          ),
        ),
      );
    } else {
      setState(() {
        task.isCompleted = !task.isCompleted;
      });
      _saveTaskCompletionState(task);
    }
  }

  void _removeCompletedTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: tasks[index],
            onTap: () => _showTaskDetails(tasks[index]),
          );
        },
      ),
    );
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskDetailsDialog(task: task);
      },
    );
  }
}