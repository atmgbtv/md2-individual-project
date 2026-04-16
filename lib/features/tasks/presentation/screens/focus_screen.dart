import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../providers/task_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  Timer? _timer;
  int _secondsRemaining = 25 * 60; // 25 min Pomodoro
  bool _isRunning = false;

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          timer.cancel();
          setState(() => _isRunning = false);
        }
      });
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 25 * 60;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusTasks = ref.watch(focusTasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Mode')),
      body: Center(
        child: focusTasks.isEmpty
            ? const Text('No pending tasks to focus on! You are all caught up.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'CURRENT PENDING HIGH PRIORITY:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    focusTasks.first.title,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                        label: Text(_isRunning ? 'Pause' : 'Start Focus'),
                        onPressed: _toggleTimer,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset'),
                        onPressed: _resetTimer,
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                  TextButton.icon(
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    label: const Text('Complete Task', style: TextStyle(color: Colors.green, fontSize: 18)),
                    onPressed: () {
                      final userId = ref.read(authStateProvider).valueOrNull;
                      if (userId == null) return;
                      
                      final currentTask = focusTasks.first;
                      ref.read(taskRepositoryProvider).updateTask(
                        userId,
                        currentTask.copyWith(isCompleted: true),
                      );
                      
                      _resetTimer();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Task completed! Keep going!')),
                      );
                    },
                  )
                ],
              ),
      ),
    );
  }
}
