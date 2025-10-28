import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1021),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1021),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        children: [
          const SizedBox(height: 8),
          const Text('ACCOUNT',
              style: TextStyle(
                  color: Color(0xFF2196F3),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2)),
          const SizedBox(height: 16),
          ListTile(
            leading: const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF2196F3),
                child: Icon(Icons.person, color: Colors.white)),
            title: const Text('Profile',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Manage your profile',
                style: TextStyle(color: Colors.white54)),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF19232F),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.vpn_key, color: Color(0xFF2196F3)),
            ),
            title: const Text('Password',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            subtitle: const Text('Change your password',
                style: TextStyle(color: Colors.white54)),
            onTap: () {},
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
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          const SizedBox(height: 28),
          const Text('GENERAL',
              style: TextStyle(
                  color: Color(0xFF2196F3),
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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
          const SizedBox(height: 28),
          const Text('SUPPORT',
              style: TextStyle(
                  color: Color(0xFF2196F3),
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
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white24, size: 18),
          ),
        ],
      ),
    );
  }
}
