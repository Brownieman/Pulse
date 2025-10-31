import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/theme_controller.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'App Theme',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onBackground),
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
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.palette,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Customize the look and feel of your app',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Theme Mode
          Text(
            'THEME MODE',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() => _buildThemeModeCard(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Easy on the eyes',
                value: ThemeMode.dark,
                currentValue: controller.themeMode,
                onTap: () => controller.setThemeMode(ThemeMode.dark),
              )),
          const SizedBox(height: 8),
          Obx(() => _buildThemeModeCard(
                icon: Icons.light_mode,
                title: 'Light Mode',
                subtitle: 'Bright and clear',
                value: ThemeMode.light,
                currentValue: controller.themeMode,
                onTap: () => controller.setThemeMode(ThemeMode.light),
              )),
          const SizedBox(height: 8),
          Obx(() => _buildThemeModeCard(
                icon: Icons.brightness_auto,
                title: 'System Default',
                subtitle: 'Follow system settings',
                value: ThemeMode.system,
                currentValue: controller.themeMode,
                onTap: () => controller.setThemeMode(ThemeMode.system),
              )),
          const SizedBox(height: 24),

          // Accent Color
          Text(
            'ACCENT COLOR',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your accent color',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildColorOption(
                          color: const Color(0xFF2196F3),
                          label: 'Blue',
                          value: 'blue',
                          currentValue: controller.accentColor,
                          onTap: () => controller.setAccentColor('blue'),
                        ),
                        _buildColorOption(
                          color: const Color(0xFF9C27B0),
                          label: 'Purple',
                          value: 'purple',
                          currentValue: controller.accentColor,
                          onTap: () => controller.setAccentColor('purple'),
                        ),
                        _buildColorOption(
                          color: const Color(0xFF4CAF50),
                          label: 'Green',
                          value: 'green',
                          currentValue: controller.accentColor,
                          onTap: () => controller.setAccentColor('green'),
                        ),
                        _buildColorOption(
                          color: const Color(0xFFFF9800),
                          label: 'Orange',
                          value: 'orange',
                          currentValue: controller.accentColor,
                          onTap: () => controller.setAccentColor('orange'),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeModeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeMode value,
    required ThemeMode currentValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentValue;
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withOpacity(0.2)
                        : colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorOption({
    required Color color,
    required String label,
    required String value,
    required String currentValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentValue;
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? colorScheme.onSurface : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: isSelected ? 2 : 0,
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 30)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
