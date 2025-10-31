import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talkzy_beta1/models/user_model.dart';
import 'package:talkzy_beta1/services/firestore_service.dart';

class SettingsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable state
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  // Notification settings
  final RxBool _messageNotifications = true.obs;
  final RxBool _friendRequestNotifications = true.obs;
  final RxBool _soundEnabled = true.obs;
  final RxBool _vibrationEnabled = true.obs;

  // Privacy settings
  final RxBool _showLastSeen = true.obs;
  final RxBool _readReceipts = true.obs;
  final RxString _profilePhotoVisibility = 'everyone'.obs;
  final RxString _bioVisibility = 'everyone'.obs;

  // Getters
  UserModel? get userModel => _userModel.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get messageNotifications => _messageNotifications.value;
  bool get friendRequestNotifications => _friendRequestNotifications.value;
  bool get soundEnabled => _soundEnabled.value;
  bool get vibrationEnabled => _vibrationEnabled.value;
  bool get showLastSeen => _showLastSeen.value;
  bool get readReceipts => _readReceipts.value;
  String get profilePhotoVisibility => _profilePhotoVisibility.value;
  String get bioVisibility => _bioVisibility.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadSettings();
  }

  Future<void> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _firestoreService.getUser(user.uid);
        if (userData != null) {
          _userModel.value = userData;
          // Load privacy settings from user model
          _showLastSeen.value = userData.showLastSeen;
          _readReceipts.value = userData.readReceipts;
          _profilePhotoVisibility.value = userData.profilePhotoVisibility;
          _bioVisibility.value = userData.bioVisibility;
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      _error.value = 'Failed to load user data';
    }
  }

  Future<void> loadSettings() async {
    // Load settings from local storage (SharedPreferences)
    // For now, using default values
    // TODO: Implement SharedPreferences for persistent storage
  }

  // Profile updates
  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? photoURL,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final user = _auth.currentUser;
      if (user != null && _userModel.value != null) {
        // Update Firebase Auth profile
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }

        // Update Firestore
        final updatedUser = _userModel.value!.copyWith(
          displayName: displayName ?? _userModel.value!.displayName,
          bio: bio ?? _userModel.value!.bio,
          photoURL: photoURL ?? _userModel.value!.photoURL,
        );

        await _firestoreService.updateUser(updatedUser);
        _userModel.value = updatedUser;

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      _error.value = 'Failed to update profile';
      Get.snackbar(
        'Error',
        _error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Password change
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate user
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(newPassword);

        Get.snackbar(
          'Success',
          'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
        Get.back();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _error.value = 'Current password is incorrect';
      } else if (e.code == 'weak-password') {
        _error.value = 'New password is too weak';
      } else {
        _error.value = 'Failed to change password';
      }
      Get.snackbar(
        'Error',
        _error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Notification settings
  void toggleMessageNotifications(bool value) {
    _messageNotifications.value = value;
    // TODO: Save to SharedPreferences
  }

  void toggleFriendRequestNotifications(bool value) {
    _friendRequestNotifications.value = value;
    // TODO: Save to SharedPreferences
  }

  void toggleSound(bool value) {
    _soundEnabled.value = value;
    // TODO: Save to SharedPreferences
  }

  void toggleVibration(bool value) {
    _vibrationEnabled.value = value;
    // TODO: Save to SharedPreferences
  }

  // Privacy settings
  Future<void> updatePrivacySettings({
    bool? showLastSeen,
    bool? readReceipts,
    String? profilePhotoVisibility,
    String? bioVisibility,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      if (_userModel.value != null) {
        final updatedUser = _userModel.value!.copyWith(
          showLastSeen: showLastSeen ?? _userModel.value!.showLastSeen,
          readReceipts: readReceipts ?? _userModel.value!.readReceipts,
          profilePhotoVisibility: profilePhotoVisibility ?? _userModel.value!.profilePhotoVisibility,
          bioVisibility: bioVisibility ?? _userModel.value!.bioVisibility,
        );

        await _firestoreService.updateUser(updatedUser);
        _userModel.value = updatedUser;

        // Update local state
        if (showLastSeen != null) _showLastSeen.value = showLastSeen;
        if (readReceipts != null) _readReceipts.value = readReceipts;
        if (profilePhotoVisibility != null) _profilePhotoVisibility.value = profilePhotoVisibility;
        if (bioVisibility != null) _bioVisibility.value = bioVisibility;

        Get.snackbar(
          'Success',
          'Privacy settings updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      _error.value = 'Failed to update privacy settings';
      Get.snackbar(
        'Error',
        _error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void clearError() {
    _error.value = '';
  }
}
