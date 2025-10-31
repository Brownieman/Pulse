import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/settings_controller.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1021),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1021),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Privacy & Security',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2439),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2196F3).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.privacy_tip,
                  color: const Color(0xFF2196F3),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Control who can see your information',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Activity Status
          const Text(
            'ACTIVITY STATUS',
            style: TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => _buildSwitchTile(
                icon: Icons.access_time,
                title: 'Show Last Seen',
                subtitle: 'Let others see when you were last active',
                value: controller.showLastSeen,
                onChanged: (value) {
                  controller.updatePrivacySettings(showLastSeen: value);
                },
              )),
          const SizedBox(height: 8),
          Obx(() => _buildSwitchTile(
                icon: Icons.done_all,
                title: 'Read Receipts',
                subtitle: 'Let others know when you\'ve read their messages',
                value: controller.readReceipts,
                onChanged: (value) {
                  controller.updatePrivacySettings(readReceipts: value);
                },
              )),
          const SizedBox(height: 24),

          // Profile Visibility
          const Text(
            'PROFILE VISIBILITY',
            style: TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => _buildVisibilityTile(
                icon: Icons.photo_camera,
                title: 'Profile Photo',
                subtitle: 'Who can see your profile photo',
                currentValue: controller.profilePhotoVisibility,
                onChanged: (value) {
                  controller.updatePrivacySettings(profilePhotoVisibility: value);
                },
              )),
          const SizedBox(height: 8),
          Obx(() => _buildVisibilityTile(
                icon: Icons.info,
                title: 'Bio',
                subtitle: 'Who can see your bio',
                currentValue: controller.bioVisibility,
                onChanged: (value) {
                  controller.updatePrivacySettings(bioVisibility: value);
                },
              )),
          const SizedBox(height: 24),

          // Blocked Users
          const Text(
            'BLOCKED USERS',
            style: TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1C2439),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1021),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.block, color: Colors.red, size: 24),
              ),
              title: const Text(
                'Blocked Users',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Obx(() {
                final blockedCount = controller.userModel?.blockedUsers.length ?? 0;
                return Text(
                  '$blockedCount blocked user${blockedCount != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                );
              }),
              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF64748B), size: 18),
              onTap: () {
                // TODO: Navigate to blocked users list
                Get.snackbar(
                  'Coming Soon',
                  'Blocked users management will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  colorText: Colors.orange,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2439),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2196F3),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1021),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2196F3), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String currentValue,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2439),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1021),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2196F3), size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF64748B),
            fontSize: 13,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatVisibility(currentValue),
              style: const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF64748B), size: 18),
          ],
        ),
        onTap: () => _showVisibilityDialog(title, currentValue, onChanged),
      ),
    );
  }

  String _formatVisibility(String value) {
    switch (value) {
      case 'everyone':
        return 'Everyone';
      case 'friends':
        return 'Friends';
      case 'nobody':
        return 'Nobody';
      default:
        return 'Everyone';
    }
  }

  void _showVisibilityDialog(String title, String currentValue, Function(String) onChanged) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1C2439),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Who can see your $title?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildVisibilityOption('Everyone', 'everyone', currentValue, onChanged),
              _buildVisibilityOption('Friends Only', 'friends', currentValue, onChanged),
              _buildVisibilityOption('Nobody', 'nobody', currentValue, onChanged),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisibilityOption(String label, String value, String currentValue, Function(String) onChanged) {
    final isSelected = value == currentValue;
    return InkWell(
      onTap: () {
        onChanged(value);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3).withOpacity(0.2) : const Color(0xFF0A1021),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF2196F3) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
