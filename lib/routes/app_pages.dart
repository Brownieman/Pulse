import 'package:get/get.dart';

import '../routes/app_routes.dart';

import '../views/main_view.dart';
import '../views/home_view.dart';
import '../views/chat_view.dart';
import '../views/friends_view.dart';
import '../views/friend_requests_view.dart';
import '../views/find_people_view.dart';
import '../views/notification_view.dart';
import '../screens/auth_screen.dart';

import '../controllers/main_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/friends_controller.dart';
import '../controllers/friend_requests_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/user_list_controller.dart';
import '../controllers/notification_controller.dart';

class AppPages {
  static final pages = <GetPage<dynamic>>[
  
   
    // For now, route both login and register to the existing AuthScreen
    GetPage(
      name: AppRoutes.login,
      page: () => const AuthScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const AuthScreen(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => MainView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<MainController>()) Get.put(MainController());
        if (!Get.isRegistered<HomeController>()) Get.put(HomeController());
        if (!Get.isRegistered<FriendsController>()) Get.put(FriendsController());
        if (!Get.isRegistered<FriendRequestsController>()) {
          Get.put(FriendRequestsController());
        }
        if (!Get.isRegistered<ProfileController>()) Get.put(ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) Get.put(HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
    ),
    GetPage(
      name: AppRoutes.friends,
      page: () => FriendsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<FriendsController>()) Get.put(FriendsController());
      }),
    ),
    GetPage(
      name: AppRoutes.friendRequests,
      page: () => FriendRequestsView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<FriendRequestsController>()) {
          Get.put(FriendRequestsController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.findPeople,
      page: () => FindPeopleView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<UserListController>()) Get.put(UserListController());
      }),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<NotificationController>()) {
          Get.put(NotificationController());
        }
      }),
    ),
  ];
}
