class AppTask {
  final String id;
  final String title;
  final int priority; // 0: low, 1: medium, 2: high
  final bool isCompleted;
  final DateTime createdAt;

  AppTask({
    required this.id,
    required this.title,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
  });

  factory AppTask.fromMap(Map<String, dynamic> data, String id) {
    return AppTask(
      id: id,
      title: data['title'] ?? '',
      priority: data['priority'] ?? 0,
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'priority': priority,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }

  AppTask copyWith({
    String? title,
    int? priority,
    bool? isCompleted,
  }) {
    return AppTask(
      id: id,
      title: title ?? this.title,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
    );
  }
}
