import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/design_system.dart';
import '../widgets/glass_card.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  bool _showControls = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    // 6-second loop for the floating animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Briefly show controls on entry, then auto-hide
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerShowControls();
    });
  }

  void _triggerShowControls() {
    setState(() {
      _showControls = true;
    });
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    // Format remaining time
    final hours = appState.currentTimerDuration.inHours.toString().padLeft(2, '0');
    final minutes = appState.currentTimerDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = appState.currentTimerDuration.inSeconds.remainder(60).toString().padLeft(2, '0');

    // Breathing status dot color
    final dotColor = theme.defaultAccent;

    return Scaffold(
      backgroundColor: Colors.black, // Dark AMOLED base
      body: GestureDetector(
        onTap: _triggerShowControls,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // Center Floating Digits
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours
                  _buildFloatingDigit(
                    digit: hours,
                    textColor: Colors.white,
                    controller: _floatController,
                    delayOffset: 0.0, // no delay
                  ),
                  const SizedBox(height: 8),
                  // Minutes
                  _buildFloatingDigit(
                    digit: minutes,
                    textColor: Colors.white,
                    controller: _floatController,
                    delayOffset: 0.33, // 1/3 cycle offset
                  ),
                  const SizedBox(height: 8),
                  // Seconds
                  _buildFloatingDigit(
                    digit: seconds,
                    textColor: Colors.white.withValues(alpha: 0.4), // Muted outline style
                    controller: _floatController,
                    delayOffset: 0.66, // 2/3 cycle offset
                  ),
                ],
              ),
            ),

            // Top Status Overlay (Always centered, non-interactive)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'FOCUS MODE',
                  style: DesignSystem.getLabelSm(
                    context,
                    color: Colors.white.withValues(alpha: 0.3),
                  ).copyWith(letterSpacing: 4.0),
                ),
              ),
            ),

            // Bottom Actions & Metrics Panel
            Positioned(
              bottom: 60,
              left: 24,
              right: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Floating Control Pill
                  AnimatedOpacity(
                    opacity: _showControls ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !_showControls,
                      child: Center(
                        child: GlassCard(
                          borderRadius: 9999, // Pill shape
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Pause / Play Button
                              IconButton(
                                icon: Icon(
                                  appState.isTimerPaused ? Icons.play_arrow : Icons.pause,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  if (appState.isTimerPaused) {
                                    appState.resumeTimer();
                                  } else {
                                    appState.pauseTimer();
                                  }
                                  _triggerShowControls(); // Reset timer on interaction
                                },
                              ),
                              // Vertical Divider
                              Container(
                                width: 1,
                                height: 32,
                                color: Colors.white.withValues(alpha: 0.15),
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              // Stop Button
                              IconButton(
                                icon: Icon(
                                  Icons.stop,
                                  color: theme.error,
                                  size: 28,
                                ),
                                onPressed: () {
                                  _showStopConfirmationDialog(context, appState);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bottom Status (Breathing Dot + Progress)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBreathingDot(dotColor),
                      const SizedBox(width: 8),
                      Text(
                        'DEEP ${appState.activeCategory.toUpperCase()} • ${appState.focusProgressPercent.round()}%',
                        style: DesignSystem.getLabelMd(
                          context,
                          color: theme.onSurfaceMuted,
                        ).copyWith(
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Today Total
                  Text(
                    'TODAY ${_formatDuration(appState.todayTotalFocus)}',
                    style: DesignSystem.getLabelSm(
                      context,
                      color: theme.onSurfaceMuted.withValues(alpha: 0.5),
                    ).copyWith(letterSpacing: 1.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  Widget _buildFloatingDigit({
    required String digit,
    required Color textColor,
    required AnimationController controller,
    required double delayOffset,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Compute breathing/floating translation using a sine wave
        final t = (controller.value + delayOffset) % 1.0;
        final dy = -8.0 * math.sin(t * 2 * math.pi);

        return Transform.translate(
          offset: Offset(0, dy),
          child: Text(
            digit,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 108,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 0.95,
              letterSpacing: -6.0,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreathingDot(Color dotColor) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0),
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      onEnd: () {},
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor.withValues(alpha: value),
            boxShadow: [
              BoxShadow(
                color: dotColor.withValues(alpha: value * 0.8),
                blurRadius: 8 * value,
                spreadRadius: 1,
              )
            ],
          ),
        );
      },
      // Loop the breathing animation indefinitely
      // By using a local key, it will rebuild and trigger end callback to repeat.
      key: UniqueKey(),
    );
  }

  void _showStopConfirmationDialog(BuildContext context, AppState appState) {
    final theme = appState.theme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0x1AFFFFFF)),
          ),
          title: Text(
            'End Session?',
            style: DesignSystem.getHeadlineMd(context, color: Colors.white),
          ),
          content: Text(
            'Would you like to save the elapsed focus time to your statistics?',
            style: DesignSystem.getBodyMd(context, color: theme.onSurfaceMuted),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                appState.stopTimer(false); // Discard
              },
              child: Text(
                'DISCARD',
                style: DesignSystem.getLabelMd(context, color: theme.error),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                appState.stopTimer(true); // Save
              },
              child: Text(
                'SAVE & END',
                style: DesignSystem.getLabelMd(context, color: theme.defaultAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
