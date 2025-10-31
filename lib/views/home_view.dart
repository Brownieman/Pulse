import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/home_controller.dart';
import 'package:talkzy_beta1/routes/app_routes.dart';
import 'package:talkzy_beta1/theme/app_theme.dart';
import 'package:talkzy_beta1/theme/theme_helper.dart';
import 'package:talkzy_beta1/views/widgets/chat_list_item.dart';
import 'package:talkzy_beta1/views/widgets/user_avatar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Column(
          children: [
            _buildSearchBar(controller),
            Expanded(
              child: _buildBody(controller),
            )
          ],
        );
      },
    );
  }

  Widget _buildBody(HomeController controller) {
    if (controller.isSearching && controller.searchQuery.isNotEmpty) {
      final hasResults = controller.filteredChats.isNotEmpty;
      return hasResults
          ? _buildSearchChatsList(controller)
          : _buildNoSearchResults();
    }

    final hasAnyData = controller.activeUsers.isNotEmpty ||
        controller.chats.isNotEmpty ||
        controller.remainingFriends.isNotEmpty;

    if (!hasAnyData) return _buildEmptyState();

    return _buildMainContent(controller);
  }

  Widget _buildSearchBar(HomeController controller) {
    return Container(
      color: ThemeHelper.backgroundColor(Get.context!),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Material(
        color: ThemeHelper.cardColor(Get.context!),
        borderRadius: BorderRadius.circular(12),
        child: TextField(
          onChanged: controller.onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search conversations...',
            hintStyle: TextStyle(
              color:
                  ThemeHelper.textSecondaryColor(Get.context!).withOpacity(0.8),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color:
                  ThemeHelper.textSecondaryColor(Get.context!).withOpacity(0.8),
              size: 20,
            ),
            suffixIcon: controller.searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearSearch,
                    icon: Icon(
                      Icons.clear_rounded,
                      color: ThemeHelper.textSecondaryColor(Get.context!)
                          .withOpacity(0.8),
                      size: 18,
                    ))
                : const SizedBox.shrink(),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActiveFriendsSection(controller),
        _buildRecentChatsHeader(),
        Expanded(child: _buildRecentChatsList(controller)),
      ],
    );
  }

  Widget _buildActiveFriendsSection(HomeController controller) {
    final hasActive = controller.activeUsers.isNotEmpty;
    final hasFriends = controller.remainingFriends.isNotEmpty;

    if (!hasActive && !hasFriends) return const SizedBox.shrink();

    // Responsive sizing
    final screenWidth = Get.width;
    final friendSectionHeight = screenWidth > 400 ? 120.0 : 100.0;
    final avatarRadius = screenWidth > 400 ? 32.0 : 28.0;
    final nameFontSize = screenWidth > 400 ? 12.0 : 11.0;
    final spacing = screenWidth > 400 ? 8.0 : 6.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Active Friends',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ThemeHelper.textPrimaryColor(Get.context!),
            ),
          ),
        ),
        Container(
          height: friendSectionHeight,
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                ...controller.activeUsers.map((user) => 
                  GestureDetector(
                    onTap: () {
                      // Handle tap on user avatar
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: spacing),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserAvatar(
                            user: user,
                            radius: avatarRadius,
                            showOnlineStatus: true,
                            isFriend: true,
                          ),
                          SizedBox(height: spacing * 1.5),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: avatarRadius * 3.5,
                            ),
                            child: Text(
                              user.displayName.split(' ').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.w500,
                                color: ThemeHelper.textPrimaryColor(Get.context!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ...controller.remainingFriends.map((user) => 
                  GestureDetector(
                    onTap: () {
                      // Handle tap on user avatar
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: spacing),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UserAvatar(
                            user: user,
                            radius: avatarRadius,
                            showOnlineStatus: false,
                            isFriend: true,
                          ),
                          SizedBox(height: spacing * 1.5),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: avatarRadius * 3.5,
                            ),
                            child: Text(
                              user.displayName.split(' ').first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.w500,
                                color: ThemeHelper.textPrimaryColor(Get.context!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentChatsHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        'Recent Chats',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ThemeHelper.textPrimaryColor(Get.context!),
        ),
      ),
    );
  }

  Widget _buildRecentChatsList(HomeController controller) {
    if (controller.chats.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: ThemeHelper.textSecondaryColor(Get.context!),
              ),
              const SizedBox(height: 16),
              Text(
                'No conversations yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.textPrimaryColor(Get.context!),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start chatting with your friends',
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeHelper.textSecondaryColor(Get.context!),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshChats,
      color: AppTheme.primaryColor,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.chats.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: ThemeHelper.borderColor(Get.context!).withOpacity(0.22),
          indent: 72,
        ),
        itemBuilder: (context, index) {
          final chat = controller.chats[index];
          final otherUser = controller.getOtherUser(chat);

          if (otherUser == null) return const SizedBox.shrink();

          return ChatListItem(
            chat: chat,
            otherUser: otherUser,
            lastMessageTime:
                controller.formatLastMessageTime(chat.lastMessageTime),
            onTap: () => controller.openChat(chat),
          );
        },
      ),
    );
  }

  Widget _buildSearchChatsList(HomeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Search Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.textPrimaryColor(Get.context!),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.filteredChats.length,
            separatorBuilder: (context, index) => Divider(
                height: 1,
                color: ThemeHelper.borderColor(Get.context!).withOpacity(0.4),
                indent: 72),
            itemBuilder: (context, index) {
              final chat = controller.filteredChats[index];
              final otherUser = controller.getOtherUser(chat);

              if (otherUser == null) return const SizedBox.shrink();

              return ChatListItem(
                chat: chat,
                otherUser: otherUser,
                lastMessageTime:
                    controller.formatLastMessageTime(chat.lastMessageTime),
                onTap: () => controller.openChat(chat),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: ThemeHelper.textSecondaryColor(Get.context!),
          ),
          const SizedBox(height: 16),
          Text(
            'No conversations found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.textPrimaryColor(Get.context!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 80,
              color: ThemeHelper.textSecondaryColor(Get.context!),
            ),
            const SizedBox(height: 24),
            Text(
              'No Friends Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ThemeHelper.textPrimaryColor(Get.context!),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add friends to start messaging',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.textSecondaryColor(Get.context!),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(AppRoutes.friends),
              icon: const Icon(Icons.person_add),
              label: const Text('Find Friends'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
