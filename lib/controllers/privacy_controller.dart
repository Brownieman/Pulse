import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/auth_controller.dart';

class PrivacyController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  
  final RxBool _showOnlineStatus = true.obs;
  final RxBool _showLastSeen = true.obs;
  final RxString _profilePhotoVisibility = 'everyone'.obs;
  final RxString _bioVisibility = 'everyone'.obs;
  
  bool get showOnlineStatus => _showOnlineStatus.value;
  bool get showLastSeen => _showLastSeen.value;
  String get profilePhotoVisibility => _profilePhotoVisibility.value;
  String get bioVisibility => _bioVisibility.value;
  
  @override
  void onInit() {
    super.onInit();
    loadPrivacySettings();
  }
  
  Future<void> loadPrivacySettings() async {
    final user = _authController.userModel;
    if (user != null) {
      _showLastSeen.value = user.showLastSeen;
      _profilePhotoVisibility.value = user.profilePhotoVisibility;
      _bioVisibility.value = user.bioVisibility;
    }
  }
  
  Future<void> updateOnlineStatus(bool value) async {
    _showOnlineStatus.value = value;
    // TODO: Update in Firestore
  }
  
  Future<void> updateLastSeen(bool value) async {
    _showLastSeen.value = value;
    // TODO: Update in Firestore
  }
  
  Future<void> updateProfilePhotoVisibility(String value) async {
    _profilePhotoVisibility.value = value;
    // TODO: Update in Firestore
  }
  
  Future<void> updateBioVisibility(String value) async {
    _bioVisibility.value = value;
    // TODO: Update in Firestore
  }
}
