class PerformanceConfig {
  // Maximum number of messages to load per chat
  static const int maxMessagesLimit = 100;

  // Maximum number of chats to load
  static const int maxChatsLimit = 50;

  // Maximum number of notifications to load
  static const int maxNotificationsLimit = 50;

  // Cache duration for images
  static const Duration imageCacheDuration = Duration(days: 7);

  // Debounce duration for search
  static const Duration searchDebounceDuration = Duration(milliseconds: 500);
}
