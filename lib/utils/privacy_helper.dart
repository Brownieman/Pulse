import 'package:talkzy_beta1/models/user_model.dart';

class PrivacyHelper {
  // Check if online status should be shown
  static bool shouldShowOnlineStatus(UserModel user) {
    return user.isOnline && user.showLastSeen;
  }

  static bool isVisiblyOnline(UserModel user) {
    return shouldShowOnlineStatus(user);
  }

  // Get display text for last seen
  static String getDisplayLastSeen(UserModel user, DateTime? lastSeen) {
    if (!user.showLastSeen) {
      return '';
    }

    if (lastSeen == null) {
      return 'Last seen recently';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 1) {
      return 'Last seen just now';
    } else if (difference.inHours < 1) {
      return 'Last seen ${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return 'Last seen ${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return 'Last seen ${difference.inDays}d ago';
    } else {
      return 'Last seen ${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
    }
  }

  static String getOnlineStatusText(UserModel user) {
    if (!user.showLastSeen) {
      return '';
    }
    if (user.isOnline) {
      return 'Online';
    }
    return getDisplayLastSeen(user, user.lastSeen);
  }

  // Check if profile photo should be visible
  static bool canViewProfilePhoto(UserModel user, String viewerId) {
    switch (user.profilePhotoVisibility) {
      case 'everyone':
        return true;
      case 'friends':
        // TODO: Check if viewer is friend
        return true;
      case 'nobody':
        return user.id == viewerId;
      default:
        return true;
    }
  }

  // Check if bio should be visible
  static bool canViewBio(UserModel user, String viewerId) {
    switch (user.bioVisibility) {
      case 'everyone':
        return true;
      case 'friends':
        // TODO: Check if viewer is friend
        return true;
      case 'nobody':
        return user.id == viewerId;
      default:
        return true;
    }
  }
}
