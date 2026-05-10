import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/task_model.dart';

class TaskService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final User? user =
      FirebaseAuth.instance.currentUser;

  // ADD TASK
  Future<void> addTask(TaskModel task) async {

    if (user == null) return;

    await _firestore.collection('tasks').add({

      'title': task.title,
      'description': task.description,
      'date': task.date,
      'completed': task.completed,
      'userId': user!.uid,
    });
  }

  // GET TASKS
  Stream<List<TaskModel>> getTasks() {

    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user!.uid)
        // .orderBy('date', descending: true) // Removed to prevent index error
        .snapshots()
        .map((snapshot) {

      final tasks = snapshot.docs.map((doc) {

        return TaskModel.fromMap(
          doc.data(),
          doc.id,
        );

      }).toList();

      // Sort locally
      tasks.sort((a, b) => b.date.compareTo(a.date));
      return tasks;
    });
  }

  // UPDATE TASK
  Future<void> updateTask(TaskModel task) async {

    await _firestore
        .collection('tasks')
        .doc(task.id)
        .update({

      'title': task.title,
      'description': task.description,
      'date': task.date,
      'completed': task.completed,
    });
  }

  // DELETE TASK
  Future<void> deleteTask(String taskId) async {

    await _firestore
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // TOGGLE TASK
  Future<void> toggleTask(
      String taskId,
      bool value,
      ) async {

    await _firestore
        .collection('tasks')
        .doc(taskId)
        .update({

      'completed': value,
    });
  }
}