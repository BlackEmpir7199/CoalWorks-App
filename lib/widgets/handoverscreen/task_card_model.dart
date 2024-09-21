class Task {
  final String title;
  final String description;
  final bool requiresVerification;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.requiresVerification = false,
    this.isCompleted = false,
  });

  Task copyWith({bool? isCompleted}) {
    return Task(
      title: title,
      description: description,
      requiresVerification: requiresVerification,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
