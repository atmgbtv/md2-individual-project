# TaskFlow: Modern Flutter Task Manager

TaskFlow is a feature-rich, offline-first task management application built with Flutter. It follows a clean architecture pattern and leverages Firebase for backend services.

## 🚀 Key Features

### 1. Task Management (`My Tasks`)
- **CRUD Operations**: Create, read, and delete tasks.
- **Urgency Levels**: Assign Low, Medium, or High priority to tasks.
- **Real-time Updates**: Powered by Firestore snapshots for instant synchronization across devices.
- **Daily Motivation**: Integrates a public REST API (Advice Slip) to provide a fresh quote on every visit.

### 2. Focus Mode
- **Smart Prioritization**: Automatically focuses on your highest priority pending task.
- **Pomodoro Timer**: Includes a built-in focus timer (25 minutes) to help maintain productivity.
- **Seamless Workflow**: Mark tasks as "Completed" directly from the focus screen to automatically bring up the next priority item.

### 3. Profile & Insights
- **Activity Streak**: A GitHub-inspired contribution heatmap (`flutter_heatmap_calendar`) that tracks your task creation activity over time.
- **Theme Customization**: Support for Light Mode, Dark Mode, and System Default with persistent storage via `flutter_secure_storage`.
- **Secure Authentication**: Firebase Email/Password authentication with persistent login sessions.

### 4. Robust Performance
- **Offline-First**: Firestore persistence enabled, allowing all core features to work without an internet connection.
- **Connectivity Status**: Real-time monitoring with a user-friendly "No Internet" banner when offline.
- **Performance Optimized**: Built using Riverpod for efficient state management and optimized widget rebuilds.

---

## 🏗 Architecture

The project follows a **Feature-First / Layered Architecture** to ensure scalability and maintainability:

- **Presentation Layer**: Riverpod Providers, ConsumerWidgets, and UI components.
- **Domain Layer**: Pure Dart entities and repository interfaces (business logic).
- **Data Layer**: Repository implementations, Firestore data sources, and API services (Dio).
- **Core**: Theme configurations, shared constants, and GoRouter navigation logic.

---

## 🛠 Tech Stack

- **Framework**: Flutter
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Database**: Firebase Firestore (Offline persistence enabled)
- **Auth**: Firebase Authentication
- **Networking**: [Dio](https://pub.dev/packages/dio) for REST API integration
- **Storage**: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for theme and token persistence
- **UI Components**: `flutter_heatmap_calendar`, `connectivity_plus`, `google_fonts`

---

## 📝 Compliance with Requirements

This project fulfills all criteria specified in the academic requirements:
- [x] **Architecture**: Feature-first structure with clear domain/data separation.
- [x] **DI**: All dependencies injected via Riverpod.
- [x] **Navigation**: Nested shell routes with GoRouter and authentication guards.
- [x] **State**: Async operations handled with explicit loading/error/empty states.
- [x] **REST API**: Integrated with Dio (Advice Slip API).
- [x] **Firebase**: Auth, Firestore, and Remote Config integration.
- [x] **Performance**: Offline persistence and connectivity monitoring.
- [x] **Design**: Consistent Light/Dark mode themes with a 100% centered AppBar design.

---

## 🛠 Setup & Installation

1. Clone the repository.
2. Ensure you have the Flutter SDK installed (3.41.6+ recommended).
3. Run `flutter pub get` to fetch dependencies.
4. (Linux users) Ensure `libsecret-1-dev`, `clang`, and `lld` are installed.
5. Launch the app using `flutter run`.
