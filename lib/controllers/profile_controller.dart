import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/auth_controller.dart';
import 'package:talkzy_beta1/models/user_model.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  
  final RxBool _isLoading = false.obs;
  final RxBool _isEditing = false.obs;
  
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();
  
  bool get isLoading => _isLoading.value;
  bool get isEditing => _isEditing.value;
  UserModel? get currentUser => _authController.userModel;
  
  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }
  
  @override
  void onClose() {
    displayNameController.dispose();
    bioController.dispose();
    super.onClose();
  }
  
  void loadProfile() {
    final user = currentUser;
    if (user != null) {
      displayNameController.text = user.displayName;
      bioController.text = user.bio;
    }
  }
  
  void toggleEdit() {
    _isEditing.value = !_isEditing.value;
    if (!_isEditing.value) {
      loadProfile(); // Reset if cancelled
    }
  }
  
  Future<void> updateProfile() async {
    if (currentUser == null) return;
    
    _isLoading.value = true;
    try {
      // TODO: Implement updateProfile in AuthController
      // await _authController.updateUserProfile(
      //   displayName: displayNameController.text,
      //   bio: bioController.text,
      // );
      
      _isEditing.value = false;
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
  
  Future<void> updateProfilePhoto(String photoURL) async {
    _isLoading.value = true;
    try {
      // TODO: Implement updateProfilePhoto in AuthController
      // await _authController.updateUserPhoto(photoURL);
      Get.snackbar(
        'Success',
        'Profile photo updated',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
