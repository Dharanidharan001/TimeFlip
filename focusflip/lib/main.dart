import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/main_layout.dart';
import 'screens/login/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme/design_system.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DefaultFirebaseOptions.loadSecrets();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  final isLoggedIn = FirebaseAuth.instance.currentUser != null;

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(isLoggedIn: isLoggedIn),
      child: const FocusFlipApp(),
    ),
  );
}

class FocusFlipApp extends StatelessWidget {
  const FocusFlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final currentTheme = appState.theme;

    return MaterialApp(
      title: 'FocusFlip',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: currentTheme.type == AppThemeType.light ? Brightness.light : Brightness.dark,
        scaffoldBackgroundColor: currentTheme.background,
        colorScheme: currentTheme.type == AppThemeType.light
            ? ColorScheme.light(
                primary: currentTheme.defaultAccent,
                secondary: currentTheme.surfaceContainer,
                surface: currentTheme.surface,
                onSurface: currentTheme.onSurface,
                error: currentTheme.error,
              )
            : ColorScheme.dark(
                primary: currentTheme.defaultAccent,
                secondary: currentTheme.surfaceContainer,
                surface: currentTheme.surface,
                onSurface: currentTheme.onSurface,
                error: currentTheme.error,
              ),
        useMaterial3: true,
      ),
      home: appState.isLoggedIn ? const MainLayout() : const WelcomeScreen(),
    );
  }
}
