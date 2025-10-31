# Pulse Application - Quick Reference

## 📱 What is Pulse?

Pulse is a modern real-time messaging and social application built with Flutter. It combines instant messaging, friend management, task tracking, and community features into a single cohesive app.

---

## 🎯 Core Features

| Feature | Description |
|---------|-------------|
| **Real-Time Messaging** | Instant chat with friends using Supabase Realtime |
| **Friend System** | Send/accept friend requests and manage friends |
| **User Discovery** | Find and connect with other users |
| **Task Management** | Create and track personal tasks |
| **Servers/Channels** | Create or join community servers |
| **Analytics** | View engagement stats and trust scores |
| **Notifications** | Push notifications via Firebase Cloud Messaging |
| **Theme Support** | Dark/Light theme customization |
| **Privacy Controls** | Manage privacy settings and block users |

---

## 🏗️ Technical Architecture

**Design Pattern:** MVC + GetX State Management

```
UI (Screens) → Controllers (GetX) → Services → Backend (Firebase + Supabase)
```

- **Frontend:** Flutter
- **State Management:** GetX
- **Authentication:** Firebase Auth
- **Database:** Firestore + Supabase PostgreSQL
- **Real-Time:** Supabase Realtime
- **Notifications:** Firebase Cloud Messaging

---

## 📁 Project Structure

```
lib/
├── main.dart              # Entry point
├── home_screen.dart       # Main dashboard
├── controllers/           # GetX state management (13 controllers)
├── screens/              # UI pages (10+ screens)
├── services/             # Backend services (7 services)
├── models/               # Data models
├── routes/               # Navigation routing
├── theme/                # Theme & styling
├── utils/                # Helper functions
└── views/                # Reusable widgets
```

---

## 🔐 Authentication Methods

1. **Email/Password** - Traditional email authentication
2. **Google Sign-In** - OAuth with Google account
3. **Apple Sign-In** - OAuth with Apple ID

---

## 💬 Real-Time Messaging Flow

```
User Types Message → Send → Supabase → Broadcast → Receiver Updates UI
                                    ↓
                          Firebase Notification
                          (if app in background)
```

---

## 🎨 Screens Overview

| Screen | Purpose |
|--------|---------|
| **Auth Screen** | Login/Sign up with email or social auth |
| **Home Screen** | Main dashboard with navigation tabs |
| **Messages** | List of active chats |
| **Chat Screen** | One-on-one messaging with real-time updates |
| **Friends** | Friends list and friend requests |
| **Discovery** | Search and add new friends |
| **Servers** | Browse and join community servers |
| **Tasks** | Manage personal tasks |
| **Analytics** | View stats and trust score |
| **Settings** | Profile, privacy, theme, notifications |

---

## 🎮 Controllers (State Management)

All controllers use GetX for reactive state management:

- `AuthController` - Authentication & user session
- `ChatController` - Chat messaging logic
- `HomeController` - Home screen state
- `FriendsController` - Friends management
- `FriendRequestsController` - Friend request handling
- `ThemeController` - Theme switching
- `NotificationController` - Notification handling
- `ProfileController` - User profile management
- `SettingsController` - App settings
- `PrivacyController` - Privacy preferences
- Plus 3 more specialized controllers

---

## 🔧 Services Layer

- **AuthService** - Firebase authentication operations
- **FirestoreService** - Firestore database operations
- **SupabaseService** - Supabase database & realtime
- **NotificationService** - FCM and local notifications
- **LocalStorageService** - Encrypted local storage
- **FirebaseSetupService** - Firebase initialization
- **FirebaseMessagingService** - Push notification setup

---

## 📊 Database Schema (Simplified)

**Firestore:**
- Users - User profiles and metadata
- Friend Requests - Pending friend requests
- User Settings - Privacy & preferences

**Supabase PostgreSQL:**
- messages - Chat messages
- chat_rooms - Chat room metadata
- servers - Community servers
- server_channels - Channels within servers
- tasks - User tasks
- notifications - Notification history

---

## 🚀 Getting Started

### Prerequisites
```bash
- Flutter SDK >= 2.17.0
- Dart SDK (included with Flutter)
- Firebase Project
- Supabase Project
```

### Setup Steps

1. **Clone & Install**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   ```bash
   flutterfire configure
   # Download google-services.json for Android
   # Download GoogleService-Info.plist for iOS
   ```

3. **Configure Supabase**
   - Update credentials in `lib/main.dart`
   - Initialize database tables

4. **Run App**
   ```bash
   flutter run
   ```

---

## 📦 Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| flutter | - | Framework |
| get | 4.7.2 | State management & routing |
| firebase_auth | 5.3.1 | Authentication |
| cloud_firestore | 5.4.4 | Database |
| firebase_messaging | 15.0.2 | Push notifications |
| supabase_flutter | 2.3.3 | Real-time DB & auth |
| firebase_core | 3.6.0 | Firebase core |
| flutter_bloc | 9.1.1 | BLoC pattern |

---

## 🎨 Theming

The app supports:
- **Dark Theme** - Optimized for night viewing
- **Light Theme** - Optimized for day viewing
- **Chat Themes** - Message bubble customization

Theme state is managed by `ThemeController` and persisted locally.

---

## 🔔 Notification Types

| Type | Trigger | Handler |
|------|---------|---------|
| Message | New chat message | Navigate to chat |
| Friend Request | Friend request sent | Show request screen |
| Friend Accepted | Friend request accepted | Update friends list |
| Server Invite | Invited to server | Show server invite |
| General | Custom events | App-defined action |

---

## ⚙️ Build & Deploy

### Development
```bash
flutter run -d <device-id>
```

### Android Release
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS Release
```bash
flutter build ios --release
```

---

## 🐛 Common Issues

| Problem | Solution |
|---------|----------|
| Build fails | Run `flutter pub get` and `flutter clean` |
| Firebase not initializing | Check `google-services.json` file |
| Messages not syncing | Enable Realtime in Supabase dashboard |
| Notifications not working | Check notification permissions |
| Crashes on login | Verify Firebase credentials |

---

## 📚 Documentation Files

- **DOCUMENTATION.md** - Complete detailed documentation (1355 lines)
  - Architecture diagrams
  - Flow charts
  - API references
  - Setup instructions
  - Troubleshooting guide

---

## 🔐 Security Notes

- Use environment variables for sensitive credentials
- Enable Firestore security rules
- Enable Supabase RLS (Row Level Security)
- Never commit API keys to version control
- Use HTTPS for all external communications

---

## 📈 Performance Tips

1. Use `CachedNetworkImage` for images
2. Paginate long lists
3. Use indexed Firestore queries
4. Dispose of controllers properly
5. Batch API requests
6. Implement offline mode

---

## 🔮 Future Enhancements

- Video/Audio calls (WebRTC)
- End-to-end encryption
- File sharing with cloud storage
- AI-powered features (translation, suggestions)
- Offline message drafts
- Rich media (stickers, GIFs)
- Monetization features

---

## 📞 Support

For issues or questions:
1. Check DOCUMENTATION.md first
2. Review error messages carefully
3. Check GitHub issues
4. Create detailed bug reports

---

## 👨‍💻 Author

**Mahesh Raj**  
GitHub: [@MaheshRaj77](https://github.com/MaheshRaj77)

---

**Last Updated:** October 31, 2025  
**Documentation Version:** 1.0.0
