class Task {
  final String id;
  String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});

  void toggle() {
    completed = !completed;
  }
}
