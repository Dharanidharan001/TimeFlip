import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../theme/design_system.dart';
import '../../widgets/glass_card.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          // Background Gradient Blob 1
          Positioned(
            top: -100,
            left: -100,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 350 * _glowAnimation.value,
                  height: 350 * _glowAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.defaultAccent.withValues(alpha: 0.15),
                    boxShadow: [
                      BoxShadow(
                        color: theme.defaultAccent.withValues(alpha: 0.25),
                        blurRadius: 100,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // Background Gradient Blob 2
          Positioned(
            bottom: -50,
            right: -50,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 300 * _glowAnimation.value,
                  height: 300 * _glowAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.defaultAccent.withValues(alpha: 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: theme.defaultAccent.withValues(alpha: 0.15),
                        blurRadius: 80,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // Main Layout Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            // App branding header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'FocusFlip',
                                  style: DesignSystem.getLabelSm(
                                    context,
                                    color: theme.onSurfaceMuted.withValues(alpha: 0.6),
                                  ).copyWith(
                                    fontSize: 14,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Glowing Center Emblem
                            AnimatedBuilder(
                              animation: _glowAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: 1.0 + (_glowAnimation.value - 1.0) * 0.05,
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0x05FFFFFF),
                                      border: Border.all(
                                        color: theme.defaultAccent.withValues(alpha: 0.3),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.defaultAccent.withValues(alpha: 0.2),
                                          blurRadius: 40,
                                          spreadRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Rotating visual layer
                                          RotationTransition(
                                            turns: _controller,
                                            child: Container(
                                              width: 110,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: theme.defaultAccent.withValues(alpha: 0.15),
                                                  width: 4,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.hourglass_empty_rounded,
                                            size: 64,
                                            color: theme.defaultAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 48),

                            // Titles and description
                            Text(
                              'FocusFlip',
                              textAlign: TextAlign.center,
                              style: DesignSystem.getDisplay(context, color: Colors.white).copyWith(
                                letterSpacing: -1.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Master your time, shape your focus.',
                              textAlign: TextAlign.center,
                              style: DesignSystem.getHeadlineMd(
                                context,
                                color: theme.defaultAccent,
                              ).copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'A premium glassmorphic focus companion designed to help you stay productive, trace session timelines, and build daily habits.',
                                textAlign: TextAlign.center,
                                style: DesignSystem.getBodyMd(
                                  context,
                                  color: theme.onSurfaceMuted,
                                ).copyWith(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const Spacer(),

                            // Bottom buttons section
                            GlassCard(
                              padding: const EdgeInsets.all(20),
                              borderRadius: 24,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Sign In button
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const SignInScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'SIGN IN',
                                      style: DesignSystem.getLabelMd(
                                        context,
                                        color: Colors.black,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Create Account button
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.white.withValues(alpha: 0.15),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'CREATE ACCOUNT',
                                      style: DesignSystem.getLabelMd(
                                        context,
                                        color: Colors.white,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
