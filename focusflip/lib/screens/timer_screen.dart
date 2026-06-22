import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/design_system.dart';
import '../widgets/glass_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120), // Leave space for GlassNavBar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${FirebaseAuth.instance.currentUser?.displayName ?? FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? 'User'}',
                        style: DesignSystem.getLabelMd(
                          context,
                          color: theme.onSurfaceMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: theme.defaultAccent,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${appState.streak}',
                            style: DesignSystem.getBodyMd(
                              context,
                              color: theme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Today's Total",
                        style: DesignSystem.getLabelMd(
                          context,
                          color: theme.onSurfaceMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDuration(appState.todayTotalFocus),
                        style: DesignSystem.getBodyMd(
                          context,
                          color: theme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 80),

              // Timer Readout Display
              Center(
                child: GestureDetector(
                  onTap: () => _showDurationPicker(context, appState),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: 'Tap to change duration',
                      child: Text(
                        _formatTimerReadout(appState.initialTimerDuration),
                        style: DesignSystem.getDisplay(context, color: Colors.white).copyWith(
                          fontSize: 72,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 80),

              // Category Chips Section
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 12,
                children: [
                  ...appState.categories.map((cat) {
                    final isSelected = appState.activeCategory == cat;
                    return _buildCategoryChip(
                      context: context,
                      label: cat,
                      isSelected: isSelected,
                      accentColor: theme.defaultAccent,
                      onTap: () => appState.setActiveCategory(cat),
                    );
                  }),
                  _buildAddCustomChip(context, theme.defaultAccent, appState),
                ],
              ),

              const SizedBox(height: 60),

              // Primary Action (START button)
              Center(
                child: SizedBox(
                  width: 240,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      appState.startTimer(appState.initialTimerDuration);
                    },
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 24,
                    ),
                    label: const Text(
                      'START',
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 2.0,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // Recent Session Card
              if (appState.recentSessions.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildRecentSessionCard(context, appState.recentSessions.first, theme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.15) : const Color(0x0AFFFFFF),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0x1AFFFFFF),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          label,
          style: DesignSystem.getLabelMd(
            context,
            color: isSelected ? accentColor : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAddCustomChip(BuildContext context, Color accentColor, AppState appState) {
    return GestureDetector(
      onTap: () => _showCustomCategoryDialog(context, appState),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          border: Border.all(
            color: const Color(0x1AFFFFFF),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 14),
            const SizedBox(width: 4),
            Text(
              'Custom',
              style: DesignSystem.getLabelMd(context, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomCategoryDialog(BuildContext context, AppState appState) {
    final textController = TextEditingController();
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
            'New Category',
            style: DesignSystem.getHeadlineMd(context, color: Colors.white),
          ),
          content: TextField(
            controller: textController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter category name',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0x1AFFFFFF)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: theme.defaultAccent),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: DesignSystem.getLabelMd(context, color: theme.onSurfaceMuted),
              ),
            ),
            TextButton(
              onPressed: () {
                final name = textController.text.trim();
                if (name.isNotEmpty) {
                  appState.addCustomCategory(name);
                  appState.setActiveCategory(name);
                }
                Navigator.pop(context);
              },
              child: Text(
                'ADD',
                style: DesignSystem.getLabelMd(context, color: theme.defaultAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentSessionCard(BuildContext context, FocusSession session, AppThemeData theme) {
    IconData getIcon(String category) {
      switch (category.toLowerCase()) {
        case 'coding':
          return Icons.code;
        case 'study':
          return Icons.school;
        case 'reading':
          return Icons.menu_book;
        default:
          return Icons.timer;
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x0AFFFFFF),
            ),
            child: Icon(
              getIcon(session.category),
              color: theme.defaultAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.category,
                  style: DesignSystem.getBodyMd(
                    context,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDuration(session.duration),
                  style: DesignSystem.getLabelSm(
                    context,
                    color: theme.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            session.timeDisplay,
            style: DesignSystem.getLabelSm(
              context,
              color: theme.onSurfaceMuted,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimerReadout(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _showDurationPicker(BuildContext context, AppState appState) {
    final theme = appState.theme;
    int selectedHours = appState.initialTimerDuration.inHours;
    int selectedMinutes = appState.initialTimerDuration.inMinutes.remainder(60);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Set Focus Duration',
                    style: DesignSystem.getHeadlineMd(context, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hours Selector
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                            onPressed: () {
                              setModalState(() {
                                selectedHours = (selectedHours + 1) % 24;
                              });
                            },
                          ),
                          Text(
                            selectedHours.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            onPressed: () {
                              setModalState(() {
                                selectedHours = (selectedHours - 1 + 24) % 24;
                              });
                            },
                          ),
                          Text('HOURS', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted)),
                        ],
                      ),
                      const SizedBox(width: 40),
                      const Text(
                        ':',
                        style: TextStyle(fontSize: 48, color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 40),
                      // Minutes Selector
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white),
                            onPressed: () {
                              setModalState(() {
                                selectedMinutes = (selectedMinutes + 5) % 60;
                              });
                            },
                          ),
                          Text(
                            selectedMinutes.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            onPressed: () {
                              setModalState(() {
                                selectedMinutes = (selectedMinutes - 5 + 60) % 60;
                              });
                            },
                          ),
                          Text('MINUTES', style: DesignSystem.getLabelSm(context, color: theme.onSurfaceMuted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'CANCEL',
                          style: DesignSystem.getLabelMd(context, color: theme.onSurfaceMuted),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedHours == 0 && selectedMinutes == 0) {
                            return;
                          }
                          appState.setInitialTimerDuration(Duration(
                            hours: selectedHours,
                            minutes: selectedMinutes,
                          ));
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.defaultAccent,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(
                          'APPLY',
                          style: DesignSystem.getLabelMd(context, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
