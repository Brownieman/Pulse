import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/models/user_model.dart';
import 'package:talkzy_beta1/routes/app_routes.dart';
import 'package:talkzy_beta1/services/firestore_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Observable user
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _userModel = Rx<UserModel?>(null);

  // State variables
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isEmailVerified = false.obs;

  // Getters
  User? get user => _firebaseUser.value;
  UserModel? get userModel => _userModel.value;
  Rx<User?> get rxUser => _firebaseUser;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isEmailVerified => _isEmailVerified.value;
  bool get isLoggedIn => _firebaseUser.value != null;

  @override
  void onInit() {
    super.onInit();
    // Bind Firebase user stream
    _firebaseUser.bindStream(_auth.authStateChanges());
    
    // Listen to auth state changes
    ever(_firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user == null) {
      _userModel.value = null;
      _isEmailVerified.value = false;
      print('🔐 User logged out');
    } else {
      _isEmailVerified.value = user.emailVerified;
      print('🔐 User logged in: ${user.email}');
      
      // Load user model from Firestore
      try {
        final userModel = await _firestoreService.getUser(user.uid);
        if (userModel != null) {
          _userModel.value = userModel;
          print('✅ User model loaded: ${userModel.displayName}');
        } else {
          print('⚠️ User model not found in Firestore');
        }
      } catch (e) {
        print('❌ Error loading user model: $e');
      }
    }
  }

  // Register with email and password
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    String? photoURL,
    String? bio,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);
        if (photoURL != null) {
          await user.updatePhotoURL(photoURL);
        }

        // Create user document in Firestore
        final userModel = UserModel(
          id: user.uid,
          email: email,
          displayName: displayName,
          photoURL: photoURL ?? '',
          bio: bio ?? '',
          isOnline: true,
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
          showLastSeen: true,
          readReceipts: true,
          profilePhotoVisibility: 'everyone',
          bioVisibility: 'everyone',
        );

        print('🔥 About to create Firestore user document...');
        try {
          await _firestoreService.createUser(userModel);
          _userModel.value = userModel;
          print('✅ Firestore user created successfully');
        } catch (firestoreError) {
          print('⚠️ Firestore error (continuing anyway): $firestoreError');
          // Set user model anyway so auth can proceed
          _userModel.value = userModel;
        }

        // Send email verification
        await user.sendEmailVerification();

        Get.snackbar(
          'Success',
          'Account created! Please verify your email.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 4),
        );

        // Navigate to home
        Get.offAllNamed(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      _error.value = _getErrorMessage(e.code);
      Get.snackbar(
        'Registration Failed',
        _error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      _error.value = 'Error: ${e.toString()}';
      print('❌ Registration error details: $e');
      Get.snackbar(
        'Registration Failed',
        _error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 5),
      );
      rethrow; // Re-throw to let AuthScreen catch it
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final signedInUser = cred.user;
      if (signedInUser != null) {
        print('🔥 Firebase Auth successful, now handling Firestore...');
        try {
          // Ensure Firestore user exists
          final existing = await _firestoreService.getUser(signedInUser.uid);
          if (existing == null) {
            print('📝 User not in Firestore, creating...');
            final displayName = (signedInUser.displayName != null && signedInUser.displayName!.isNotEmpty)
                ? signedInUser.displayName!
                : (email.contains('@') ? email.split('@').first : email);
            final created = UserModel(
              id: signedInUser.uid,
              email: signedInUser.email ?? email,
              displayName: displayName,
              photoURL: signedInUser.photoURL ?? '',
              isOnline: true,
              lastSeen: DateTime.now(),
              createdAt: DateTime.now(),
              showLastSeen: true,
              readReceipts: true,
              profilePhotoVisibility: 'everyone',
              bioVisibility: 'everyone',
            );
            await _firestoreService.createUser(created);
            _userModel.value = created;
            print('✅ Firestore user created');
          } else {
            print('✅ User found in Firestore, updating status...');
            await _firestoreService.updateUserOnlineStatus(signedInUser.uid, true);
            _userModel.value = existing;
            print('✅ User status updated');
          }
        } catch (e) {
          // Best-effort: do not block login on Firestore errors
          print('⚠️ Sign-in Firestore error (continuing anyway): $e');
          // Create a minimal user model so the app can proceed
          final displayName = (signedInUser.displayName != null && signedInUser.displayName!.isNotEmpty)
              ? signedInUser.displayName!
              : (email.contains('@') ? email.split('@').first : email);
          _userModel.value = UserModel(
            id: signedInUser.uid,
            email: signedInUser.email ?? email,
            displayName: displayName,
            photoURL: signedInUser.photoURL ?? '',
            isOnline: true,
            lastSeen: DateTime.now(),
            createdAt: DateTime.now(),
          );
        }
      }

      Get.snackbar(
        'Success',
        'Logged in successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      _error.value = _getErrorMessage(e.code);
      Get.snackbar(
        'Login Failed',
        _error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      _error.value = 'Error: ${e.toString()}';
      print('❌ Sign-in error details: $e');
      Get.snackbar(
        'Login Failed',
        _error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 5),
      );
      rethrow; // Re-throw to let AuthScreen catch it
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;

      // Update user status to offline before signing out
      if (user != null) {
        await _firestoreService.updateUserOnlineStatus(user!.uid, false);
      }

      await _auth.signOut();

      Get.snackbar(
        'Success',
        'Logged out successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 2),
      );

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      _error.value = 'Failed to sign out';
      Get.snackbar(
        'Error',
        _error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      await _auth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        'Success',
        'Password reset email sent! Check your inbox.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
        duration: const Duration(seconds: 3),
      );

      Get.back(); // Go back to login
    } on FirebaseAuthException catch (e) {
      _error.value = _getErrorMessage(e.code);
      Get.snackbar(
        'Error',
        _error.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      _isLoading.value = true;

      if (user != null && !user!.emailVerified) {
        await user!.sendEmailVerification();

        Get.snackbar(
          'Success',
          'Verification email sent!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification email',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Reload user to check email verification
  Future<void> reloadUser() async {
    try {
      await user?.reload();
      _firebaseUser.value = _auth.currentUser;
      _isEmailVerified.value = user?.emailVerified ?? false;
    } catch (e) {
      print('Error reloading user: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
    String? bio,
  }) async {
    try {
      _isLoading.value = true;

      if (user != null && _userModel.value != null) {
        // Update Firebase Auth profile
        if (displayName != null) {
          await user!.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await user!.updatePhotoURL(photoURL);
        }

        // Update Firestore user document
        final updatedUser = _userModel.value!.copyWith(
          displayName: displayName ?? _userModel.value!.displayName,
          photoURL: photoURL ?? _userModel.value!.photoURL,
          bio: bio ?? _userModel.value!.bio,
        );

        await _firestoreService.updateUser(updatedUser);
        _userModel.value = updatedUser;

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Get error message from Firebase error code
  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  void clearError() {
    _error.value = '';
  }
}
