import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepositoryImpl(this._firestore);

  @override
  Stream<List<AppTask>> getTasksStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => AppTask.fromMap(doc.data(), doc.id)).toList();
    });
  }

  @override
  Future<void> addTask(String userId, AppTask task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toMap());
  }

  @override
  Future<void> updateTask(String userId, AppTask task) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  @override
  Future<void> deleteTask(String userId, String taskId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
