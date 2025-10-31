import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';
import 'screens/dashboard_screen.dart' as dash;
import 'screens/servers_screen.dart' as servers;
import 'screens/settings_screen.dart';
import 'screens/task_list_screen.dart';
import 'controllers/home_controller.dart';
import 'controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print('HomeScreen initState called'); // DEBUG

    // Initialize GetX controllers if not already registered
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController());
    }
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const HomeView();
      case 1:
        return const TaskListScreen();
      case 2:
        return const servers.ServersScreen();
      case 3:
        return const dash.DashboardScreen();
      case 4:
        return const SettingsScreen();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HomeScreen build: currentIndex = $_currentIndex'); // DEBUG
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          print('BottomNavigationBar onTap: index = $index'); // DEBUG
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined), label: 'Servers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.show_chart), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
