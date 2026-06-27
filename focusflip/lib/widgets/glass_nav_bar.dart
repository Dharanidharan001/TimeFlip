import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/design_system.dart';
import 'glass_card.dart';

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;
    final activeTab = appState.activeTab;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: GlassCard(
        borderRadius: 9999, // Perfect capsule shape
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Timer Tab
            _buildNavBarItem(
              context: context,
              icon: Icons.timer,
              isActive: activeTab == 0,
              activeColor: theme.defaultAccent,
              theme: theme,
              onTap: () => appState.activeTab = 0,
            ),
            // Stats Tab
            _buildNavBarItem(
              context: context,
              icon: Icons.equalizer,
              isActive: activeTab == 1,
              activeColor: theme.defaultAccent,
              theme: theme,
              onTap: () => appState.activeTab = 1,
            ),
            // Profile Tab
            _buildProfileNavBarItem(
              context: context,
              isActive: activeTab == 2,
              theme: theme,
              onTap: () => appState.activeTab = 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required BuildContext context,
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required AppThemeData theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Icon(
              icon,
              size: 26,
              color: isActive ? activeColor : theme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? activeColor : Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileNavBarItem({
    required BuildContext context,
    required bool isActive,
    required AppThemeData theme,
    required VoidCallback onTap,
  }) {
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.onSurface, // Solid themed text/foreground color circle
          ),
          child: Icon(
            Icons.person,
            color: theme.background, // Solid themed background icon
            size: 24,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Icon(
                Icons.person_outline,
                size: 26,
                color: theme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 6), // Align vertically with dot items
          ],
        ),
      );
    }
  }
}
