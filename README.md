# Flutter Fullstack Project

A full-stack Flutter application with authentication, task management, and Firebase integration.

## Features

- User Authentication (Email/Password)
- Task Management (Create, Read, Update, Delete)
- Responsive UI for all platforms
- Firebase Integration (Firestore)
- State Management with Riverpod
- Navigation with GoRouter

## Project Structure

```
lib/
├── core/
│   ├── config/            # App-wide configuration
│   └── utils/             # Utility classes
├── data/
│   ├── models/            # Data models
│   ├── repositories/      # Repository pattern implementation
│   └── services/          # Services for external data sources
└── presentation/
    ├── providers/         # State management providers
    ├── screens/           # UI screens
    └── widgets/           # Reusable UI components
```

## Prerequisites

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher
- Firebase project (optional for development)

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/yourusername/flutter_fullstack.git
cd flutter_fullstack
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Firebase Setup

To use Firebase services:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add your Flutter app to Firebase
3. Download the Firebase configuration files:
   - For Android: `google-services.json` to `android/app/`
   - For iOS: `GoogleService-Info.plist` to `ios/Runner/`
   - For web: Configure `web/index.html`
4. Enable Authentication and Firestore in Firebase Console

## Dependencies

- flutter_riverpod: For state management
- go_router: For navigation
- firebase_core & cloud_firestore: For Firebase integration
- dio: For HTTP requests
- shared_preferences: For local storage
- better_auth: For authentication
- intl: For date formatting

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for the state management solution
- Firebase for the backend services
# flutter
