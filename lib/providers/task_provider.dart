import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';
import '../helpers/notification_helper.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  List<Task> _filteredTasks = [];
  List<Task> get filteredTasks => _filteredTasks;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _showCompleted = true;

  Future<void> loadTasks() async {
    _tasks = await DatabaseHelper.instance.getTasks();
    _applyFilters();
  }

  Future<void> addTask(Task task) async {
    final id = await DatabaseHelper.instance.insertTask(task);
    task = task.copyWith(id: id);
    _scheduleNotification(task);
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    _scheduleNotification(task);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    await NotificationHelper.cancelNotification(id);
    await loadTasks();
  }

  Future<void> toggleTaskCompletion(Task task) async {
    task = task.copyWith(isCompleted: !task.isCompleted);
    await updateTask(task);
  }

  Future<void> searchTasks(String query) async {
    _searchQuery = query;
    await _applyFilters();
  }

  Future<void> filterTasksByCategory(String category) async {
    _selectedCategory = category;
    await _applyFilters();
  }

  void toggleShowCompleted(bool show) {
    _showCompleted = show;
    _applyFilters();
  }

  Future<void> _applyFilters() async {
    _filteredTasks = _tasks;

    // Apply category filter
    if (_selectedCategory != 'All') {
      _filteredTasks = _filteredTasks.where((task) => task.category == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredTasks = _filteredTasks.where((task) =>
      task.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply completed tasks filter
    if (!_showCompleted) {
      _filteredTasks = _filteredTasks.where((task) => !task.isCompleted).toList();
    }

    notifyListeners();
  }

  void _scheduleNotification(Task task) {
    if (!task.isCompleted) {
      NotificationHelper.scheduleNotification(
        task.id!,
        'Task Due Today',
        'Your task "${task.name}" is due today!',
        task.dueDate,
      );
    } else {
      NotificationHelper.cancelNotification(task.id!);
    }
  }
}