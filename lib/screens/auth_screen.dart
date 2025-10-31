import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talkzy_beta1/controllers/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true; // true for Log In, false for Sign Up
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    // Validate inputs
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('🔐 _authenticate called');
    print('   Mode: ${isLogin ? "LOG IN" : "SIGN UP"}');
    print('   Email: $email');
    print('   Password length: ${password.length}');

    if (email.isEmpty || password.isEmpty) {
      print('❌ Validation failed: Empty email or password');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    if (!email.contains('@')) {
      print('❌ Validation failed: Invalid email format');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (password.length < 6) {
      print('❌ Validation failed: Password too short');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    print('✅ Validation passed');
    setState(() => _isLoading = true);
    try {
      // Get or create AuthController
      AuthController auth;
      try {
        auth = Get.find<AuthController>();
        print('✅ Found existing AuthController');
      } catch (e) {
        print('⚠️ Creating new AuthController');
        auth = Get.put(AuthController());
      }

      print('🔐 Starting authentication: ${isLogin ? "Sign In" : "Sign Up"}');
      print('📧 Email: $email');

      if (isLogin) {
        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final displayName = email.contains('@') ? email.split('@').first : email;
        await auth.registerWithEmailAndPassword(
          email: email,
          password: password,
          displayName: displayName,
        );
      }
      
      print('✅ Authentication successful');
    } catch (e) {
      print('❌ Authentication error: $e');
      if (mounted) {
        // Provide user-friendly error messages
        String errorMessage = e.toString();
        
        // Check for common authentication errors
        if (errorMessage.contains('user-not-found')) {
          errorMessage = 'No account found with this email. Please sign up first.';
        } else if (errorMessage.contains('wrong-password')) {
          errorMessage = 'Incorrect password. Please try again.';
        } else if (errorMessage.contains('email-already-in-use')) {
          errorMessage = 'This email is already registered. Please log in instead.';
        } else if (errorMessage.contains('invalid-email')) {
          errorMessage = 'Invalid email address. Please check and try again.';
        } else if (errorMessage.contains('weak-password')) {
          errorMessage = 'Password is too weak. Use at least 6 characters.';
        } else if (errorMessage.contains('network-request-failed')) {
          errorMessage = 'Network error. Please check your internet connection.';
        } else if (errorMessage.contains('too-many-requests')) {
          errorMessage = 'Too many attempts. Please try again later.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: errorMessage.contains('sign up') 
                ? SnackBarAction(
                    label: 'Sign Up',
                    textColor: Colors.white,
                    onPressed: () {
                      setState(() => isLogin = false);
                    },
                  )
                : null,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'your-app-scheme://auth/callback', // Adjust as needed
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _signInWithApple() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'your-app-scheme://auth/callback', // Adjust as needed
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Apple sign-in error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    
    // Responsive sizing based on screen dimensions
    final logoSize = screenWidth > 400 ? 80.0 : 64.0;
    final headlineSize = screenWidth > 400 ? 32.0 : 26.0;
    final horizontalPadding = screenWidth > 600 ? 32.0 : 16.0;
    final topSpacing = screenHeight > 800 ? 40.0 : 20.0;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - MediaQuery.of(context).padding.vertical - 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: topSpacing),
                // Logo - Responsive size
                Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                  size: logoSize,
                ),
                const SizedBox(height: 16),
                // Headline - Responsive size
                Text(
                  'Welcome to Pulse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: headlineSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Space Grotesk',
                  ),
                  textAlign: TextAlign.center,
                ),
                  const SizedBox(height: 32),
                // Segmented Buttons
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = true),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isLogin
                                  ? LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.primary.withOpacity(0.8)
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  color: isLogin
                                      ? Colors.white
                                      : colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isLogin = false),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: !isLogin
                                  ? LinearGradient(
                                      colors: [
                                        colorScheme.primary,
                                        colorScheme.primary.withOpacity(0.8)
                                      ],
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: !isLogin
                                      ? Colors.white
                                      : colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Helpful hint
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    isLogin 
                        ? 'Log in with your existing account' 
                        : 'Create a new account to get started',
                    style: TextStyle(
                      color: colorScheme.onBackground.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement forgot password
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Primary Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                isLogin ? 'Log In' : 'Sign Up',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: colorScheme.onSurface.withOpacity(0.2))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: colorScheme.onSurface.withOpacity(0.5), fontSize: 14),
                      ),
                    ),
                    Expanded(child: Divider(color: colorScheme.onSurface.withOpacity(0.2))),
                  ],
                ),
                const SizedBox(height: 24),
                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      onPressed: _signInWithGoogle,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuALXyssQaztu3RCUu2r_0mWbIOC0nXXhozpcOYLBa1OaBcE9Y7eespQ3e6a1OBJz--xU0gSSceXmICc-hA6nyqOLN_dGeI41Adp03Xs398VFJNYzcpAFo9NspzhUGVMaDQ1G8ArumlbqF1LoUCyGQhdIw4v2zQlY6oYNARqyBYJi25FxNBfYbm0LcXUYQEYkqmBVKOtHVDR2jyx3n-aRmvjHvqonrVaM_AQv_Icr1f1g6umW58pjl23bvfiZaADrJIT_eVZ2drXgWI',
                        height: 24,
                        width: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _socialButton(
                      onPressed: _signInWithApple,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB6HFCY_QcVzzXslF1Jz_QqiGDqK9xDe4_UQ8NgkKlspzjzJR0Iirv6AZK9BKDiXiOhBDXQTFU6L_7VoYoIIxNVTihEQLqdCk6X-puTz3JA9V161ZMu1m7kCHTR2k-GrxSGSUnt_EO-6fQ09dgk4KGws7i3VU_rgnnAXvC9HxG0PSFoHIVGmttnGRbJe6oD5rCyESbie9M5vpzUy73d9c7WgzucqK-MSGoWhnOpG4eSS92GIja_5NpCmkjj63QqmI9t5QeMosmtO-Q',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Footer
                Text(
                  'By signing up, you agree to our Terms of Service.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(
      {required VoidCallback onPressed, required Widget child}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(child: child),
      ),
    );
  }
}
