import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';
import '../../theme/design_system.dart';
import '../../widgets/glass_card.dart';
import 'sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    final theme = Provider.of<AppState>(context, listen: false).theme;
    if (_formKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (credential.user != null) {
          await credential.user!.updateDisplayName(_nameController.text.trim());
          
          // Create user document in Firestore database
          await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
            'uid': credential.user!.uid,
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
            'streak': 0,
            'todayTotalFocusSeconds': 0,
            'lastFocusDate': '',
          });
        }

        if (!mounted) return;
        Navigator.of(context).pop(); // Dismiss loading

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        if (!mounted) return;
        Navigator.of(context).pop(); // Dismiss loading
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign Up Failed: ${e.toString().split(']').last.trim()}"),
            backgroundColor: theme.error,
          ),
        );
      }
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
            top: 200,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
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
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: DesignSystem.getDisplay(context, color: Colors.white).copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start your focus journey today.',
                          style: DesignSystem.getBodyMd(
                            context,
                            color: theme.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sign Up Form Card
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
                                // Full Name Field
                                TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                  style: DesignSystem.getBodyMd(context, color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Full Name',
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
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

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
                                const SizedBox(height: 20),

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
                                      return 'Please enter a password';
                                    }
                                    if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Confirm Password Field
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  style: DesignSystem.getBodyMd(context, color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password',
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
                                        _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                        color: theme.onSurfaceMuted,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),

                                // Sign Up Button
                                ElevatedButton(
                                  onPressed: _handleSignUp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'SIGN UP',
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
                        const Spacer(),

                        // Bottom Redirect Link
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: DesignSystem.getBodyMd(
                                  context,
                                  color: theme.onSurfaceMuted,
                                ).copyWith(fontSize: 14),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to SignInScreen, replacing current SignUpScreen
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const SignInScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign In',
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
