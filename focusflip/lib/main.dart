import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
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
      home: const MainLayout(),
    );
  }
}
