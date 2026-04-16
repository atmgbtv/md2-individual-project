import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../providers/task_provider.dart';
import '../providers/quote_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/task.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);
    final quoteAsync = ref.watch(quoteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
      ),
      body: Column(
        children: [
          // Offline/Network Error Cache-then-network pattern for Quote
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: quoteAsync.when(
              data: (data) {
                String advice = data;
                try {
                  final parsed = jsonDecode(data);
                  advice = parsed['slip']['advice'];
                } catch (_) {}
                return Text(
                  '"$advice"',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                );
              },
              loading: () => const Text('Loading daily quote...', textAlign: TextAlign.center),
              error: (err, _) => const Text(
                'Stay focused! (Network Error)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks yet. Create one!'));
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (val) {
                          if (val == null) return;
                          final userId = ref.read(authStateProvider).valueOrNull!;
                          ref.read(taskRepositoryProvider).updateTask(
                                userId,
                                task.copyWith(isCompleted: val),
                              );
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: task.priority == 2
                                ? Colors.red
                                : task.priority == 1
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              final userId = ref.read(authStateProvider).valueOrNull!;
                              ref.read(taskRepositoryProvider).deleteTask(userId, task.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskModal(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddTaskSheet(),
    );
  }
}

class AddTaskSheet extends ConsumerStatefulWidget {
  const AddTaskSheet({super.key});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _titleController = TextEditingController();
  int _priority = 0;

  void _submit() {
    if (_titleController.text.trim().isEmpty) return;
    
    final userId = ref.read(authStateProvider).valueOrNull;
    if (userId == null) return;

    final newTask = AppTask(
      id: '', // Firestore generates ID
      title: _titleController.text.trim(),
      priority: _priority,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    ref.read(taskRepositoryProvider).addTask(userId, newTask);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Task Title'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: _priority,
            items: const [
              DropdownMenuItem(value: 0, child: Text('Low Priority')),
              DropdownMenuItem(value: 1, child: Text('Medium Priority')),
              DropdownMenuItem(value: 2, child: Text('High Priority')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _priority = val);
            },
            decoration: const InputDecoration(labelText: 'Urgency'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Add Task'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
