import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talkzy_beta1/controllers/server_controller.dart';
import 'package:talkzy_beta1/models/server_model.dart';

// Discord-like color scheme
const Color discordDark = Color(0xFF36393F);
const Color discordChannelList = Color(0xFF2C2F33);
const Color discordChatArea = Color(0xFF36393F);
const Color discordMemberList = Color(0xFF2C2F33);
const Color discordBrand = Color(0xFF7289DA);

class ServerChatScreen extends StatefulWidget {
  const ServerChatScreen({super.key});

  @override
  State<ServerChatScreen> createState() => _ServerChatScreenState();
}

class _ServerChatScreenState extends State<ServerChatScreen> {
  late ServerController _serverController;
  bool _showMembers = true;
  bool _showThreadPanel = false;

  @override
  void initState() {
    super.initState();
    _serverController = Get.find<ServerController>();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: discordChatArea,
      body: Row(
        children: [
          // Left Sidebar - Server/Channel Navigation
          if (!isMobile) _buildLeftSidebar(),

          // Main Chat Area + Thread Panel
          Expanded(
            flex: _showThreadPanel ? 2 : (_showMembers ? 3 : 4),
            child: Column(
              children: [
                // Header with Server/Channel Info
                _buildChatHeader(isMobile),
                // Messages List
                Expanded(
                  child: Obx(() {
                    final messages = _serverController.currentMessages;

                    if (messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No messages yet',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Start the conversation!',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _serverController.scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _buildDiscordMessage(
                          context,
                          message.senderName,
                          message.content,
                          _serverController
                              .formatMessageTime(message.timestamp),
                          messageModel: message,
                          isOwn: _serverController.isMyMessage(message),
                          isEdited: message.isEdited,
                          onDelete: () =>
                              _serverController.deleteMessage(message),
                          onReply: () => _openThreadPanel(message),
                        );
                      },
                    );
                  }),
                ),
                // Message Input
                _buildDiscordMessageInput(context),
              ],
            ),
          ),

          // Thread Panel (Right side when opened)
          if (_showThreadPanel)
            Expanded(
              flex: 1,
              child: _buildThreadPanel(),
            ),

          // Members Sidebar (Right side when no thread)
          if (_showMembers && !isMobile && !_showThreadPanel)
            Expanded(
              flex: 1,
              child: _buildMembersSidebar(),
            ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 240,
      color: discordChannelList,
      child: Column(
        children: [
          // Server Header
          Obx(() {
            final server = _serverController.selectedServer;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server?.name ?? 'Server',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${server?.memberCount ?? 0} members',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }),
          // Channels List
          Expanded(
            child: Obx(() {
              final channels = _serverController.currentChannels;

              if (channels.isEmpty) {
                return Center(
                  child: Text(
                    'No channels',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: channels.length +
                    2, // +2 for "CHANNELS" header and add button
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Channels header
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CHANNELS',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: _showCreateChannelDialog,
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (index == 1 && channels.isNotEmpty) {
                    // First channel
                    final channel = channels[0];
                    return _buildChannelTile(channel);
                  }

                  if (index == channels.length + 1) {
                    return const SizedBox(height: 20);
                  }

                  final channel = channels[index - 1];
                  return _buildChannelTile(channel);
                },
              );
            }),
          ),
          // Bottom User Section
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: discordBrand,
                  child: const Text(
                    'Y',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings, size: 16, color: Colors.grey[400]),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelTile(dynamic channel) {
    final isSelected = _serverController.selectedChannel?.id == channel.id;

    return Container(
      color: isSelected ? discordBrand.withOpacity(0.2) : Colors.transparent,
      child: ListTile(
        leading: Text(
          '#',
          style: TextStyle(
            color: isSelected ? discordBrand : Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text(
          channel.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          _serverController.selectChannel(channel);
        },
        hoverColor: Colors.grey.withOpacity(0.1),
        minLeadingWidth: 24,
      ),
    );
  }

  Widget _buildChatHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: discordChannelList,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(() {
              final channel = _serverController.selectedChannel;
              return Row(
                children: [
                  if (isMobile)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  Text(
                    '# ${channel?.name ?? 'general'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (channel?.description.isNotEmpty ?? false) ...[
                    const SizedBox(width: 12),
                    Text(
                      '•',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        channel!.description,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              );
            }),
          ),
          const SizedBox(width: 16),
          if (!isMobile)
            IconButton(
              icon: Icon(
                Icons.people,
                color: _showMembers ? discordBrand : Colors.grey[500],
                size: 20,
              ),
              onPressed: () {
                setState(() => _showMembers = !_showMembers);
              },
              tooltip: 'Members',
            ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.grey[500], size: 20),
            onPressed: () => _showChannelInfo(),
            tooltip: 'Channel Info',
          ),
        ],
      ),
    );
  }

  Widget _buildDiscordMessage(
    BuildContext context,
    String name,
    String message,
    String time, {
    ServerMessageModel? messageModel,
    bool isOwn = false,
    bool isEdited = false,
    VoidCallback? onDelete,
    VoidCallback? onReply,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12, top: 2),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: discordBrand,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                      if (isEdited) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(edited)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    message,
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  // Thread reply indicator
                  if (messageModel != null && onReply != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: GestureDetector(
                        onTap: onReply,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.reply,
                              size: 14,
                              color: discordBrand,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Reply',
                              style: TextStyle(
                                color: discordBrand,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isOwn && onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, size: 16, color: Colors.grey[600]),
                onPressed: onDelete,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscordMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: discordChannelList,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_circle, color: discordBrand, size: 24),
            onPressed: () => _showAddMenu(),
            tooltip: 'Add attachment',
          ),
          Expanded(
            child: TextField(
              controller: _serverController.messageController,
              decoration: InputDecoration(
                hintText:
                    'Message #${_serverController.selectedChannel?.name ?? "general"}',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[700],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: null,
              minLines: 1,
            ),
          ),
          IconButton(
            icon: Icon(Icons.emoji_emotions, color: Colors.grey[500], size: 22),
            onPressed: () {
              Get.snackbar('Info', 'Emoji picker coming soon!',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
                  backgroundColor: discordBrand);
            },
            tooltip: 'Add emoji',
          ),
          Obx(() {
            return IconButton(
              icon: Icon(
                Icons.send,
                color: _serverController.isSending
                    ? Colors.grey[600]
                    : discordBrand,
                size: 20,
              ),
              onPressed: _serverController.isSending
                  ? null
                  : () => _serverController.sendMessage(),
              tooltip: 'Send message',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMembersSidebar() {
    return Container(
      width: 240,
      color: discordMemberList,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MEMBERS',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Obx(() {
                  final count = _serverController.currentMembers.length;
                  return Text(
                    '$count',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ),
          // Members List
          Expanded(
            child: Obx(() {
              final members = _serverController.currentMembers;

              if (members.isEmpty) {
                return Center(
                  child: Text(
                    'No members',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final isOnline = member['isOnline'] == true;

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: discordBrand,
                              child: Text(
                                (member['displayName'] as String?)
                                            ?.isNotEmpty ==
                                        true
                                    ? (member['displayName'] as String)[0]
                                        .toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isOnline)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: discordMemberList,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member['displayName'] ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                isOnline ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: isOnline
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showChannelInfo() {
    final channel = _serverController.selectedChannel;
    if (channel == null) return;

    Get.dialog(
      Dialog(
        backgroundColor: discordChannelList,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Channel Info',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Channel Name:', channel.name),
              const SizedBox(height: 12),
              _buildInfoRow('Type:', channel.type),
              const SizedBox(height: 12),
              _buildInfoRow(
                  'Created:', channel.createdAt.toString().split(' ')[0]),
              if (channel.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Description:',
                  style: TextStyle(
                    color: discordBrand,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'channel description',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: discordBrand,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: discordChannelList,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.attach_file, color: Colors.white),
              title: const Text('Share File',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Get.snackbar('Info', 'File sharing coming soon!',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 1),
                    backgroundColor: discordBrand);
              },
            ),
            ListTile(
              leading: const Icon(Icons.task, color: Colors.white),
              title: const Text('Assign Task',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showCreateTaskDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_comment, color: Colors.white),
              title: const Text('Create Channel',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showCreateChannelDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 1));
    bool isPriority = false;
    String? selectedMemberId;

    Get.dialog(
      Dialog(
        backgroundColor: discordChannelList,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Task Title',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: discordChatArea,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: discordChatArea,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final members = _serverController.currentMembers;
                    if (members.isEmpty) {
                      return const Text(
                        'No members to assign to',
                        style: TextStyle(color: Colors.grey),
                      );
                    }
                    return DropdownButtonFormField<String>(
                      value: selectedMemberId ??
                          (members.isNotEmpty
                              ? members.first['id'] as String
                              : null),
                      items: members
                          .map<DropdownMenuItem<String>>((m) =>
                              DropdownMenuItem<String>(
                                value: m['id'] as String,
                                child: Text(m['displayName'] ?? 'Unknown',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMemberId = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Assign To',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: discordChatArea,
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Due Date: ${dueDate.toString().split(' ')[0]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dueDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => dueDate = picked);
                          }
                        },
                        child: const Text('Pick'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: isPriority,
                        onChanged: (value) {
                          setState(() => isPriority = value ?? false);
                        },
                      ),
                      const Text('High Priority',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isEmpty) {
                            Get.snackbar('Error', 'Please enter a task title');
                            return;
                          }

                          if (selectedMemberId == null) {
                            Get.snackbar('Error', 'Please assign a member');
                            return;
                          }

                          final assignedToName =
                              _serverController.currentMembers.firstWhereOrNull(
                                          (m) => m['id'] == selectedMemberId)?[
                                      'displayName'] ??
                                  'Unknown';

                          _serverController.createTask(
                            title: titleController.text,
                            description: descriptionController.text,
                            assignedToId: selectedMemberId ?? '',
                            assignedToName: assignedToName,
                            dueDate: dueDate,
                            isPriority: isPriority,
                          );

                          Get.back();
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateChannelDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: discordChannelList,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Channel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Channel Name',
                  hintText: 'e.g., announcements',
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: discordChatArea,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: discordChatArea,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        Get.snackbar('Error', 'Please enter a channel name');
                        return;
                      }

                      _serverController.createChannel(
                        serverId: _serverController.selectedServer?.id ?? '',
                        name: nameController.text,
                        description: descriptionController.text,
                      );

                      Get.back();
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Thread Methods ---

  void _openThreadPanel(ServerMessageModel message) {
    setState(() {
      _showThreadPanel = true;
    });

    // Create a thread based on this message if it doesn't exist
    _serverController.selectThread(
      ServerThreadModel(
        id: 'thread_${message.id}',
        serverId: message.serverId,
        channelId: message.channelId,
        messageId: message.id,
        title: message.content.length > 50
            ? '${message.content.substring(0, 50)}...'
            : message.content,
        starterName: message.senderName,
        starterId: message.senderId,
        createdAt: message.timestamp,
        replyCount: 0,
        lastReplyAt: message.timestamp,
      ),
    );
  }

  void _closeThreadPanel() {
    setState(() {
      _showThreadPanel = false;
    });
    _serverController.clearSelectedThread();
  }

  Widget _buildThreadPanel() {
    final thread = _serverController.selectedThread;

    if (thread == null) {
      return Container(
        color: discordChannelList,
        child: Center(
          child: Text(
            'Select a message to view threads',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      color: discordChannelList,
      child: Column(
        children: [
          // Thread Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thread',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        thread.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${thread.replyCount} replies',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[500]),
                  onPressed: _closeThreadPanel,
                  tooltip: 'Close thread',
                ),
              ],
            ),
          ),

          // Thread Replies List
          Expanded(
            child: Obx(() {
              final replies = _serverController.threadReplies;

              if (replies.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 48,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No replies yet',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  final reply = replies[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: discordBrand,
                          child: Text(
                            reply.senderName.isNotEmpty
                                ? reply.senderName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    reply.senderName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _serverController.formatMessageTime(
                                      reply.timestamp,
                                    ),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reply.content,
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),

          // Thread Reply Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Reply to thread...',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[700],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    minLines: 1,
                    maxLines: 3,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _serverController.sendThreadReply(content: value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: discordBrand,
                    size: 18,
                  ),
                  onPressed: () {
                    // TODO: Implement send with TextEditingController
                    _serverController.sendThreadReply(content: 'Reply message');
                  },
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
