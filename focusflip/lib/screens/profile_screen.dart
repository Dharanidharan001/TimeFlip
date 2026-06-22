import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/design_system.dart';
import '../widgets/glass_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? user?.email?.split('@')[0] ?? 'User';
    final userEmail = user?.email ?? 'Not Logged In';

    // String representation of accent color hex code
    final accentHex = '#${appState.accentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    // List of predefined accent colors
    final accentColors = [
      const Color(0xFFADC6FF), // Muted light blue
      const Color(0xFFFFB786), // Warm orange
      const Color(0xFFFFB4AB), // Salmon red
      const Color(0xFF8C909F), // Steel blue-grey
    ];

    return SafeArea(
      child: Column(
        children: [
          // Glass top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.02),
              border: const Border(
                bottom: BorderSide(color: Color(0x1AFFFFFF), width: 1.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: theme.defaultAccent),
                  onPressed: () {},
                ),
                Text(
                  'FocusFlip',
                  style: DesignSystem.getHeadlineMd(context, color: Colors.white).copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings, color: theme.defaultAccent),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Scrollable settings body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120, left: 24, right: 24, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header Info
                  Center(
                    child: Column(
                      children: [
                        // Avatar with glowing ring
                        Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                theme.defaultAccent,
                                Colors.transparent,
                                theme.defaultAccent.withValues(alpha: 0.5),
                                theme.defaultAccent,
                              ],
                              stops: const [0.0, 0.5, 0.75, 1.0],
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF1F2020),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: user?.photoURL != null
                                ? Image.network(
                                    user!.photoURL!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white.withValues(alpha: 0.6),
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : Image.network(
                                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCDZoTdSvMUmC6j4CPAxIz2KMGxSbXxwrvrUPMcvwbpIjrmsLynHm7f2-ob6W5DnSLz0cLb0l32mx0azfvNUAcLq4pBjIrR9AEqlVEsbnCRMtaDOyLKw-l5tt5cUnSjj5vLcmwD2Un_6nDcPX84hfGCM2gkO_q1Da_YcIrC8UED3jw9nJWWrKhVcYiZfbvIJyIpN2RnN5wGvXcuHJYG-VUBdwoMImF4KD0JNbRDFBRM8XgGbTODehLxPlEaNaZrhsxeV-hcSkYM8QQU',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Center(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white.withValues(alpha: 0.6),
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userName,
                          style: DesignSystem.getHeadlineMd(
                            context,
                            color: Colors.white,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.defaultAccent,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'Pro Member',
                                style: DesignSystem.getLabelSm(
                                  context,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Since 2023',
                              style: DesignSystem.getLabelSm(
                                context,
                                color: theme.onSurfaceMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Edit Profile Button
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0x33FFFFFF)),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: DesignSystem.getLabelSm(context, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Account Settings
                  Text(
                    'Account Settings',
                    style: DesignSystem.getLabelSm(
                      context,
                      color: theme.onSurfaceMuted,
                    ).copyWith(letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildSettingsRow(
                          context: context,
                          icon: Icons.account_circle,
                          title: 'Account Information',
                          theme: theme,
                          onTap: () => _showAccountInfoDialog(context, user, userName, userEmail),
                        ),
                        const Divider(color: Color(0x1AFFFFFF), height: 1),
                        _buildSettingsRow(
                          context: context,
                          icon: Icons.cloud_upload,
                          title: 'Cloud Backup',
                          theme: theme,
                          onTap: () => _showCloudBackupDialog(context, theme),
                        ),
                        const Divider(color: Color(0x1AFFFFFF), height: 1),
                        _buildSettingsRow(
                          context: context,
                          icon: Icons.file_upload,
                          title: 'Export Focus Data',
                          theme: theme,
                          onTap: () => _showExportDataDialog(context, appState, theme),
                        ),
                        const Divider(color: Color(0x1AFFFFFF), height: 1),
                        _buildSettingsRow(
                          context: context,
                          icon: Icons.logout,
                          title: 'Sign Out',
                          theme: theme,
                          textColor: theme.error,
                          iconColor: theme.error,
                          onTap: () async {
                            await appState.logout();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Theme Store
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Theme Store',
                        style: DesignSystem.getLabelSm(
                          context,
                          color: theme.onSurfaceMuted,
                        ).copyWith(letterSpacing: 1.0),
                      ),
                      Text(
                        'View All',
                        style: DesignSystem.getLabelSm(
                          context,
                          color: theme.defaultAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: [
                        _buildThemeCard(
                          context: context,
                          type: AppThemeType.amoled,
                          title: 'AMOLED',
                          bgPreviewColor: Colors.black,
                          appState: appState,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildThemeCard(
                          context: context,
                          type: AppThemeType.cyberBlue,
                          title: 'Cyber Blue',
                          bgPreviewColor: const Color(0xFF0A192F),
                          appState: appState,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF64FFDA).withValues(alpha: 0.4),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildThemeCard(
                          context: context,
                          type: AppThemeType.retroFlip,
                          title: 'Retro Flip',
                          bgPreviewColor: const Color(0xFF1B1B1B),
                          appState: appState,
                          child: Text(
                            '25:00',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF97316),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildThemeCard(
                          context: context,
                          type: AppThemeType.terminal,
                          title: 'Terminal',
                          bgPreviewColor: const Color(0xFF0D1117),
                          appState: appState,
                          child: Text(
                            '> status: active',
                            style: TextStyle(
                              fontFamily: 'Geist',
                              fontSize: 8,
                              color: const Color(0xFF238636),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Fine Tuning Slider Section
                  Text(
                    'Fine-Tuning',
                    style: DesignSystem.getLabelSm(
                      context,
                      color: theme.onSurfaceMuted,
                    ).copyWith(letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Accent Color Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Accent Color',
                              style: DesignSystem.getBodyMd(
                                context,
                                color: theme.onSurfaceMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              accentHex,
                              style: DesignSystem.getLabelSm(
                                context,
                                color: theme.defaultAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Accent Color row selectors
                        Row(
                          children: [
                            ...accentColors.map((color) {
                              final isSelected = appState.accentColor == color;
                              return GestureDetector(
                                onTap: () => appState.setAccentColor(color),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                    border: isSelected
                                        ? Border.all(color: Colors.white, width: 2.0)
                                        : null,
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: color.withValues(alpha: 0.5),
                                              blurRadius: 6,
                                              spreadRadius: 1,
                                            )
                                          ]
                                        : null,
                                  ),
                                ),
                              );
                            }),

                            // Palette Dialog Trigger
                            GestureDetector(
                              onTap: () => _showColorPickerDialog(context, appState),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.1),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                                ),
                                child: const Icon(
                                  Icons.palette,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Timer Display style slider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Timer Display Style',
                              style: DesignSystem.getBodyMd(
                                context,
                                color: theme.onSurfaceMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              appState.timerDisplayStyleLabel,
                              style: DesignSystem.getLabelSm(
                                context,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: appState.timerDisplayStyle,
                          min: 0,
                          max: 100,
                          activeColor: theme.defaultAccent,
                          inactiveColor: Colors.white.withValues(alpha: 0.1),
                          onChanged: (val) => appState.setTimerDisplayStyle(val),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Minimal', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted.withValues(alpha: 0.6), fontSize: 10)),
                              Text('Standard', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted.withValues(alpha: 0.6), fontSize: 10)),
                              Text('Dynamic', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted.withValues(alpha: 0.6), fontSize: 10)),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Animation Speed slider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fluid Animation Speed',
                              style: DesignSystem.getBodyMd(
                                context,
                                color: theme.onSurfaceMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              appState.animationSpeedLabel,
                              style: DesignSystem.getLabelSm(
                                context,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: appState.animationSpeed,
                          min: 0,
                          max: 100,
                          activeColor: theme.defaultAccent,
                          inactiveColor: Colors.white.withValues(alpha: 0.1),
                          onChanged: (val) => appState.setAnimationSpeed(val),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Static', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted.withValues(alpha: 0.6), fontSize: 10)),
                              Text('Responsive', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted.withValues(alpha: 0.6), fontSize: 10)),
                              Text('Hyper-fluid', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted.withValues(alpha: 0.6), fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required AppThemeData theme,
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? theme.defaultAccent, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: DesignSystem.getBodyLg(context, color: textColor ?? Colors.white).copyWith(fontSize: 16),
              ),
            ),
            Icon(Icons.chevron_right, color: theme.onSurfaceMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard({
    required BuildContext context,
    required AppThemeType type,
    required String title,
    required Color bgPreviewColor,
    required AppState appState,
    required Widget child,
  }) {
    final theme = appState.theme;
    final isSelected = appState.activeThemeType == type;

    return GestureDetector(
      onTap: () => appState.setTheme(type),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          border: Border.all(
            color: isSelected ? theme.defaultAccent : const Color(0x1AFFFFFF),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Preview card background
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgPreviewColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child,
                    if (isSelected)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.check_circle,
                          color: theme.defaultAccent,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: DesignSystem.getLabelSm(
                context,
                color: isSelected ? theme.defaultAccent : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, AppState appState) {
    final customColors = [
      Colors.pink[200]!,
      Colors.purple[200]!,
      Colors.teal[200]!,
      Colors.green[200]!,
      Colors.yellow[200]!,
      Colors.red[200]!,
      Colors.blue[200]!,
    ];

    showDialog(
      context: context,
      builder: (context) {
        final theme = appState.theme;
        return AlertDialog(
          backgroundColor: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0x1AFFFFFF)),
          ),
          title: Text(
            'Custom Accent Color',
            style: DesignSystem.getHeadlineMd(context, color: Colors.white),
          ),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: customColors.map((color) {
              return GestureDetector(
                onTap: () {
                  appState.setAccentColor(color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: appState.accentColor == color
                        ? Border.all(color: Colors.white, width: 2.0)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CLOSE',
                style: DesignSystem.getLabelMd(context, color: theme.defaultAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAccountInfoDialog(BuildContext context, User? user, String name, String email) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Account Information', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $name', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('Email: $email', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('User ID: ${user?.uid ?? "N/A"}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showCloudBackupDialog(BuildContext context, AppThemeData theme) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Cloud Backup', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Cloud Synchronization is active. All of your focus sessions and stats are automatically backed up in real-time to Firestore database.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: theme.defaultAccent)),
            ),
          ],
        );
      },
    );
  }

  void _showExportDataDialog(BuildContext context, AppState appState, AppThemeData theme) {
    final exportString = '{"streak": ${appState.streak}, "sessionsCount": ${appState.recentSessions.length}}';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Export Focus Data', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You can copy your focus session metadata below:',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  exportString,
                  style: const TextStyle(fontFamily: 'Courier', color: Colors.white60),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CLOSE', style: TextStyle(color: theme.defaultAccent)),
            ),
          ],
        );
      },
    );
  }
}
