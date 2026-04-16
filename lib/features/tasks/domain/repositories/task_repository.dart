import '../entities/task.dart';

abstract class TaskRepository {
  Stream<List<AppTask>> getTasksStream(String userId);
  Future<void> addTask(String userId, AppTask task);
  Future<void> updateTask(String userId, AppTask task);
  Future<void> deleteTask(String userId, String taskId);
}
