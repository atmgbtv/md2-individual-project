# Overview

Build an original Flutter app that follows requirements below. Topic: to-do list/task manager. Idea: you have 3 screens, one for all the tasks where you can assign 3 types of urgency: low, medium, high - you can add or delete tasks here; one screen that allows you to focus only on one task at a time, and it should focus on the task with higher priority first - make it visually clean, maybe add a timer for each task; last screen is for profile where you have streak (same as GitHub contribution) and settings.

## Requirements

### Architecture & dependency injection
• Apply a feature-first or layered folder structure with a clear domain layer (entities, repository interfaces).
• Inject all dependencies via get_it or Riverpod — no Firebase or API calls directly in UI widgets.
### Week 4 Navigation & route guards
• Use go_router with at least one nested shell route (e.g. bottom nav with independent stacks).
• Guard all authenticated routes — unauthenticated users must be redirected to login.
### Weeks 5–6 State management & loading states
• Manage all feature state with Riverpod or BLoC — no business logic inside widget classes.
• Every async operation must handle loading, error, and empty states explicitly in the UI.
• At least one feature uses a cache-then-network pattern to show data before the network responds.
### Week 7 REST API integration
• Integrate one real public REST API using Dio in the data layer.
• Handle network errors and failed responses with user-visible feedback.
### Week 8 Authentication & security
• Firebase Auth with Email/Password login and registration; token stored via flutter_secure_storage.
• No API keys or secrets committed to the repository.
### Weeks 9–10 Firebase — Firestore & one additional service
• Use Firestore as the primary database with security rules enforcing per-user data access.
• At least one real-time snapshot stream driving live UI updates.
• Integrate one additional Firebase service: Cloud Storage, Remote Config, or Cloud Messaging.
### Week 11 Offline-first & performance
• Enable Firestore offline persistence so core features work without internet.
• Show an offline banner using connectivity_plus; identify and resolve at least one performance issue using
Flutter DevTools.
### Week 12 UI/UX quality
• Apply a consistent design system: color palette, typography, spacing, and reusable widgets.
• Support both light and dark mode throughout the app.
### Week 13 Testing & release
• Write at least 5 passing unit or widget tests covering core business logic.
• Submit a release-signed debug APK demonstrating the app runs on a real or emulated device