import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(const {
    "welcome_message": "Welcome to Task Manager!",
  });
  await remoteConfig.fetchAndActivate();

  runApp(
    const ProviderScope(
      child: TaskManagerApp(),
    ),
  );
}

class TaskManagerApp extends ConsumerStatefulWidget {
  const TaskManagerApp({super.key});

  @override
  ConsumerState<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends ConsumerState<TaskManagerApp> {
  // Connectivity monitoring
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!mounted) return;
      setState(() {
        _isConnected = !results.contains(ConnectivityResult.none);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeProvider),
      routerConfig: router,
      builder: (context, child) {
        return Column(
          children: [
            if (!_isConnected)
              Container(
                width: double.infinity,
                color: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            Expanded(child: child ?? const SizedBox()),
          ],
        );
      },
    );
  }
}
