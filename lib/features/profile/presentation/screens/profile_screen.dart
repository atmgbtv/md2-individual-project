import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../tasks/presentation/providers/task_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          )
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final Map<DateTime, int> dataset = {};
          for (var task in tasks) {
            final date = DateTime(task.createdAt.year, task.createdAt.month, task.createdAt.day);
            dataset[date] = (dataset[date] ?? 0) + 1;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity Streak',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HeatMap(
                      datasets: dataset,
                      colorMode: ColorMode.opacity,
                      showText: false,
                      scrollable: true,
                      showColorTip: false,
                      colorsets: const {
                        1: Colors.green,
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme Mode'),
                  subtitle: Text(ref.watch(themeProvider).name.toUpperCase()),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
