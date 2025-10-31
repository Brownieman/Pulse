# Firebase Setup Guide for Pulse Messaging App

## Overview
This guide will help you set up Firebase for your Pulse messaging application with friend requests and real-time messaging features.

## Firebase Collections Structure

### 1. **users** Collection
Stores user profile information.

```
users/{userId}
  - id: string
  - email: string
  - displayName: string
  - photoURL: string
  - bio: string
  - isOnline: boolean
  - lastSeen: timestamp
  - createdAt: timestamp
  - showLastSeen: boolean
  - readReceipts: boolean
  - profilePhotoVisibility: string ('everyone', 'friends', 'nobody')
  - bioVisibility: string ('everyone', 'friends', 'nobody')
  - blockedUsers: array of userIds
```

### 2. **friendRequests** Collection
Manages friend request lifecycle.

```
friendRequests/{requestId}
  - id: string
  - senderId: string
  - receiverId: string
  - status: string ('pending', 'accepted', 'declined')
  - createdAt: timestamp
  - respondedAt: timestamp (nullable)
  - message: string (nullable)
```

### 3. **friendships** Collection
Stores accepted friendships.

```
friendships/{friendshipId}  // Format: {smallerUserId}_{largerUserId}
  - id: string
  - user1Id: string
  - user2Id: string
  - createdAt: timestamp
  - isBlocked: boolean
  - blockedBy: string (nullable)
```

### 4. **chats** Collection
Manages chat metadata.

```
chats/{chatId}  // Format: {smallerUserId}_{largerUserId}
  - id: string
  - participants: array [userId1, userId2]
  - lastMessage: string
  - lastMessageTime: timestamp
  - lastMessageSenderId: string
  - unreadCount: map {userId1: number, userId2: number}
  - deletedBy: map {userId1: boolean, userId2: boolean}
  - deletedAt: map {userId1: timestamp, userId2: timestamp}
  - lastSeenBy: map {userId1: timestamp, userId2: timestamp}
  - createdAt: timestamp
  - updatedAt: timestamp
```

### 5. **messages** Collection
Stores individual messages.

```
messages/{messageId}
  - id: string
  - chatId: string
  - senderId: string
  - receiverId: string
  - content: string
  - type: string ('text')
  - timestamp: timestamp
  - clientTimestamp: timestamp
  - isRead: boolean
  - isEdited: boolean
  - editedAt: timestamp (nullable)
  - readAt: timestamp (nullable)
```

### 6. **notifications** Collection
Stores user notifications.

```
notifications/{notificationId}
  - id: string
  - userId: string
  - title: string
  - body: string
  - type: string ('friendRequest', 'friendRequestAccepted', 'friendRequestDeclined', 'friendRemoved', 'message')
  - data: map (additional data)
  - createdAt: timestamp
  - isRead: boolean
```

## Firebase Security Rules

Copy and paste these rules into your Firebase Console (Firestore Database > Rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isSignedIn() && request.auth.uid == userId;
    }
    
    function isParticipant(participants) {
      return isSignedIn() && request.auth.uid in participants;
    }
    
    // Users collection
    match /users/{userId} {
      // Anyone can read user profiles (for friend search)
      allow read: if isSignedIn();
      
      // Only the user can create/update their own profile
      allow create: if isOwner(userId);
      allow update: if isOwner(userId);
      
      // Only the user can delete their own profile
      allow delete: if isOwner(userId);
    }
    
    // Friend Requests collection
    match /friendRequests/{requestId} {
      // Users can read requests they sent or received
      allow read: if isSignedIn() && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.receiverId);
      
      // Users can create friend requests
      allow create: if isSignedIn() && 
        request.auth.uid == request.resource.data.senderId;
      
      // Sender can delete (cancel) their own requests
      // Receiver can update (accept/decline) requests sent to them
      allow update: if isSignedIn() && 
        (request.auth.uid == resource.data.receiverId ||
         request.auth.uid == resource.data.senderId);
      
      allow delete: if isSignedIn() && 
        request.auth.uid == resource.data.senderId;
    }
    
    // Friendships collection
    match /friendships/{friendshipId} {
      // Users can read friendships they're part of
      allow read: if isSignedIn() && 
        (request.auth.uid == resource.data.user1Id || 
         request.auth.uid == resource.data.user2Id);
      
      // System creates friendships (via Cloud Functions or app logic)
      allow create: if isSignedIn();
      
      // Users can update friendships they're part of (for blocking)
      allow update: if isSignedIn() && 
        (request.auth.uid == resource.data.user1Id || 
         request.auth.uid == resource.data.user2Id);
      
      // Users can delete friendships they're part of
      allow delete: if isSignedIn() && 
        (request.auth.uid == resource.data.user1Id || 
         request.auth.uid == resource.data.user2Id);
    }
    
    // Chats collection
    match /chats/{chatId} {
      // Users can read chats they're participants of
      allow read: if isSignedIn() && 
        isParticipant(resource.data.participants);
      
      // Users can create chats
      allow create: if isSignedIn() && 
        isParticipant(request.resource.data.participants);
      
      // Participants can update chat metadata
      allow update: if isSignedIn() && 
        isParticipant(resource.data.participants);
      
      // Participants can delete chats (soft delete)
      allow delete: if isSignedIn() && 
        isParticipant(resource.data.participants);
    }
    
    // Messages collection
    match /messages/{messageId} {
      // Users can read messages from chats they're in
      allow read: if isSignedIn() && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.receiverId);
      
      // Users can create messages they're sending
      allow create: if isSignedIn() && 
        request.auth.uid == request.resource.data.senderId;
      
      // Senders can update/delete their own messages
      allow update, delete: if isSignedIn() && 
        request.auth.uid == resource.data.senderId;
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      // Users can only read their own notifications
      allow read: if isSignedIn() && 
        request.auth.uid == resource.data.userId;
      
      // System creates notifications
      allow create: if isSignedIn();
      
      // Users can update their own notifications (mark as read)
      allow update: if isSignedIn() && 
        request.auth.uid == resource.data.userId;
      
      // Users can delete their own notifications
      allow delete: if isSignedIn() && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## Firestore Indexes

Create these composite indexes in Firebase Console (Firestore Database > Indexes):

### 1. Friend Requests Index
- Collection: `friendRequests`
- Fields:
  - `receiverId` (Ascending)
  - `status` (Ascending)
  - `createdAt` (Descending)

### 2. Sent Friend Requests Index
- Collection: `friendRequests`
- Fields:
  - `senderId` (Ascending)
  - `status` (Ascending)
  - `createdAt` (Descending)

### 3. Messages Index
- Collection: `messages`
- Fields:
  - `chatId` (Ascending)
  - `timestamp` (Ascending)

### 4. Notifications Index
- Collection: `notifications`
- Fields:
  - `userId` (Ascending)
  - `createdAt` (Descending)

### 5. Unread Notifications Index
- Collection: `notifications`
- Fields:
  - `userId` (Ascending)
  - `isRead` (Ascending)

## Setup Steps

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Pulse Messaging"
4. Follow the setup wizard

### 2. Enable Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password" sign-in method

### 3. Create Firestore Database
1. Go to "Firestore Database"
2. Click "Create database"
3. Start in "Test mode" (we'll add rules later)
4. Choose your region

### 4. Add Firebase to Your Flutter App
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. In your project directory, run: `flutterfire configure`
4. Select your Firebase project
5. Select platforms (Android, iOS, Web, etc.)

### 5. Deploy Security Rules
1. Copy the security rules above
2. Go to Firebase Console > Firestore Database > Rules
3. Paste the rules
4. Click "Publish"

### 6. Create Indexes
1. Go to Firestore Database > Indexes
2. Click "Add Index"
3. Create each index listed above
4. Wait for indexes to build (may take a few minutes)

### 7. Enable Firebase Cloud Messaging (Optional)
1. Go to "Cloud Messaging"
2. Add your app's configuration
3. Download `google-services.json` (Android) or `GoogleService-Info.plist` (iOS)
4. Place files in appropriate directories

## Testing

### Test User Creation
```dart
// Register a new user
await authController.registerWithEmailAndPassword(
  email: 'test@example.com',
  password: 'password123',
  displayName: 'Test User',
);
```

### Test Friend Request
```dart
// Send friend request
await firestoreService.sendFriendRequest(
  FriendRequestModel(
    id: uuid.v4(),
    senderId: currentUserId,
    receiverId: friendUserId,
    createdAt: DateTime.now(),
  ),
);
```

### Test Messaging
```dart
// Send message
await firestoreService.sendMessage(
  MessageModel(
    id: uuid.v4(),
    senderId: currentUserId,
    receiverId: friendUserId,
    content: 'Hello!',
    timestamp: DateTime.now(),
    chatId: chatId,
  ),
);
```

## Troubleshooting

### Permission Denied Errors
- Check that security rules are deployed
- Verify user is authenticated
- Ensure user has proper permissions

### Index Required Errors
- Create the required composite index
- Wait for index to build
- Retry the operation

### Messages Not Appearing
- Check that chat exists
- Verify friendship exists
- Check that users aren't blocked

## Best Practices

1. **Always authenticate users** before allowing any operations
2. **Validate data** on both client and server side
3. **Use transactions** for operations that modify multiple documents
4. **Implement proper error handling** for all Firebase operations
5. **Monitor Firebase usage** to stay within free tier limits
6. **Enable offline persistence** for better user experience
7. **Implement proper cleanup** when users delete accounts

## Support

For issues or questions:
- Check Firebase documentation: https://firebase.google.com/docs
- Review Firestore security rules: https://firebase.google.com/docs/firestore/security/get-started
- Check Flutter Fire documentation: https://firebase.flutter.dev/

## Next Steps

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to test the app
3. Register test users and test features
4. Monitor Firebase Console for any errors
5. Adjust security rules as needed for your use case
