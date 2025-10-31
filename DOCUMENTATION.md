# Pulse - Complete Application Documentation

**Version:** 1.0.0  
**App Name:** Pulse (talkzy_beta1)  
**Description:** A modern real-time messaging application with friend requests, chat functionality, task management, and social features  
**Platform:** Flutter (Cross-platform: iOS & Android)  
**Last Updated:** October 31, 2025

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture & Design Patterns](#architecture--design-patterns)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Core Features](#core-features)
6. [Data Models](#data-models)
7. [Application Flow](#application-flow)
8. [Controllers & State Management](#controllers--state-management)
9. [Services & Backend Integration](#services--backend-integration)
10. [UI/UX & Screens](#uiux--screens)
11. [Theme System](#theme-system)
12. [Authentication Flow](#authentication-flow)
13. [Real-Time Communication](#real-time-communication)
14. [Notifications System](#notifications-system)
15. [Setup & Configuration](#setup--configuration)
16. [Build & Deployment](#build--deployment)

---

## Project Overview

**Pulse** is a comprehensive messaging and social application built with Flutter that provides:

- **Real-time Messaging**: Instant chat with friends using Supabase Realtime
- **Friend System**: Send and manage friend requests
- **User Discovery**: Find and connect with other users
- **Task Management**: Create and manage personal tasks
- **Analytics Dashboard**: View engagement statistics
- **Server/Channel System**: Create and join community servers
- **Theme Customization**: Dark/Light theme support
- **Notifications**: Push notifications via Firebase Cloud Messaging
- **Privacy Controls**: User privacy and security settings
- **Authentication**: Firebase Auth & Supabase integration

---

## Architecture & Design Patterns

### Design Pattern: MVC + GetX State Management

The application follows a hybrid architecture combining:

1. **Model-View-Controller (MVC)** - Separation of concerns
2. **GetX State Management** - Reactive state management library
3. **Service Layer** - Encapsulates backend communication

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Screens (UI) → Views & Widgets                  │   │
│  │  - AuthScreen, HomeScreen, ChatScreen, etc.     │   │
│  └──────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────┐
│               BUSINESS LOGIC LAYER                      │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Controllers (GetX) - State Management           │   │
│  │  - AuthController, ChatController, etc.        │   │
│  │  - Handles business logic & state transitions   │   │
│  └──────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────┐
│                SERVICE LAYER                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Services - Backend Communication & Data Ops    │   │
│  │  - AuthService, FirestoreService, etc.        │   │
│  │  - Handle API calls & database operations      │   │
│  └──────────────────────────────────────────────────┘   │
└──────────────────┬──────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────┐
│               DATA & BACKEND LAYER                     │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Firebase Auth - Authentication                 │   │
│  │  Firestore - User profiles, metadata           │   │
│  │  Supabase - Real-time messaging & data         │   │
│  │  Firebase Messaging - Push notifications        │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Technology Stack

### Frontend Framework
- **Flutter** 2.17.0+ - Cross-platform mobile development
- **Dart** - Programming language

### State Management
- **GetX** 4.7.2 - Reactive state management & routing
- **Flutter Bloc** 9.1.1 - Business Logic Component pattern

### Backend & Cloud Services
- **Firebase**
  - Firebase Auth 5.3.1 - User authentication
  - Cloud Firestore 5.4.4 - NoSQL database
  - Firebase Cloud Messaging 15.0.2 - Push notifications
  - Firebase Core 3.6.0 - Core Firebase services
  
- **Supabase**
  - supabase_flutter 2.3.3 - Real-time database & auth
  - PostgreSQL backend - Database

### Storage & Local Data
- **Flutter Secure Storage** 9.2.4 - Encrypted local storage
- **Shared Preferences** 2.2.3 - Key-value storage
- **Path Provider** 2.1.3 - File system access

### UI & UX Libraries
- **Google Fonts** 6.3.0 - Typography
- **Emoji Picker** 2.1.1 - Emoji selection widget
- **Cached Network Image** 3.3.1 - Image caching
- **Loading Animation Widget** 1.3.0 - Loading indicators
- **Animated Splash Screen** 1.3.0 - Splash animations

### Utilities & Tools
- **Permission Handler** 11.3.0 - Device permission management
- **Flutter Contacts** 1.1.7 - Contact synchronization
- **Local Notifications** 19.5.0 - Local notifications
- **URL Launcher** 6.2.5 - Open URLs & external apps
- **HTTP** 1.5.0 - HTTP requests
- **UUID** 4.5.1 - Unique ID generation
- **RxDart** 0.28.0 - Reactive programming
- **Intl** 0.19.0 - Internationalization

---

## Project Structure

```
Pulse/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── home_screen.dart                    # Main home screen
│   ├── firebase_options.dart               # Firebase configuration
│   │
│   ├── config/                             # Configuration files
│   │   └── [Config constants & settings]
│   │
│   ├── controllers/                        # GetX Controllers (State Management)
│   │   ├── auth_controller.dart            # Authentication logic
│   │   ├── chat_controller.dart            # Chat messaging logic
│   │   ├── chat_theme_controller.dart      # Chat UI theme
│   │   ├── friend_requests_controller.dart # Friend request handling
│   │   ├── friends_controller.dart         # Friends list management
│   │   ├── home_controller.dart            # Home screen logic
│   │   ├── main_controller.dart            # App-wide state
│   │   ├── notification_controller.dart    # Notification handling
│   │   ├── privacy_controller.dart         # Privacy settings
│   │   ├── profile_controller.dart         # User profile management
│   │   ├── settings_controller.dart        # App settings
│   │   ├── theme_controller.dart           # Theme management
│   │   └── user_list_controller.dart       # User discovery
│   │
│   ├── models/                             # Data Models
│   │   ├── contact.dart                    # Contact model
│   │   ├── [Other domain models]
│   │
│   ├── routes/                             # Navigation & Routing
│   │   ├── app_pages.dart                  # Route definitions
│   │   └── [Route handlers]
│   │
│   ├── screens/                            # UI Screens (Pages)
│   │   ├── auth_screen.dart                # Authentication UI
│   │   ├── chat_screen.dart                # One-on-one chat
│   │   ├── dashboard_screen.dart           # Analytics dashboard
│   │   ├── messages_screen.dart            # Messages list
│   │   ├── server_chat_screen.dart         # Server chat
│   │   ├── servers_screen.dart             # Servers list
│   │   ├── task_list_screen.dart           # Task management
│   │   ├── analytics_screen.dart           # Analytics view
│   │   ├── settings_screen.dart            # Settings page
│   │   └── settings/                       # Settings sub-screens
│   │       └── [Privacy, profile, etc.]
│   │
│   ├── services/                           # Backend Services
│   │   ├── auth_service.dart               # Auth operations
│   │   ├── firebase_setup_service.dart     # Firebase initialization
│   │   ├── firebase_messaging_service.dart # Push notification setup
│   │   ├── firestore_service.dart          # Firestore operations
│   │   ├── firestore_service_complete.dart # Advanced Firestore ops
│   │   ├── local_storage.dart              # Local storage wrapper
│   │   └── notification_service.dart       # Notification handling
│   │
│   ├── theme/                              # Theme & Styling
│   │   ├── [Theme constants]
│   │   ├── [Color schemes]
│   │   └── [Text styles]
│   │
│   ├── utils/                              # Utility Functions
│   │   ├── app_theme.dart                  # Theme utilities
│   │   ├── [Helper functions]
│   │   └── [Constants]
│   │
│   └── views/                              # Reusable Widgets/Components
│       ├── [Custom UI components]
│       └── [Shared widgets]
│
├── android/                                # Android Native Code
│   ├── app/
│   │   ├── src/
│   │   ├── build.gradle.kts
│   │   └── google-services.json
│   ├── build.gradle.kts
│   └── gradle.properties
│
├── ios/                                    # iOS Native Code
│   ├── Runner/
│   ├── Pods/
│   └── Podfile
│
├── assets/                                 # Static Assets
│   ├── images/                             # App images
│   └── data/
│       └── contacts.json
│
├── test/                                   # Unit & Widget Tests
│   └── widget_test.dart
│
├── pubspec.yaml                            # Flutter dependencies
├── pubspec.lock                            # Locked dependencies
├── firebase.json                           # Firebase configuration
├── firestore.rules                         # Firestore security rules
└── analysis_options.yaml                   # Dart analysis config
```

---

## Core Features

### 1. **Authentication System**
- Firebase Email/Password authentication
- Google Sign-in
- Apple Sign-in
- Token-based session management
- Secure credential storage

### 2. **Messaging & Chat**
- One-on-one real-time messaging
- Message history
- Typing indicators
- Read receipts
- Emoji support
- File/media sharing capability

### 3. **Friend System**
- Send friend requests
- Accept/reject friend requests
- Friends list
- Unfriend functionality
- Friend status tracking

### 4. **User Discovery**
- Search users by username/email
- User profiles
- Public user profiles
- Block/report functionality

### 5. **Servers/Channels**
- Create public/private servers
- Channel-based messaging
- Server members management
- Role-based permissions

### 6. **Task Management**
- Create tasks
- Task status tracking (open, done, missed)
- Task deadlines
- Task filtering

### 7. **Analytics Dashboard**
- User engagement metrics
- Trust score system
- Statistics visualization
- User activity tracking

### 8. **Notifications**
- Firebase Cloud Messaging integration
- Push notifications
- Local notifications
- Notification preferences

### 9. **Privacy & Security**
- Privacy settings
- Block users
- Data encryption
- Secure authentication

### 10. **Theme Customization**
- Dark/Light themes
- Custom color schemes
- Chat-specific themes
- Persistent theme storage

---

## Data Models

### Core Data Models

```dart
// User Model
User {
  String uid
  String email
  String username
  String? displayName
  String? photoUrl
  String? bio
  bool isOnline
  DateTime lastSeen
  List<String> friends
  List<String> blockedUsers
  DateTime createdAt
  Map<String, dynamic> privacySettings
}

// Message Model
Message {
  String id
  String senderId
  String receiverId
  String content
  DateTime timestamp
  bool isRead
  String? mediaUrl
  MessageType type  // text, image, audio, video
}

// Chat Room Model
ChatRoom {
  String id
  String user1Id
  String user2Id
  DateTime createdAt
  DateTime lastMessageTime
  String lastMessage
  int unreadCount
}

// Friend Request Model
FriendRequest {
  String id
  String fromUserId
  String toUserId
  DateTime requestDate
  FriendRequestStatus status  // pending, accepted, rejected
}

// Task Model
Task {
  String id
  String title
  String? description
  DateTime? deadline
  TaskStatus status  // open, done, missed
  DateTime createdAt
  String userId
}

// Server Model
Server {
  String id
  String name
  String? description
  String? imageUrl
  String creatorId
  List<String> members
  DateTime createdAt
  bool isPublic
}

// Notification Model
Notification {
  String id
  String userId
  String type  // message, friend_request, etc
  String title
  String? message
  DateTime timestamp
  bool isRead
  Map<String, dynamic> data
}
```

---

## Application Flow

### Complete User Journey Flowchart

```
START
   │
   ▼
┌─────────────────────────┐
│   Splash Screen         │
│   - Load Config         │
│   - Initialize Services │
└────────┬────────────────┘
         │
         ▼
    ┌────────────────┐
    │ User Logged In?│
    └───┬────────┬───┘
        │        │
       YES      NO
        │        │
        │        ▼
        │    ┌──────────────────┐
        │    │ Authentication   │
        │    │ - Login          │
        │    │ - Sign Up        │
        │    │ - Social Auth    │
        │    └────────┬─────────┘
        │             │
        │    ┌────────▼──────────┐
        │    │ Create User Profile│
        │    │ - Set Display Name │
        │    │ - Set Bio          │
        │    └────────┬───────────┘
        │             │
        └──────┬──────┘
               │
               ▼
    ┌──────────────────────┐
    │ Home Screen (Main)   │
    │ - Dashboard          │
    │ - Navigation Tabs    │
    └─┬────────────────────┘
      │
      ├─────────────────┬────────────────┬────────────────┬─────────────┐
      │                 │                │                │             │
      ▼                 ▼                ▼                ▼             ▼
  ┌────────┐    ┌─────────────┐   ┌──────────┐   ┌──────────┐   ┌─────────────┐
  │ Messages│   │   Friends   │   │  Discover│   │  Servers │   │  Settings   │
  │ - View │   │ - List      │   │ - Browse │   │ - Browse │   │ - Profile   │
  │ Chats  │   │ - Requests  │   │ - Search │   │ - Join   │   │ - Privacy   │
  │ - Start│   │ - Add       │   │ - Add    │   │ - Create │   │ - Theme     │
  │ Chat   │   │   Friend    │   │ Friend   │   │ - Manage │   │ - Logout    │
  └───┬────┘   └─────────────┘   └──────────┘   └──────────┘   └─────────────┘
      │
      ▼
  ┌─────────────────────┐
  │ Chat Screen         │
  │ - Real-time Msgs    │
  │ - Type Indicators   │
  │ - Emoji Support     │
  │ - Message History   │
  └──────────┬──────────┘
             │
             ▼
    ┌────────────────────┐
    │ Send/Receive Msg   │
    │ - Update UI        │
    │ - Store in DB      │
    │ - Send Notification│
    └────────┬───────────┘
             │
             └─────┐
                   │
        ┌──────────▼───────────┐
        │ Log Out / Sign Out   │
        │ - Clear Local Data   │
        │ - End Session        │
        └──────────┬───────────┘
                   │
                   ▼
               [RESET TO AUTH]
```

---

## Controllers & State Management

### GetX Controllers Hierarchy

```
┌─────────────────────────────────────────────────────────┐
│                 MainController                          │
│  - App-wide state management                           │
│  - Global navigation                                    │
│  - Initialization logic                                │
└────────────────┬────────────────────────────────────────┘
                 │
    ┌────────────┼────────────┬──────────────┬────────────┐
    │            │            │              │            │
    ▼            ▼            ▼              ▼            ▼
┌─────────┐ ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│  Auth   │ │  Home   │ │  Chat    │ │ Friends  │ │ Friends  │
│Contrlr  │ │Contrlr  │ │Contrlr   │ │Contrlr   │ │ Requests │
└─────────┘ └─────────┘ └──────────┘ └──────────┘ │Contrlr   │
                                                  └──────────┘
    │            │            │              │            │
    └────────────┼────────────┼──────────────┼────────────┘
                 │
       ┌─────────▼─────────┐
       │  Supporting       │
       │  Controllers      │
       ├─────────────────┤
       │ - Theme Contrlr │
       │ - Profile Ctrl  │
       │ - Settings Ctrl │
       │ - Privacy Ctrl  │
       │ - Notif Ctrl    │
       │ - Theme Chat    │
       │ - User List     │
       └─────────────────┘
```

### Key Controllers Explanation

#### **AuthController**
- Manages user authentication state
- Handles login/signup/logout
- Stores user session info
- Manages authentication errors

#### **ChatController**
- Manages active chat sessions
- Real-time message handling
- Message history retrieval
- Typing indicators

#### **HomeController**
- Main dashboard state
- Navigation coordination
- Feature availability

#### **FriendsController & FriendRequestsController**
- Friends list management
- Friend request handling
- Status updates

#### **ThemeController**
- Global app theme state
- Dark/Light mode toggle
- Theme persistence

#### **NotificationController**
- Notification handling
- Notification preferences
- FCM token management

---

## Services & Backend Integration

### Service Architecture

```
┌────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                      │
│           (Controllers & UI Components)                    │
└──────────────────────┬─────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────┐
│                   SERVICE LAYER                            │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ AuthService                                         │   │
│  │ - User registration                                │   │
│  │ - Email/Password auth                              │   │
│  │ - Social login (Google, Apple)                      │   │
│  │ - Session management                               │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ FirestoreService                                    │   │
│  │ - User profiles CRUD                               │   │
│  │ - User metadata storage                            │   │
│  │ - Friend lists management                          │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ SupabaseService                                     │   │
│  │ - Real-time messaging                              │   │
│  │ - Message history queries                          │   │
│  │ - Chat room management                             │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ NotificationService                                │   │
│  │ - Push notification setup                          │   │
│  │ - Local notifications                              │   │
│  │ - Notification routing                             │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ LocalStorageService                                │   │
│  │ - Secure credential storage                        │   │
│  │ - App preferences                                  │   │
│  │ - Cached data                                      │   │
│  └─────────────────────────────────────────────────────┘   │
└──────────────────────┬─────────────────────────────────────┘
                       │
┌──────────────────────▼─────────────────────────────────────┐
│                  BACKEND LAYER                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              FIREBASE                               │  │
│  │ ┌─────────────┬──────────────┬──────────────────┐   │  │
│  │ │Firebase Auth│  Firestore   │Cloud Messaging  │   │  │
│  │ │             │              │                 │   │  │
│  │ │- Register   │- User Data   │- Push Notif     │   │  │
│  │ │- Login      │- Metadata    │- Subscriptions  │   │  │
│  │ │- Logout     │- Analytics   │                 │   │  │
│  │ └─────────────┴──────────────┴──────────────────┘   │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              SUPABASE                               │  │
│  │ ┌─────────────┬──────────────────────────────────┐  │  │
│  │ │PostgreSQL   │      Supabase Realtime           │  │  │
│  │ │             │                                  │  │  │
│  │ │- Messages   │- Real-time message streaming    │  │  │
│  │ │- Chat Rooms │- Presence tracking              │  │  │
│  │ │- User Data  │- Subscriptions                  │  │  │
│  │ └─────────────┴──────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Service Details

#### **AuthService**
```dart
// Key Methods:
- registerWithEmail(email, password)
- loginWithEmail(email, password)
- signInWithGoogle()
- signInWithApple()
- logout()
- getCurrentUser()
- resetPassword(email)
```

#### **FirestoreService**
```dart
// Key Methods:
- createUserProfile(uid, userData)
- updateUserProfile(uid, data)
- getUserProfile(uid)
- addFriend(userId, friendId)
- removeFriend(userId, friendId)
- getFriendsList(userId)
```

#### **SupabaseService**
```dart
// Key Methods:
- sendMessage(chatRoomId, message)
- getMessageHistory(chatRoomId)
- subscribeToMessages(chatRoomId)
- createChatRoom(user1Id, user2Id)
- updateMessageStatus(messageId)
```

#### **NotificationService**
```dart
// Key Methods:
- initializeFCM()
- requestNotificationPermission()
- handleNotificationTap(message)
- sendLocalNotification(title, body)
- subscribeToTopic(topic)
```

---

## UI/UX & Screens

### Screen Overview & Hierarchy

```
AUTHENTICATION FLOW
  │
  ├─ Auth Screen
  │  ├─ Login Mode
  │  ├─ Sign Up Mode
  │  └─ Social Login Options
  │
  └─ Profile Setup Screen

MAIN APP FLOW
  │
  ├─ Home Screen (Tabbed Navigation)
  │  ├─ Messages Tab
  │  ├─ Friends Tab
  │  ├─ Discovery Tab
  │  ├─ Servers Tab
  │  └─ Settings Tab
  │
  ├─ Messages Screen
  │  ├─ Chat List
  │  ├─ Search Chats
  │  └─ New Chat Option
  │
  ├─ Chat Screen
  │  ├─ Message Bubble Display
  │  ├─ Input Field
  │  ├─ Emoji Picker
  │  ├─ Media Sharing
  │  └─ Message Options
  │
  ├─ Friends Screen
  │  ├─ Friends List
  │  ├─ Friend Requests
  │  ├─ Search Friends
  │  └─ Add Friend Option
  │
  ├─ Discovery Screen
  │  ├─ User Search
  │  ├─ User Cards
  │  ├─ User Profile Preview
  │  └─ Add Friend Action
  │
  ├─ Servers Screen
  │  ├─ Servers List
  │  ├─ Browse Servers
  │  ├─ Create Server
  │  └─ Server Details
  │
  ├─ Server Chat Screen
  │  ├─ Channel List (Left Sidebar)
  │  ├─ Messages
  │  ├─ Members List (Right Sidebar)
  │  └─ Message Input
  │
  ├─ Tasks Screen
  │  ├─ Task List
  │  ├─ Task Status Filter
  │  ├─ Create Task
  │  └─ Task Details
  │
  ├─ Analytics Dashboard
  │  ├─ Trust Score Widget
  │  ├─ Stats Cards
  │  ├─ Charts & Graphs
  │  └─ Activity Timeline
  │
  └─ Settings Screen
     ├─ Profile Settings
     ├─ Privacy Settings
     ├─ Theme Settings
     ├─ Notification Settings
     └─ Logout Option
```

### Key Screen Details

#### **Authentication Screen (AuthScreen)**
- Email/Password input fields
- Social login buttons (Google, Apple)
- Toggle between Login/Sign Up modes
- Password visibility toggle
- Form validation

#### **Home Screen**
- Bottom navigation with 5 tabs
- Dashboard with Trust Score
- Quick action buttons
- Navigation to main features

#### **Messages Screen**
- List of active chats
- Search functionality
- Last message preview
- Unread message count
- Online status indicators

#### **Chat Screen**
- Message history in bubbles
- Real-time message updates
- Typing indicators
- Emoji picker widget
- Message input field
- Send button

#### **Friends Screen**
- List of friends
- Friend requests section
- Add friend button
- Search functionality
- Friend profile quick view

#### **Discovery Screen**
- User search bar
- User cards with profile info
- Follow/Add friend button
- Filter options

#### **Servers Screen**
- List of joined servers
- Browse public servers
- Create new server button
- Server settings

#### **Settings Screen**
- Profile information
- Privacy & security settings
- Theme selection
- Notification preferences
- Logout button

---

## Theme System

### Theme Architecture

```
┌─────────────────────────────────┐
│     Theme Configuration         │
└──────────────┬──────────────────┘
               │
       ┌───────▼────────┐
       │ ThemeController│
       │ (GetX State)   │
       └───────┬────────┘
               │
       ┌───────▼──────────────┐
       │ AppTheme Utility     │
       │ - Dark Theme         │
       │ - Light Theme        │
       │ - Chat Themes        │
       └───────┬──────────────┘
               │
       ┌───────▼──────────────┐
       │ Flutter ThemeData    │
       │ - Colors             │
       │ - Typography         │
       │ - Components Style   │
       └───────┬──────────────┘
               │
               ▼
        [Applied to Material]
```

### Available Themes

1. **Dark Theme**
   - Primary Color: Dynamic (usually blue/purple)
   - Background: Dark gray/black
   - Surface: Slightly lighter dark
   - Text: White/Light gray

2. **Light Theme**
   - Primary Color: Vibrant blue
   - Background: White/Light gray
   - Surface: White
   - Text: Dark gray/black

3. **Chat Theme Variants**
   - Message bubbles styling
   - Input field theming
   - Emoji picker theming

---

## Authentication Flow

### Detailed Authentication Sequence

```
┌─────────────────────────────────────────────────────────┐
│              AUTHENTICATION FLOW DIAGRAM                │
└─────────────────────────────────────────────────────────┘

1. APP LAUNCH
   │
   ▼
┌──────────────────────────────────┐
│ Check Local Authentication Token │
└──────────────┬───────────────────┘
               │
        ┌──────┴──────┐
        │             │
       YES            NO
        │             │
        │             ▼
        │         ┌─────────────────────┐
        │         │ Navigate to Auth    │
        │         │ Screen              │
        │         └────┬────────────────┘
        │              │
        │              ├─────────────────────────┐
        │              │                         │
        │              ▼                         ▼
        │         ┌──────────────┐         ┌──────────────┐
        │         │ Login Flow   │         │ Sign Up Flow │
        │         └──────┬───────┘         └──────┬───────┘
        │                │                        │
        │                ├─────────────────────────┤
        │                │                         │
        │         [Email/Pass]            [Email/Pass]
        │         [Google Auth]           [Google Auth]
        │         [Apple Auth]            [Apple Auth]
        │                │                         │
        │        ┌────────▼────────┐      ┌────────▼──────────┐
        │        │ Firebase Auth   │      │ Create User in    │
        │        │ Authentication  │      │ Firestore         │
        │        └────────┬────────┘      └────────┬──────────┘
        │                 │                        │
        │        ┌────────▼────────┐      ┌────────▼──────────┐
        │        │ Get Auth Token  │      │ Get Auth Token    │
        │        └────────┬────────┘      └────────┬──────────┘
        │                 │                        │
        │        ┌────────▼────────┐      ┌────────▼──────────┐
        │        │ Save Token      │      │ Save Token        │
        │        │ Locally         │      │ Locally           │
        │        └────────┬────────┘      └────────┬──────────┘
        │                 │                        │
        └─────────┬───────┴────────────────────────┘
                  │
                  ▼
        ┌──────────────────────────┐
        │ Navigate to Home Screen  │
        │ Initialize Main App      │
        └──────────────────────────┘
```

### Authentication Methods

1. **Email/Password**
   - User enters email and password
   - Firebase validates credentials
   - Returns auth token

2. **Google Sign-In**
   - Opens Google login dialog
   - User authenticates with Google account
   - Firebase creates account if new user

3. **Apple Sign-In**
   - Opens Apple login dialog
   - User authenticates with Apple ID
   - Firebase creates account if new user

---

## Real-Time Communication

### Message Flow Diagram

```
┌─────────────────────────────────────────────────────┐
│           REAL-TIME MESSAGE FLOW                    │
└─────────────────────────────────────────────────────┘

SENDER SIDE
├─ User types message
├─ Press Send button
├─ Message object created
│  └─ {senderId, receiverId, content, timestamp}
├─ Message sent to Supabase
├─ Supabase stores message
├─ Supabase broadcasts to receivers
└─ UI updates with "sent" status

RECEIVER SIDE (REAL-TIME)
├─ Supabase Realtime subscription active
├─ Receives broadcast of new message
├─ Message object received
├─ Update local state (ChatController)
├─ Rebuild UI with new message
├─ Mark message as received (optional)
└─ Show notification (if app in background)

NOTIFICATION FLOW (APP IN BACKGROUND)
├─ Firebase Cloud Messaging receives push
├─ Local notification created
├─ User taps notification
├─ Open app/navigate to chat
├─ Load message history
└─ Display full chat thread
```

### Supabase Realtime Implementation

```dart
// Subscribe to messages in real-time
supabase
  .from('messages')
  .stream(primaryKey: ['id'])
  .where('chat_room_id', 'eq', chatRoomId)
  .listen((List<Map<String, dynamic>> data) {
    // Update chat messages in real-time
    chatController.updateMessages(data);
  });

// Send message
await supabase.from('messages').insert({
  'sender_id': currentUserId,
  'receiver_id': recipientId,
  'content': messageText,
  'timestamp': DateTime.now().toIso8601String(),
  'is_read': false,
});
```

---

## Notifications System

### Notification Architecture

```
┌──────────────────────────────────────────────┐
│         NOTIFICATION SYSTEM FLOW             │
└──────────────────────────────────────────────┘

EVENT TRIGGER
├─ Message received
├─ Friend request sent
├─ Friend accepted request
├─ Server invitation
└─ Other app events

NOTIFICATION DISPATCH
├─ Determine notification type
├─ Create notification payload
│  └─ {title, body, data}
├─ Route to appropriate handler
│
├─ APP IN FOREGROUND
│ └─ Show local notification only
│
└─ APP IN BACKGROUND
   ├─ Firebase Cloud Messaging
   ├─ Receive push notification
   ├─ Display system notification
   ├─ Store notification in app
   └─ Notify when app opens

USER INTERACTION
├─ User taps notification
├─ Notification handler triggered
├─ Extract notification data
├─ Route to appropriate screen
└─ Update UI with context
```

### Firebase Cloud Messaging Setup

```dart
// Initialize FCM
FirebaseMessaging messaging = FirebaseMessaging.instance;

// Request permission
NotificationSettings settings = 
  await messaging.requestPermission();

// Get device token
String? token = await messaging.getToken();

// Listen to foreground messages
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  // Handle notification in foreground
  _showLocalNotification(
    message.notification?.title ?? '',
    message.notification?.body ?? '',
  );
});

// Listen to background messages
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
```

---

## Setup & Configuration

### Prerequisites
- Flutter SDK 2.17.0 or higher
- Dart SDK compatible with Flutter
- Android SDK (for Android development)
- Xcode (for iOS development)
- Firebase project
- Supabase project

### Step 1: Clone & Install Dependencies

```bash
# Clone the repository
git clone <repo-url>
cd Pulse

# Install Flutter dependencies
flutter pub get

# Generate necessary code
flutter pub run build_runner build
```

### Step 2: Firebase Configuration

1. **Create Firebase Project**
   - Go to Firebase Console
   - Create new project "Pulse"
   - Enable Authentication methods:
     - Email/Password
     - Google Sign-In
     - Apple Sign-In

2. **Enable Firestore Database**
   - Create Firestore database
   - Set security rules

3. **Configure Firebase for Flutter**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase
   flutterfire configure
   ```

4. **Download Configuration Files**
   - `google-services.json` → `android/app/`
   - `GoogleService-Info.plist` → `ios/Runner/`

### Step 3: Supabase Configuration

1. **Create Supabase Project**
   - Go to Supabase Console
   - Create new project
   - Create database tables for:
     - messages
     - chat_rooms
     - user_metadata

2. **Update Configuration in Code**
   ```dart
   // lib/main.dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

3. **Enable Realtime**
   - Enable realtime for necessary tables
   - Configure RLS (Row Level Security)

### Step 4: Google Sign-In Setup

**Android:**
```bash
# Get your Android app's SHA-1 fingerprint
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Add SHA-1 to Firebase Console
# Project Settings → Android App → Add SHA-1
```

**iOS:**
- Add URL schemes in Xcode
- Configure OAuth consent screen in Google Cloud

### Step 5: Apple Sign-In Setup

- Enable Apple Sign-In capability in Xcode
- Configure in Apple Developer Account
- Add Apple credentials to Firebase

---

## Build & Deployment

### Development Build

```bash
# Run in debug mode
flutter run -d <device-id>

# Run with verbose output
flutter run -v

# Run on specific device
flutter run -d emulator-5556  # Android emulator
flutter run -d "iPhone 14"     # iOS simulator
```

### Release Build

#### Android Release Build

```bash
# Generate keystore (one-time)
keytool -genkey -v -keystore ~/my-release-key.keystore \
  -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output locations:
# APK: build/app/outputs/apk/release/app-release.apk
# App Bundle: build/app/outputs/bundle/release/app-release.aab
```

#### iOS Release Build

```bash
# Build iOS app
flutter build ios --release

# Archive for App Store
xcode_proj="ios/Runner.xcodeproj"
flutter build ios --release

# Open in Xcode for final configuration
open ios/Runner.xcworkspace

# Archive and upload to App Store
# Use Xcode's Organizer or Command Line Tools
```

### Firebase Deployment Configuration

```bash
# Initialize Firebase project
firebase init

# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy cloud functions (if any)
firebase deploy --only functions
```

### Environment Variables

Create `.env` file (for local development):
```
FIREBASE_PROJECT_ID=your-project-id
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_OAUTH_CLIENT_ID=your-oauth-id
APPLE_TEAM_ID=your-team-id
```

---

## Performance Optimization Tips

1. **Image Optimization**
   - Use CachedNetworkImage for profile pictures
   - Compress images before upload
   - Use appropriate image formats

2. **Database Queries**
   - Use indexes on frequently queried fields
   - Paginate message lists
   - Cache user profiles locally

3. **Memory Management**
   - Dispose of controllers properly
   - Unsubscribe from streams when not in use
   - Use GetX lifecycle methods

4. **UI Performance**
   - Use const constructors where possible
   - Implement efficient list builders
   - Avoid rebuilding entire widgets

5. **Battery & Network**
   - Batch API requests
   - Implement offline mode
   - Use compression for data transfer

---

## Troubleshooting

### Common Issues & Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Build failed - dependency error | Outdated pubspec.lock | `flutter pub get` and `flutter pub upgrade` |
| Firebase auth error | Firebase not initialized | Ensure Firebase initialization in main.dart |
| Supabase connection timeout | Network/URL issue | Check Supabase credentials in main.dart |
| Messages not syncing | Realtime not enabled | Enable realtime in Supabase dashboard |
| Push notifications not working | FCM token not registered | Check notification permissions |
| UI not updating | State not properly managed | Use GetX .obs() and .update() |
| App crashes on startup | Missing permissions | Check AndroidManifest.xml and iOS permissions |

---

## Future Enhancements

1. **Video/Audio Calls** - Integrate WebRTC or Twilio
2. **End-to-End Encryption** - Implement E2E for messages
3. **File Sharing** - Add cloud storage integration
4. **Rich Media Support** - Stickers, GIFs, media gallery
5. **AI Features** - Message translation, smart suggestions
6. **Offline Support** - Local message drafts, offline indicators
7. **Analytics** - Enhanced user behavior tracking
8. **Monetization** - In-app purchases, premium features
9. **Accessibility** - Screen reader support, text scaling
10. **Internationalization** - Multi-language support

---

## Resources & Documentation

- **Flutter Official Docs:** https://flutter.dev/docs
- **Firebase Documentation:** https://firebase.google.com/docs
- **Supabase Documentation:** https://supabase.com/docs
- **GetX Documentation:** https://github.com/jonataslaw/getx
- **Material Design:** https://material.io/design
- **Dart Language:** https://dart.dev/guides

---

## Support & Contributing

For issues, questions, or contributions:
1. Check existing documentation
2. Review error messages carefully
3. Check GitHub issues
4. Create detailed bug reports
5. Follow code style guidelines

---

## License

This project is proprietary software. All rights reserved.

---

## Author

**Mahesh Raj**  
GitHub: [@MaheshRaj77](https://github.com/MaheshRaj77)

---

**Last Updated:** October 31, 2025  
**Version:** 1.0.0
