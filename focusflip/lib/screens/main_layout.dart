import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/glass_nav_bar.dart';
import 'timer_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';
import 'focus_screen.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    // If the timer is active (ticking or paused in focus mode), show the full-screen Focus Mode.
    if (appState.isTimerRunning) {
      return const FocusScreen();
    }

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          // Content Area
          Positioned.fill(
            child: _getActiveScreen(appState.activeTab),
          ),

          // Floating Bottom Navigation Bar
          const Align(
            alignment: Alignment.bottomCenter,
            child: GlassNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _getActiveScreen(int index) {
    switch (index) {
      case 0:
        return const TimerScreen();
      case 1:
        return const StatsScreen();
      case 2:
        return const ProfileScreen();
      default:
        return const TimerScreen();
    }
  }
}
