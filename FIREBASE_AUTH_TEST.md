# Firebase Authentication & Firestore Integration Test Guide

## What Was Fixed

### 1. **AuthScreen Integration**
- ✅ Switched from Supabase to Firebase Auth for email/password
- ✅ Added input validation (email format, password length)
- ✅ Added detailed error messages and logging
- ✅ Handles AuthController registration properly

### 2. **AuthController Enhancements**
- ✅ Sign-in creates Firestore user doc if missing
- ✅ Sign-in updates `isOnline` and `lastSeen` if doc exists
- ✅ Registration creates complete user profile in Firestore
- ✅ Proper error handling with user-friendly messages

### 3. **AuthWrapper (main.dart)**
- ✅ Uses Firebase Auth state instead of Supabase
- ✅ Listens to `FirebaseAuth.authStateChanges()`
- ✅ Shows AuthScreen when logged out, HomeScreen when logged in

### 4. **FirestoreService**
- ✅ Has timeout protection (10 seconds)
- ✅ Detailed error logging with permission-denied detection
- ✅ Creates user documents with all required fields

## How to Test

### Test 1: Sign Up (New User)
1. Open the app
2. Click "Sign Up" tab
3. Enter:
   - Email: `test@example.com`
   - Password: `password123` (min 6 chars)
4. Click "Sign Up" button
5. **Expected Results:**
   - ✅ Loading indicator appears
   - ✅ Success snackbar: "Account created! Please verify your email."
   - ✅ Navigates to HomeScreen
   - ✅ Check Firebase Console → Firestore → `users` collection
   - ✅ Document with your UID should exist with fields:
     ```
     id: <uid>
     email: test@example.com
     displayName: test
     photoURL: ""
     bio: ""
     isOnline: true
     lastSeen: <timestamp>
     createdAt: <timestamp>
     showLastSeen: true
     readReceipts: true
     profilePhotoVisibility: "everyone"
     bioVisibility: "everyone"
     blockedUsers: []
     ```

### Test 2: Sign In (Existing User)
1. Sign out (if logged in)
2. Click "Log In" tab
3. Enter the same credentials from Test 1
4. Click "Log In" button
5. **Expected Results:**
   - ✅ Loading indicator appears
   - ✅ Success snackbar: "Logged in successfully!"
   - ✅ Navigates to HomeScreen
   - ✅ Check Firestore: `isOnline` = true, `lastSeen` updated

### Test 3: Sign In (User Without Firestore Doc)
1. Create a user in Firebase Auth Console manually
2. Do NOT create a Firestore doc for them
3. Try to sign in with that user
4. **Expected Results:**
   - ✅ Login succeeds
   - ✅ Firestore doc is auto-created with default values
   - ✅ User can access the app normally

### Test 4: Validation Errors
1. Try to sign up with:
   - Empty email → "Please enter email and password"
   - Invalid email (no @) → "Please enter a valid email"
   - Password < 6 chars → "Password must be at least 6 characters"
2. **Expected Results:**
   - ✅ Red snackbar with appropriate error message
   - ✅ No Firebase call made

### Test 5: Firebase Auth Errors
1. Try to sign up with existing email
   - **Expected:** "Email already in use"
2. Try to sign in with wrong password
   - **Expected:** "Wrong password"
3. Try to sign in with non-existent email
   - **Expected:** "User not found"

## Debug Console Output

When testing, watch the debug console for these logs:

### Successful Sign Up:
```
🔐 Starting authentication: Sign Up
📧 Email: test@example.com
🔥 Firestore: Attempting to create user document for <uid>
✅ Firestore: User document created successfully
✅ Authentication successful
```

### Successful Sign In:
```
🔐 Starting authentication: Sign In
📧 Email: test@example.com
🔐 User logged in: test@example.com
✅ User model loaded: test
✅ Authentication successful
```

### Firestore Permission Error:
```
❌ Firestore Error: [cloud_firestore/permission-denied] ...
Permission denied: Please deploy Firestore rules. Check FIX_FRIEND_REQUEST_ISSUE.md
```

## Firestore Security Rules

**CRITICAL:** Deploy these rules to Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      // Anyone authenticated can read user profiles
      allow read: if request.auth != null;
      
      // Users can create/update their own profile
      allow create, update: if request.auth != null && request.auth.uid == userId;
      
      // Only the user can delete their own profile
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Friend requests
    match /friendRequests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.senderId == request.auth.uid || 
         resource.data.receiverId == request.auth.uid);
    }
    
    // Friendships
    match /friendships/{friendshipId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        (resource.data.user1Id == request.auth.uid || 
         resource.data.user2Id == request.auth.uid);
    }
    
    // Chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.participants;
    }
    
    // Messages
    match /messages/{messageId} {
      allow read, create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        resource.data.senderId == request.auth.uid;
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read, update, delete: if request.auth != null && 
        resource.data.userId == request.auth.uid;
      allow create: if request.auth != null;
    }
  }
}
```

## Common Issues & Solutions

### Issue 1: "Get.find<AuthController>() not found"
**Solution:** Already fixed - AuthScreen now tries `Get.find()` first, falls back to `Get.put()`

### Issue 2: "Permission denied" when creating user
**Solution:** Deploy the Firestore rules above in Firebase Console

### Issue 3: User created in Auth but not in Firestore
**Solution:** Check the debug console for Firestore errors. Likely a rules issue.

### Issue 4: App shows AuthScreen even after successful login
**Solution:** Check that `AuthWrapper` in `main.dart` is using Firebase Auth (not Supabase)

### Issue 5: Navigation doesn't work after login
**Solution:** Verify `AppRoutes.home` is defined and `HomeScreen` exists

## Files Modified

1. ✅ `lib/screens/auth_screen.dart` - Uses Firebase Auth + validation
2. ✅ `lib/controllers/auth_controller.dart` - Creates/updates Firestore docs
3. ✅ `lib/main.dart` - AuthWrapper uses Firebase Auth state
4. ✅ `lib/services/firestore_service.dart` - Already has proper error handling

## Next Steps

After successful testing:
1. ✅ Remove Supabase dependency if not needed for other features
2. ✅ Add password reset functionality
3. ✅ Add email verification check before allowing app access
4. ✅ Implement Google/Apple sign-in with Firebase Auth (not Supabase)
5. ✅ Add profile photo upload to Firebase Storage
