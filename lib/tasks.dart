import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist_app/models/task.dart';
import 'package:todolist_app/services/firestore.dart';
import 'package:todolist_app/tasks_list.dart';
import 'package:todolist_app/widgets/new_task.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final FirestoreService firestoreService = FirestoreService();

  void _openAddTaskOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(onAddTask: _addTask),
    );
  }

  void _addTask(Task task) {
    setState(() {
      firestoreService.addTask(task);
      // You can choose to update the local task list as well
      // _registeredTasks.add(task);
      Navigator.pop(context);
    });
  }

  Future<void> deleteTaskByTitle(String taskTitle) async {
    QuerySnapshot querySnapshot = await firestoreService.tasks
        .where('taskTitle', isEqualTo: taskTitle)
        .get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }
   Future<void> updateTaskCompletion(Task task, bool isCompleted) {
    return firestoreService.updateTaskCompletion(task, isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ToDoList'),
        actions: [
          IconButton(
            onPressed: _openAddTaskOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: TasksList(
        
      ),
    );
  }
}
