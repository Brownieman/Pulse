import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talkzy_beta1/controllers/settings_controller.dart';
import 'package:talkzy_beta1/controllers/auth_controller.dart';
import 'package:talkzy_beta1/screens/settings/profile_settings_screen.dart';
import 'package:talkzy_beta1/screens/settings/password_settings_screen.dart';
import 'package:talkzy_beta1/screens/settings/notifications_settings_screen.dart';
import 'package:talkzy_beta1/screens/settings/privacy_settings_screen.dart';
import 'package:talkzy_beta1/screens/settings/theme_settings_screen.dart';
import 'package:talkzy_beta1/screens/settings/help_support_screen.dart';
import 'package:talkzy_beta1/routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize SettingsController if not already registered
    if (!Get.isRegistered<SettingsController>()) {
      _controller = Get.put(SettingsController());
    } else {
      _controller = Get.find<SettingsController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = _controller.userModel;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Settings',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).colorScheme.onBackground),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          children: [
            const SizedBox(height: 8),
            // User Profile Header
            if (user != null)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    backgroundImage: user.photoURL.isNotEmpty
                        ? NetworkImage(user.photoURL)
                        : null,
                    child: user.photoURL.isEmpty
                        ? Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Text('ACCOUNT',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2)),
          const SizedBox(height: 16),
          ListTile(
            leading: CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.person, color: Colors.white)),
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Manage your profile',
                style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileSettingsScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.vpn_key, color: Theme.of(context).colorScheme.primary),
            ),
            title: const Text('Password',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Change your password',
                style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PasswordSettingsScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFFFF3B30),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.logout, color: Colors.white),
            ),
            title: const Text('Logout',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Sign out of your account',
                style: TextStyle(color: Colors.white54)),
            onTap: () async {
              // Show confirmation dialog
              final confirmed = await Get.dialog<bool>(
                AlertDialog(
                  backgroundColor: const Color(0xFF1C2439),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Color(0xFF90CAF9)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                try {
                  final authController = Get.find<AuthController>();
                  await authController.signOut();
                } catch (e) {
                  // Fallback to Firebase Auth directly
                  await FirebaseAuth.instance.signOut();
                  Get.offAllNamed(AppRoutes.login);
                }
              }
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          const SizedBox(height: 28),
          Text('GENERAL',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2)),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF19232F),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.notifications, color: Color(0xFF2196F3)),
            ),
            title: const Text('Notifications',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Customize your alerts',
                style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsSettingsScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF19232F),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.privacy_tip, color: Color(0xFF2196F3)),
            ),
            title: const Text('Privacy',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Manage data and security',
                style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacySettingsScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF19232F),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.brightness_6, color: Color(0xFF2196F3)),
            ),
            title: const Text('App Theme',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Choose your look and feel',
                style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemeSettingsScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          const SizedBox(height: 28),
          Text('SUPPORT',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2)),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF19232F),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.help_outline, color: Color(0xFF2196F3)),
            ),
            title: const Text('Help & Support',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Get assistance and find answers',
                style: TextStyle(color: Colors.white54)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
        ],
      ),
    );
    });
  }
}
