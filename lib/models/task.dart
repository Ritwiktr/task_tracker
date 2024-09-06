class Task {
  final int? id;
  final String name;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String category;

  Task({
    this.id,
    required this.name,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
      category: map['category'],
    );
  }

  Task copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}