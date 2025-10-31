import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/main_controller.dart';
import 'package:talkzy_beta1/controllers/home_controller.dart';
import 'package:talkzy_beta1/controllers/friends_controller.dart';
import 'package:talkzy_beta1/controllers/friend_requests_controller.dart';
import 'package:talkzy_beta1/controllers/profile_controller.dart';
import 'package:talkzy_beta1/views/home_view.dart';
import 'package:talkzy_beta1/views/friends_view.dart';
import 'package:talkzy_beta1/views/friend_requests_view.dart';
import 'package:talkzy_beta1/theme/app_theme.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers for each tab
    Get.put(HomeController());
    Get.put(FriendsController());
    Get.put(FriendRequestsController());
    Get.put(ProfileController());

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.selectedIndex,
        children: [
          const HomeView(),
          FriendsView(),
          FriendRequestsView(),
          _buildProfileTab(),
        ],
      )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex,
        onTap: controller.changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_outlined),
            activeIcon: Icon(Icons.person_add),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 100, color: AppTheme.primaryColor),
          const SizedBox(height: 16),
          const Text(
            'Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Profile screen coming soon'),
        ],
      ),
    );
  }
}
