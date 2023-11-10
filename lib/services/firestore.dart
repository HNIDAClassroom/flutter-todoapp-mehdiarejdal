import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class FirestoreService {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return tasks.add({
      'taskTitle': task.title,
      'taskDesc': task.description,
      'taskDate': task.date.toIso8601String(),
      'taskCategory': task.category.toString(),
    });
  }

  Future<void> deleteTaskByTitle(String taskTitle) async {
    QuerySnapshot querySnapshot =
        await tasks.where('taskTitle', isEqualTo: taskTitle).get();
    querySnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  }

  Future<void> updateTaskCompletion(Task task, bool isCompleted) {
    return tasks.doc(task.id).update({'isCompleted': isCompleted});
  }

  Stream<QuerySnapshot> getTasks() {
    return tasks.snapshots();
  }
}
