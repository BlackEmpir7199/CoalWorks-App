import 'package:coalworks/widgets/handoverscreen/task_card_model.dart';
import 'package:flutter/material.dart';

class TaskVerificationPage extends StatefulWidget {
  final Task task;
  final VoidCallback onVerified;

  const TaskVerificationPage({required this.task, required this.onVerified, Key? key}) : super(key: key);

  @override
  State<TaskVerificationPage> createState() => _TaskVerificationPageState();
}

class _TaskVerificationPageState extends State<TaskVerificationPage> {
  final List<VerificationStep> steps = [
    VerificationStep(title: 'Checked the Conveyor Belt for wear and tear.'),
    VerificationStep(title: 'Ensured proper alignment of the Conveyor Belt.'),
    VerificationStep(title: 'Documented findings in the log.'),
  ];

  bool get allStepsCompleted => steps.every((step) => step.isCompleted);

  void _onStepToggled(int index) {
    setState(() {
      steps[index] = steps[index].copyWith(isCompleted: !steps[index].isCompleted);
    });
  }

  void _completeVerification() {
    if (allStepsCompleted) {
      widget.onVerified();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all steps to verify the task.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Task: ${widget.task.title}'),
      ),
      body: ListView.builder(
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return VerificationStepCard(
            step: steps[index],
            onToggle: () => _onStepToggled(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _completeVerification,
        label: const Text('Complete Verification'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}

class VerificationStep {
  final String title;
  final bool isCompleted;

  VerificationStep({
    required this.title,
    this.isCompleted = false,
  });

  VerificationStep copyWith({String? title, bool? isCompleted}) {
    return VerificationStep(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class VerificationStepCard extends StatelessWidget {
  final VerificationStep step;
  final VoidCallback onToggle;

  const VerificationStepCard({required this.step, required this.onToggle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: Checkbox(
          value: step.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          step.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: step.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
