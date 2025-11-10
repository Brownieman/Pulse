import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:talkzy_beta1/controllers/auth_controller.dart';
import 'package:talkzy_beta1/models/server_model.dart';
import 'package:talkzy_beta1/services/server_service.dart';

class ServerController extends GetxController {
  final ServerService _serverService = ServerService();
  final AuthController _authController = Get.find<AuthController>();
  final Uuid _uuid = Uuid();

  final RxList<ServerModel> _userServers = <ServerModel>[].obs;
  final RxList<ServerModel> _publicServers = <ServerModel>[].obs;
  final RxList<ServerChannelModel> _currentChannels =
      <ServerChannelModel>[].obs;
  final RxList<ServerMessageModel> _currentMessages =
      <ServerMessageModel>[].obs;
  final RxList<ServerTaskModel> _currentTasks = <ServerTaskModel>[].obs;
  final RxList<Map<String, dynamic>> _currentMembers =
      <Map<String, dynamic>>[].obs;
  final RxList<ServerThreadModel> _currentThreads = <ServerThreadModel>[].obs;
  final RxList<ServerThreadReplyModel> _threadReplies =
      <ServerThreadReplyModel>[].obs;

  final Rx<ServerModel?> _selectedServer = Rx<ServerModel?>(null);
  final Rx<ServerChannelModel?> _selectedChannel =
      Rx<ServerChannelModel?>(null);
  final Rx<ServerThreadModel?> _selectedThread = Rx<ServerThreadModel?>(null);

  final RxBool _isLoading = false.obs;
  final RxBool _isSending = false.obs;
  final RxString _error = ''.obs;
  final RxString _searchQuery = ''.obs;

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  StreamSubscription<List<ServerModel>>? _userServersSub;
  StreamSubscription<List<ServerModel>>? _publicServersSub;
  StreamSubscription<List<ServerChannelModel>>? _channelsSub;
  StreamSubscription<List<ServerMessageModel>>? _messagesSub;
  StreamSubscription<List<ServerTaskModel>>? _tasksSub;
  StreamSubscription<List<Map<String, dynamic>>>? _membersSub;
  StreamSubscription<List<ServerThreadModel>>? _threadsSub;
  StreamSubscription<List<ServerThreadReplyModel>>? _repliesSub;

  // Getters
  List<ServerModel> get userServers => _userServers;
  List<ServerModel> get publicServers => _publicServers;
  List<ServerChannelModel> get currentChannels => _currentChannels;
  List<ServerMessageModel> get currentMessages => _currentMessages;
  List<ServerTaskModel> get currentTasks => _currentTasks;
  List<Map<String, dynamic>> get currentMembers => _currentMembers;
  List<ServerThreadModel> get currentThreads => _currentThreads;
  List<ServerThreadReplyModel> get threadReplies => _threadReplies;

  ServerModel? get selectedServer => _selectedServer.value;
  ServerChannelModel? get selectedChannel => _selectedChannel.value;
  ServerThreadModel? get selectedThread => _selectedThread.value;

  bool get isLoading => _isLoading.value;
  bool get isSending => _isSending.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;

  List<ServerModel> get filteredPublicServers {
    if (_searchQuery.value.isEmpty) {
      return _publicServers;
    }
    return _publicServers
        .where((server) =>
            server.name
                .toLowerCase()
                .contains(_searchQuery.value.toLowerCase()) ||
            server.description
                .toLowerCase()
                .contains(_searchQuery.value.toLowerCase()))
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserServers();
    _loadPublicServers();
  }

  @override
  void onClose() {
    _userServersSub?.cancel();
    _publicServersSub?.cancel();
    _channelsSub?.cancel();
    _messagesSub?.cancel();
    _tasksSub?.cancel();
    _membersSub?.cancel();
    _threadsSub?.cancel();
    _repliesSub?.cancel();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // --- Server Management ---

  void _loadUserServers() {
    final currentUserId = _authController.user?.uid;
    if (currentUserId == null) return;

    _userServersSub?.cancel();
    _userServersSub = _serverService.getUserServersStream(currentUserId).listen(
      (servers) {
        _userServers.assignAll(servers);
        print('✅ Loaded ${servers.length} user servers');
      },
      onError: (err) {
        print('❌ Error loading user servers: $err');
        _error.value = err.toString();
      },
    );
  }

  void _loadPublicServers() {
    _publicServersSub?.cancel();
    _publicServersSub = _serverService.getPublicServersStream().listen(
      (servers) {
        _publicServers.assignAll(servers);
        print('✅ Loaded ${servers.length} public servers');
      },
      onError: (err) {
        print('❌ Error loading public servers: $err');
        _error.value = err.toString();
      },
    );
  }

  Future<void> createServer({
    required String name,
    required String description,
    bool isPublic = true,
  }) async {
    try {
      _isLoading.value = true;
      final currentUserId = _authController.user?.uid;

      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final server = ServerModel(
        id: _uuid.v4(),
        name: name,
        description: description,
        ownerId: currentUserId,
        isPublic: isPublic,
        members: [currentUserId],
        channels: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        memberCount: 1,
      );

      final serverId = await _serverService.createServer(server);

      // Create default general channel
      final channel = ServerChannelModel(
        id: _uuid.v4(),
        serverId: serverId,
        name: 'general',
        description: 'General channel',
        type: 'text',
        order: 0,
        createdAt: DateTime.now(),
      );

      await _serverService.createChannel(serverId, channel);

      Get.snackbar(
        'Success',
        'Server "$name" created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error creating server: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> joinServer(String serverId) async {
    try {
      _isLoading.value = true;
      final currentUserId = _authController.user?.uid;

      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _serverService.joinServer(
        serverId,
        currentUserId,
        _authController.user?.displayName ?? 'User',
      );

      Get.snackbar(
        'Success',
        'Joined server successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      _loadUserServers();
    } catch (e) {
      print('❌ Error joining server: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to join server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> leaveServer(String serverId) async {
    try {
      _isLoading.value = true;
      final currentUserId = _authController.user?.uid;

      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      await _serverService.leaveServer(serverId, currentUserId);

      // Clear selection if leaving current server
      if (_selectedServer.value?.id == serverId) {
        _selectedServer.value = null;
        _selectedChannel.value = null;
        _currentChannels.clear();
        _currentMessages.clear();
      }

      Get.snackbar(
        'Success',
        'Left server successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      _loadUserServers();
    } catch (e) {
      print('❌ Error leaving server: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to leave server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteServer(String serverId) async {
    try {
      _isLoading.value = true;
      final server = _userServers.firstWhereOrNull((s) => s.id == serverId);

      if (server == null) {
        throw Exception('Server not found');
      }

      final currentUserId = _authController.user?.uid;
      if (currentUserId != server.ownerId) {
        throw Exception('Only server owner can delete the server');
      }

      await _serverService.deleteServer(serverId);

      Get.snackbar(
        'Success',
        'Server deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );

      _loadUserServers();
    } catch (e) {
      print('❌ Error deleting server: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void selectServer(ServerModel server) {
    _selectedServer.value = server;
    _selectedChannel.value = null;
    _loadChannels(server.id);
    _loadMembers(server.id);
  }

  // --- Channel Management ---

  void _loadChannels(String serverId) {
    _channelsSub?.cancel();
    _messagesSub?.cancel();
    _tasksSub?.cancel();
    _currentChannels.clear();
    _currentMessages.clear();
    _currentTasks.clear();

    _channelsSub = _serverService.getServerChannelsStream(serverId).listen(
      (channels) {
        _currentChannels.assignAll(channels);
        print('✅ Loaded ${channels.length} channels');

        // Auto-select first channel
        if (channels.isNotEmpty && _selectedChannel.value == null) {
          selectChannel(channels.first);
        }
      },
      onError: (err) {
        print('❌ Error loading channels: $err');
        _error.value = err.toString();
      },
    );
  }

  void selectChannel(ServerChannelModel channel) {
    _selectedChannel.value = channel;
    _loadMessages(channel.serverId, channel.id);
    _loadTasks(channel.serverId, channel.id);
  }

  Future<void> createChannel({
    required String serverId,
    required String name,
    required String description,
  }) async {
    try {
      _isLoading.value = true;

      final channel = ServerChannelModel(
        id: _uuid.v4(),
        serverId: serverId,
        name: name,
        description: description,
        type: 'text',
        order: _currentChannels.length,
        createdAt: DateTime.now(),
      );

      await _serverService.createChannel(serverId, channel);

      Get.snackbar(
        'Success',
        'Channel "$name" created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error creating channel: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create channel: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // --- Message Management ---

  void _loadMessages(String serverId, String channelId) {
    _messagesSub?.cancel();
    _currentMessages.clear();

    _messagesSub =
        _serverService.getChannelMessagesStream(serverId, channelId).listen(
      (messages) {
        _currentMessages.assignAll(messages);
        print('✅ Loaded ${messages.length} messages');
        _scrollToBottom();
      },
      onError: (err) {
        print('❌ Error loading messages: $err');
        _error.value = err.toString();
      },
    );
  }

  Future<void> sendMessage() async {
    final currentUserId = _authController.user?.uid;
    final currentUserName = _authController.user?.displayName ?? 'User';
    final serverId = _selectedServer.value?.id;
    final channelId = _selectedChannel.value?.id;
    final content = messageController.text.trim();

    if (currentUserId == null ||
        serverId == null ||
        channelId == null ||
        content.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot send empty message',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      _isSending.value = true;
      messageController.clear();

      final message = ServerMessageModel(
        id: _uuid.v4(),
        serverId: serverId,
        channelId: channelId,
        senderId: currentUserId,
        senderName: currentUserName,
        content: content,
        timestamp: DateTime.now(),
      );

      await _serverService.sendServerMessage(serverId, channelId, message);
      print('✅ Message sent successfully');
    } catch (e) {
      print('❌ Error sending message: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to send message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isSending.value = false;
    }
  }

  Future<void> deleteMessage(ServerMessageModel message) async {
    try {
      final serverId = _selectedServer.value?.id;
      final channelId = _selectedChannel.value?.id;

      if (serverId == null || channelId == null) return;

      await _serverService.deleteServerMessage(serverId, channelId, message.id);

      Get.snackbar(
        'Success',
        'Message deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error deleting message: $e');
      Get.snackbar(
        'Error',
        'Failed to delete message: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // --- Task Management ---

  void _loadTasks(String serverId, String channelId) {
    _tasksSub?.cancel();
    _currentTasks.clear();

    _tasksSub =
        _serverService.getChannelTasksStream(serverId, channelId).listen(
      (tasks) {
        _currentTasks.assignAll(tasks);
        print('✅ Loaded ${tasks.length} tasks');
      },
      onError: (err) {
        print('❌ Error loading tasks: $err');
        _error.value = err.toString();
      },
    );
  }

  Future<void> createTask({
    required String title,
    required String description,
    required String assignedToId,
    required String assignedToName,
    required DateTime dueDate,
    bool isPriority = false,
  }) async {
    try {
      _isLoading.value = true;
      final currentUserId = _authController.user?.uid;
      final currentUserName = _authController.user?.displayName ?? 'User';
      final serverId = _selectedServer.value?.id;
      final channelId = _selectedChannel.value?.id;

      if (currentUserId == null || serverId == null || channelId == null) {
        throw Exception('Invalid server or channel');
      }

      final task = ServerTaskModel(
        id: _uuid.v4(),
        serverId: serverId,
        channelId: channelId,
        title: title,
        description: description,
        assignedToId: assignedToId,
        assignedToName: assignedToName,
        assignedById: currentUserId,
        assignedByName: currentUserName,
        dueDate: dueDate,
        isPriority: isPriority,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      await _serverService.createServerTask(serverId, channelId, task);

      Get.snackbar(
        'Success',
        'Task created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error creating task: $e');
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateTaskStatus(ServerTaskModel task, String newStatus) async {
    try {
      final serverId = _selectedServer.value?.id;
      final channelId = _selectedChannel.value?.id;

      if (serverId == null || channelId == null) return;

      await _serverService.updateServerTask(
        serverId,
        channelId,
        task.id,
        {'status': newStatus},
      );

      Get.snackbar(
        'Success',
        'Task updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error updating task: $e');
      Get.snackbar(
        'Error',
        'Failed to update task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> deleteTask(ServerTaskModel task) async {
    try {
      final serverId = _selectedServer.value?.id;
      final channelId = _selectedChannel.value?.id;

      if (serverId == null || channelId == null) return;

      await _serverService.deleteServerTask(serverId, channelId, task.id);

      Get.snackbar(
        'Success',
        'Task deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error deleting task: $e');
      Get.snackbar(
        'Error',
        'Failed to delete task: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // --- Member Management ---

  void _loadMembers(String serverId) {
    _membersSub?.cancel();
    _currentMembers.clear();

    _membersSub = _serverService.getServerMembersStream(serverId).listen(
      (members) {
        _currentMembers.assignAll(members);
        print('✅ Loaded ${members.length} members');
      },
      onError: (err) {
        print('❌ Error loading members: $err');
        _error.value = err.toString();
      },
    );
  }

  // --- Search ---

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  Future<List<ServerModel>> searchServers(String query) async {
    try {
      return await _serverService.searchServers(query);
    } catch (e) {
      print('❌ Error searching servers: $e');
      _error.value = e.toString();
      return [];
    }
  }

  void clearError() {
    _error.value = '';
  }

  bool isMyMessage(ServerMessageModel message) {
    return message.senderId == _authController.user?.uid;
  }

  String formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    String format12Hour(DateTime dt) {
      int hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      String minute = dt.minute.toString().padLeft(2, '0');
      String ampm = dt.hour < 12 ? 'AM' : 'PM';
      return '$hour:$minute $ampm';
    }

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return format12Hour(timestamp);
    } else if (difference.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final weekday = days[timestamp.weekday - 1];
      return '$weekday ${format12Hour(timestamp)}';
    } else {
      return '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year} ${format12Hour(timestamp)}';
    }
  }

  // --- Thread Management ---

  void selectThread(ServerThreadModel thread) {
    _selectedThread.value = thread;
    _loadThreadReplies(thread.id);
  }

  void clearSelectedThread() {
    _selectedThread.value = null;
    _threadReplies.clear();
  }

  void _loadThreadReplies(String threadId) {
    _repliesSub?.cancel();
    _threadReplies.clear();

    // TODO: Load thread replies from Firestore via _serverService
    // For now, initialize as empty list
    print('✅ Loaded thread replies for thread: $threadId');
  }

  Future<void> createThread({
    required String messageId,
    required String title,
  }) async {
    try {
      final serverId = _selectedServer.value?.id;
      final channelId = _selectedChannel.value?.id;
      final currentUserId = _authController.user?.uid;
      final startName = _authController.user?.displayName ?? 'User';

      if (serverId == null || channelId == null || currentUserId == null) {
        throw Exception('Missing required data');
      }

      final thread = ServerThreadModel(
        id: _uuid.v4(),
        serverId: serverId,
        channelId: channelId,
        messageId: messageId,
        title: title,
        starterName: startName,
        starterId: currentUserId,
        createdAt: DateTime.now(),
        replyCount: 0,
        lastReplyAt: DateTime.now(),
      );

      // TODO: Save thread to Firestore via _serverService
      // await _serverService.createThread(serverId, channelId, thread);

      _currentThreads.add(thread);

      Get.snackbar(
        'Success',
        'Thread created',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error creating thread: $e');
      Get.snackbar(
        'Error',
        'Failed to create thread: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> sendThreadReply({
    required String content,
  }) async {
    try {
      if (_selectedThread.value == null) {
        throw Exception('No thread selected');
      }

      _isSending.value = true;
      final threadId = _selectedThread.value!.id;
      final serverId = _selectedServer.value?.id;
      final channelId = _selectedChannel.value?.id;
      final currentUserId = _authController.user?.uid;
      final senderName = _authController.user?.displayName ?? 'User';

      if (serverId == null || channelId == null || currentUserId == null) {
        throw Exception('Missing required data');
      }

      final reply = ServerThreadReplyModel(
        id: _uuid.v4(),
        threadId: threadId,
        serverId: serverId,
        channelId: channelId,
        senderId: currentUserId,
        senderName: senderName,
        content: content,
        timestamp: DateTime.now(),
      );

      // TODO: Save reply to Firestore via _serverService
      // await _serverService.createThreadReply(serverId, threadId, reply);

      _threadReplies.add(reply);

      // Update thread reply count and last reply time
      final threadIndex = _currentThreads.indexWhere(
        (t) => t.id == threadId,
      );

      if (threadIndex != -1) {
        final updatedThread = _currentThreads[threadIndex].copyWith(
          replyCount: _currentThreads[threadIndex].replyCount + 1,
          lastReplyAt: DateTime.now(),
        );
        _currentThreads[threadIndex] = updatedThread;
      }
    } catch (e) {
      print('❌ Error sending thread reply: $e');
      Get.snackbar(
        'Error',
        'Failed to send reply: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      _isSending.value = false;
    }
  }

  Future<void> deleteThread(ServerThreadModel thread) async {
    try {
      final serverId = _selectedServer.value?.id;

      if (serverId == null) return;

      // TODO: Delete from Firestore via _serverService
      // await _serverService.deleteThread(serverId, thread.id);

      _currentThreads.removeWhere((t) => t.id == thread.id);

      if (_selectedThread.value?.id == thread.id) {
        clearSelectedThread();
      }

      Get.snackbar(
        'Success',
        'Thread deleted',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      print('❌ Error deleting thread: $e');
      Get.snackbar(
        'Error',
        'Failed to delete thread: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
