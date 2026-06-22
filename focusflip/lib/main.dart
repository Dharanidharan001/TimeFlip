import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/app_state.dart';
import 'screens/main_layout.dart';
import 'screens/login/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: currentTheme.background,
        colorScheme: ColorScheme.dark(
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
