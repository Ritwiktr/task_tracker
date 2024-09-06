import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:intl/intl.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  AddEditTaskScreen({this.task});

  @override
  _AddEditTaskScreenState createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;
  late DateTime _dueDate;
  late TimeOfDay _dueTime;
  late String _category;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _name = widget.task!.name;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _dueTime = TimeOfDay.fromDateTime(widget.task!.dueDate);
      _category = widget.task!.category;
    } else {
      _name = '';
      _description = '';
      _dueDate = DateTime.now();
      _dueTime = TimeOfDay.now();
      _category = 'Work';
    }
  }

  String _formatDateTime() {
    final date = DateFormat('MMM d, y').format(_dueDate);
    final time = _dueTime.format(context);
    return '$date at $time';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final textScaleFactor = mediaQuery.textScaleFactor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Add Task' : 'Edit Task',
          style: TextStyle(fontSize: 20 * textScaleFactor, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade800, Colors.indigo.shade200],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTaskInfoCard(screenWidth, screenHeight, textScaleFactor),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDateTimeCard(screenWidth, screenHeight, textScaleFactor),
                    SizedBox(height: screenHeight * 0.04),
                    _buildSaveButton(screenWidth, screenHeight, textScaleFactor),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskInfoCard(double screenWidth, double screenHeight, double textScaleFactor) {
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(
                labelText: 'Task Name',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.task, size: 24 * textScaleFactor, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(fontSize: 16 * textScaleFactor, color: Colors.white),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.description, size: 24 * textScaleFactor, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(fontSize: 16 * textScaleFactor, color: Colors.white),
              maxLines: 3,
              onSaved: (value) {
                _description = value!;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeCard(double screenWidth, double screenHeight, double textScaleFactor) {
    return Card(
      elevation: 8,
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Due Date and Time',
                style: TextStyle(fontSize: 16 * textScaleFactor, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                _formatDateTime(),
                style: TextStyle(fontSize: 14 * textScaleFactor, color: Colors.white70),
              ),
              trailing: Icon(Icons.calendar_today, size: 24 * textScaleFactor, color: Colors.white70),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: _dueTime,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _dueDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      _dueTime = pickedTime;
                    });
                  }
                }
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.category, size: 24 * textScaleFactor, color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(fontSize: 16 * textScaleFactor, color: Colors.white),
              dropdownColor: Colors.indigo.shade700,
              items: ['Work', 'Personal', 'Other'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _category = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(double screenWidth, double screenHeight, double textScaleFactor) {
    return ElevatedButton(
      child: Text(
        'Save Task',
        style: TextStyle(fontSize: 18 * textScaleFactor, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.indigo.shade800, backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenHeight * 0.03),
        ),
        elevation: 8,
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          final task = Task(
            id: widget.task?.id,
            name: _name,
            description: _description,
            dueDate: DateTime(_dueDate.year, _dueDate.month, _dueDate.day, _dueTime.hour, _dueTime.minute),
            category: _category,
          );
          if (widget.task == null) {
            Provider.of<TaskProvider>(context, listen: false).addTask(task);
          } else {
            Provider.of<TaskProvider>(context, listen: false).updateTask(task);
          }
          Navigator.pop(context);
        }
      },
    );
  }
}