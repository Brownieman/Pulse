import 'package:flutter/material.dart';
import 'package:talkzy_beta1/models/user_model.dart';
import 'package:talkzy_beta1/theme/app_theme.dart';
import 'package:talkzy_beta1/theme/theme_helper.dart';
import 'package:talkzy_beta1/utils/privacy_helper.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double radius;
  final bool showOnlineStatus;
  final String? viewerId;
  final bool isFriend;

  const UserAvatar({
    super.key,
    required this.user,
    required this.radius,
    required this.showOnlineStatus,
    this.viewerId,
    this.isFriend = false,
  });

  @override
  Widget build(BuildContext context) {
    final canViewPhoto = PrivacyHelper.canViewProfilePhoto(user, viewerId ?? '');

    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppTheme.primaryColor,
          backgroundImage: canViewPhoto ? _getBackgroundImage() : null,
          child: canViewPhoto && _getBackgroundImage() != null
              ? null
              : Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: radius * 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        if (showOnlineStatus && PrivacyHelper.shouldShowOnlineStatus(user))
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.36,
              height: radius * 0.36,
              decoration: BoxDecoration(
                color: AppTheme.successColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ThemeHelper.cardColor(context),
                  width: radius * 0.12,
                ),
              ),
            ),
          ),
      ],
    );
  }

  ImageProvider? _getBackgroundImage() {
    if (user.photoURL.isNotEmpty) {
      return NetworkImage(user.photoURL);
    }
    if (user.avatarCode != null && user.avatarCode!.isNotEmpty) {
      return AssetImage('assets/images/${user.avatarCode}.png');
    }
    if (user.gender == 'male') {
      return const AssetImage('assets/images/male_avatar.png');
    } else if (user.gender == 'female') {
      return const AssetImage('assets/images/female_avatar.png');
    }
    return null;
  }
}
