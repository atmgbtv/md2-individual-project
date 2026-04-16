import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(ref.watch(firestoreProvider));
});

final tasksStreamProvider = StreamProvider<List<AppTask>>((ref) {
  final authState = ref.watch(authStateProvider);
  final userId = authState.valueOrNull;

  if (userId == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(taskRepositoryProvider);
  return repository.getTasksStream(userId);
});

// A provider returning only the tasks sorted by highest priority and not completed
final focusTasksProvider = Provider<List<AppTask>>((ref) {
  final tasks = ref.watch(tasksStreamProvider).valueOrNull ?? [];
  final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
  // Sort descending by priority (2=high -> 1-> 0)
  incompleteTasks.sort((a, b) => b.priority.compareTo(a.priority));
  return incompleteTasks;
});
