# 🔥 FIX: Registration/Login Error

## The Problem
You're seeing "Registration Failed - An error occurred. Please try again."

This is **99% likely a Firestore Security Rules issue**. Firebase is blocking your app from writing user data to Firestore.

## ✅ SOLUTION: Deploy Firestore Rules

### Step 1: Go to Firebase Console
1. Open https://console.firebase.google.com
2. Select your project
3. Click **Firestore Database** in the left menu
4. Click the **Rules** tab at the top

### Step 2: Copy These Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection - CRITICAL FOR SIGN UP/LOGIN
    match /users/{userId} {
      allow read: if request.auth != null;
      allow create, update: if request.auth != null && request.auth.uid == userId;
      allow delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Friend requests
    match /friendRequests/{requestId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null;
    }
    
    // Friendships
    match /friendships/{friendshipId} {
      allow read, write: if request.auth != null;
    }
    
    // Chats
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
    
    // Messages
    match /messages/{messageId} {
      allow read, write: if request.auth != null;
    }
    
    // Notifications
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### Step 3: Publish the Rules
1. Paste the rules above into the Firebase Console
2. Click **Publish** button
3. Wait for "Rules published successfully" message

### Step 4: Test Again
1. **Restart your app** (hot reload won't work)
2. Try to sign up again with:
   - Email: `varun2003@gmail.com`
   - Password: (your password)
3. It should work now!

## 🔍 How to Verify It Worked

### Check Debug Console
After you try to sign up, look for these logs:

**If it works:**
```
🔐 Starting authentication: Sign Up
📧 Email: varun2003@gmail.com
🔥 Firestore: Attempting to create user document for <uid>
📝 User data: {id: ..., email: ..., displayName: ...}
✅ Firestore: User document created successfully
✅ Authentication successful
```

**If permission denied:**
```
❌ Firestore Error: [cloud_firestore/permission-denied] ...
❌ Error type: FirebaseException
PERMISSION DENIED: You need to set up Firestore security rules...
```

### Check Firestore Database
1. Go to Firebase Console → Firestore Database → Data tab
2. Look for `users` collection
3. You should see a document with your user ID
4. Click it to see all your user data

## 🚨 Still Not Working?

### Check These:

1. **Firebase Project Connected?**
   - Make sure `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) is in your project
   - Check `firebase_options.dart` exists

2. **Internet Connection?**
   - Make sure your device/emulator has internet access

3. **Email Already Exists?**
   - Try a different email address
   - Or try "Log In" instead of "Sign Up"

4. **Run These Commands:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

## 📱 Alternative: Test with Existing Account

If you already have an account in Firebase Auth:
1. Click "Log In" tab (not Sign Up)
2. Enter your existing credentials
3. The app will create the Firestore doc automatically on first login

## 🎯 What Happens After Fix

Once rules are deployed:
- ✅ Sign up creates user in Firebase Auth
- ✅ Sign up creates user document in Firestore
- ✅ Login updates user's online status
- ✅ You can see your user data in Firebase Console
- ✅ App navigates to Home screen

## Need More Help?

Run the app and send me the **full debug console output** after you try to sign up. Look for lines starting with:
- 🔐 (authentication)
- 🔥 (Firestore)
- ❌ (errors)
