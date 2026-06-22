import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../theme/design_system.dart';
import '../../widgets/glass_card.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'alex@focusflip.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      // Access AppState and trigger login
      final appState = Provider.of<AppState>(context, listen: false);
      appState.login();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = appState.theme;

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          // Background Glow Blob
          Positioned(
            top: 150,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.defaultAccent.withValues(alpha: 0.08),
                boxShadow: [
                  BoxShadow(
                    color: theme.defaultAccent.withValues(alpha: 0.12),
                    blurRadius: 100,
                    spreadRadius: 20,
                  )
                ],
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top AppBar Override
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0x0AFFFFFF),
                              border: Border.all(
                                color: const Color(0x1AFFFFFF),
                                width: 1.0,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // App title muted
                        Text(
                          'FocusFlip',
                          style: DesignSystem.getLabelSm(
                            context,
                            color: theme.onSurfaceMuted.withValues(alpha: 0.5),
                          ).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance back button
                      ],
                    ),
                  ),
                ),

                // Welcome back header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: DesignSystem.getDisplay(context, color: Colors.white).copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Continue your focus journey.',
                          style: DesignSystem.getBodyMd(
                            context,
                            color: theme.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sign In Form Card
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
                    child: Column(
                      children: [
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          borderRadius: 20,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Email Field
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: DesignSystem.getBodyMd(context, color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Email Address',
                                    labelStyle: DesignSystem.getBodyMd(context, color: theme.onSurfaceMuted),
                                    floatingLabelStyle: TextStyle(color: theme.defaultAccent),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: theme.defaultAccent),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: theme.error),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: theme.error, width: 2),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Password Field
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: DesignSystem.getBodyMd(context, color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: DesignSystem.getBodyMd(context, color: theme.onSurfaceMuted),
                                    floatingLabelStyle: TextStyle(color: theme.defaultAccent),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: theme.defaultAccent),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: theme.error),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: theme.error, width: 2),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        color: theme.onSurfaceMuted,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Forgot Password Link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Simulated behavior
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Password reset link sent to your email.'),
                                          backgroundColor: theme.surfaceContainer,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: DesignSystem.getLabelSm(
                                        context,
                                        color: theme.defaultAccent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Sign In Button
                                ElevatedButton(
                                  onPressed: _handleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // OR divider
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Color(0x1AFFFFFF))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: DesignSystem.getLabelSm(
                                  context,
                                  color: theme.onSurfaceMuted.withValues(alpha: 0.6),
                                ).copyWith(letterSpacing: 1.5),
                              ),
                            ),
                            const Expanded(child: Divider(color: Color(0x1AFFFFFF))),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Google button
                        OutlinedButton(
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false).login();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0x05FFFFFF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/480px-Google_%22G%22_logo.svg.png',
                                height: 18,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Google',
                                style: DesignSystem.getLabelMd(context, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Apple button
                        OutlinedButton(
                          onPressed: () {
                            Provider.of<AppState>(context, listen: false).login();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0x05FFFFFF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.apple, color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Apple',
                                style: DesignSystem.getLabelMd(context, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // Bottom Redirect Link
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: DesignSystem.getBodyMd(
                                  context,
                                  color: theme.onSurfaceMuted,
                                ).copyWith(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to SignUpScreen, replacing current SignInScreen
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Create Account',
                                  style: DesignSystem.getLabelSm(
                                    context,
                                    color: theme.defaultAccent,
                                  ).copyWith(fontSize: 14, fontWeight: FontWeight.bold),
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
          ),
        ],
      ),
    );
  }
}
