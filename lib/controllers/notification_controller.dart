import 'package:get/get.dart';
import 'package:talkzy_beta1/models/notification_model.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> _notifications = <NotificationModel>[].obs;
  final RxBool _isLoading = false.obs;
  
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }
  
  Future<void> loadNotifications() async {
    _isLoading.value = true;
    try {
      // TODO: Load from Firestore
      // final notifications = await _firestoreService.getNotifications();
      // _notifications.assignAll(notifications);
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> markAsRead(String notificationId) async {
    try {
      // TODO: Mark as read in Firestore
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        _notifications.refresh();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
  
  Future<void> clearAll() async {
    try {
      // TODO: Clear from Firestore
      _notifications.clear();
    } catch (e) {
      print('Error clearing notifications: $e');
    }
  }
}
