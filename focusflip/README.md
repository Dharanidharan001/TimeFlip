# focusflip

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase API Keys Configuration

To secure Firebase API keys and prevent exposing them in version control:

1. Create a `secrets.json` file in the root of the project with the following format:
   ```json
   {
     "FIREBASE_API_KEY_ANDROID": "YOUR_ANDROID_API_KEY",
     "FIREBASE_API_KEY_WEB": "YOUR_WEB_API_KEY",
     "FIREBASE_API_KEY_IOS": "YOUR_IOS_API_KEY"
   }
   ```
2. **Standard / Direct Run**: You can run the application normally:
   ```bash
   flutter run -d chrome
   ```
   The app will automatically load `secrets.json` from assets at runtime and configure Firebase options.
3. **Compile-time optimization (Recommended)**: You can also pass keys at compile-time:
   ```bash
   flutter run -d chrome --dart-define-from-file=secrets.json
   ```
