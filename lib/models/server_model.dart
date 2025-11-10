import 'package:cloud_firestore/cloud_firestore.dart';

class ServerModel {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String? icon;
  final String? banner;
  final bool isPublic;
  final List<String> members;
  final List<String> channels;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int memberCount;
  final Map<String, dynamic>? settings;

  ServerModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.ownerId,
    this.icon,
    this.banner,
    this.isPublic = true,
    this.members = const [],
    this.channels = const [],
    required this.createdAt,
    required this.updatedAt,
    this.memberCount = 0,
    this.settings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'icon': icon,
      'banner': banner,
      'isPublic': isPublic,
      'members': members,
      'channels': channels,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'memberCount': memberCount,
      'settings': settings ?? {},
    };
  }

  static ServerModel fromMap(Map<String, dynamic> map) {
    return ServerModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ownerId: map['ownerId'] ?? '',
      icon: map['icon'],
      banner: map['banner'],
      isPublic: map['isPublic'] ?? true,
      members: map['members'] != null ? List<String>.from(map['members']) : [],
      channels:
          map['channels'] != null ? List<String>.from(map['channels']) : [],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
      memberCount: map['memberCount'] ?? 0,
      settings: map['settings'] as Map<String, dynamic>?,
    );
  }

  ServerModel copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    String? icon,
    String? banner,
    bool? isPublic,
    List<String>? members,
    List<String>? channels,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? memberCount,
    Map<String, dynamic>? settings,
  }) {
    return ServerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      icon: icon ?? this.icon,
      banner: banner ?? this.banner,
      isPublic: isPublic ?? this.isPublic,
      members: members ?? this.members,
      channels: channels ?? this.channels,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      memberCount: memberCount ?? this.memberCount,
      settings: settings ?? this.settings,
    );
  }
}

class ServerMessageModel {
  final String id;
  final String serverId;
  final String channelId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isEdited;
  final DateTime? editedAt;
  final List<String> reactions;

  ServerMessageModel({
    required this.id,
    required this.serverId,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.isEdited = false,
    this.editedAt,
    this.reactions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverId': serverId,
      'channelId': channelId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isEdited': isEdited,
      'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
      'reactions': reactions,
    };
  }

  static ServerMessageModel fromMap(Map<String, dynamic> map) {
    return ServerMessageModel(
      id: map['id'] ?? '',
      serverId: map['serverId'] ?? '',
      channelId: map['channelId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      isEdited: map['isEdited'] ?? false,
      editedAt: map['editedAt'] is Timestamp
          ? (map['editedAt'] as Timestamp).toDate()
          : null,
      reactions:
          map['reactions'] != null ? List<String>.from(map['reactions']) : [],
    );
  }

  ServerMessageModel copyWith({
    String? id,
    String? serverId,
    String? channelId,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    bool? isEdited,
    DateTime? editedAt,
    List<String>? reactions,
  }) {
    return ServerMessageModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      reactions: reactions ?? this.reactions,
    );
  }
}

class ServerChannelModel {
  final String id;
  final String serverId;
  final String name;
  final String description;
  final String type; // 'text', 'voice', etc.
  final int order;
  final DateTime createdAt;

  ServerChannelModel({
    required this.id,
    required this.serverId,
    required this.name,
    this.description = '',
    this.type = 'text',
    this.order = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverId': serverId,
      'name': name,
      'description': description,
      'type': type,
      'order': order,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static ServerChannelModel fromMap(Map<String, dynamic> map) {
    return ServerChannelModel(
      id: map['id'] ?? '',
      serverId: map['serverId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'text',
      order: map['order'] ?? 0,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

class ServerThreadModel {
  final String id;
  final String serverId;
  final String channelId;
  final String messageId;
  final String title;
  final String starterName;
  final String starterId;
  final DateTime createdAt;
  final int replyCount;
  final DateTime lastReplyAt;

  ServerThreadModel({
    required this.id,
    required this.serverId,
    required this.channelId,
    required this.messageId,
    required this.title,
    required this.starterName,
    required this.starterId,
    required this.createdAt,
    this.replyCount = 0,
    required this.lastReplyAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverId': serverId,
      'channelId': channelId,
      'messageId': messageId,
      'title': title,
      'starterName': starterName,
      'starterId': starterId,
      'createdAt': Timestamp.fromDate(createdAt),
      'replyCount': replyCount,
      'lastReplyAt': Timestamp.fromDate(lastReplyAt),
    };
  }

  static ServerThreadModel fromMap(Map<String, dynamic> map) {
    return ServerThreadModel(
      id: map['id'] ?? '',
      serverId: map['serverId'] ?? '',
      channelId: map['channelId'] ?? '',
      messageId: map['messageId'] ?? '',
      title: map['title'] ?? '',
      starterName: map['starterName'] ?? '',
      starterId: map['starterId'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      replyCount: map['replyCount'] ?? 0,
      lastReplyAt: map['lastReplyAt'] is Timestamp
          ? (map['lastReplyAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  ServerThreadModel copyWith({
    String? id,
    String? serverId,
    String? channelId,
    String? messageId,
    String? title,
    String? starterName,
    String? starterId,
    DateTime? createdAt,
    int? replyCount,
    DateTime? lastReplyAt,
  }) {
    return ServerThreadModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      channelId: channelId ?? this.channelId,
      messageId: messageId ?? this.messageId,
      title: title ?? this.title,
      starterName: starterName ?? this.starterName,
      starterId: starterId ?? this.starterId,
      createdAt: createdAt ?? this.createdAt,
      replyCount: replyCount ?? this.replyCount,
      lastReplyAt: lastReplyAt ?? this.lastReplyAt,
    );
  }
}

class ServerThreadReplyModel {
  final String id;
  final String threadId;
  final String serverId;
  final String channelId;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isEdited;
  final DateTime? editedAt;

  ServerThreadReplyModel({
    required this.id,
    required this.threadId,
    required this.serverId,
    required this.channelId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.isEdited = false,
    this.editedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'threadId': threadId,
      'serverId': serverId,
      'channelId': channelId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'isEdited': isEdited,
      'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
    };
  }

  static ServerThreadReplyModel fromMap(Map<String, dynamic> map) {
    return ServerThreadReplyModel(
      id: map['id'] ?? '',
      threadId: map['threadId'] ?? '',
      serverId: map['serverId'] ?? '',
      channelId: map['channelId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      content: map['content'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      isEdited: map['isEdited'] ?? false,
      editedAt: map['editedAt'] is Timestamp
          ? (map['editedAt'] as Timestamp).toDate()
          : null,
    );
  }

  ServerThreadReplyModel copyWith({
    String? id,
    String? threadId,
    String? serverId,
    String? channelId,
    String? senderId,
    String? senderName,
    String? content,
    DateTime? timestamp,
    bool? isEdited,
    DateTime? editedAt,
  }) {
    return ServerThreadReplyModel(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      serverId: serverId ?? this.serverId,
      channelId: channelId ?? this.channelId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}

class ServerTaskModel {
  final String id;
  final String serverId;
  final String channelId;
  final String title;
  final String description;
  final String assignedToId;
  final String assignedToName;
  final String assignedById;
  final String assignedByName;
  final DateTime dueDate;
  final bool isPriority;
  final String status; // 'pending', 'in-progress', 'completed'
  final DateTime createdAt;

  ServerTaskModel({
    required this.id,
    required this.serverId,
    required this.channelId,
    required this.title,
    this.description = '',
    required this.assignedToId,
    required this.assignedToName,
    required this.assignedById,
    required this.assignedByName,
    required this.dueDate,
    this.isPriority = false,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serverId': serverId,
      'channelId': channelId,
      'title': title,
      'description': description,
      'assignedToId': assignedToId,
      'assignedToName': assignedToName,
      'assignedById': assignedById,
      'assignedByName': assignedByName,
      'dueDate': Timestamp.fromDate(dueDate),
      'isPriority': isPriority,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static ServerTaskModel fromMap(Map<String, dynamic> map) {
    return ServerTaskModel(
      id: map['id'] ?? '',
      serverId: map['serverId'] ?? '',
      channelId: map['channelId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assignedToId: map['assignedToId'] ?? '',
      assignedToName: map['assignedToName'] ?? '',
      assignedById: map['assignedById'] ?? '',
      assignedByName: map['assignedByName'] ?? '',
      dueDate: map['dueDate'] is Timestamp
          ? (map['dueDate'] as Timestamp).toDate()
          : DateTime.now(),
      isPriority: map['isPriority'] ?? false,
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  ServerTaskModel copyWith({
    String? id,
    String? serverId,
    String? channelId,
    String? title,
    String? description,
    String? assignedToId,
    String? assignedToName,
    String? assignedById,
    String? assignedByName,
    DateTime? dueDate,
    bool? isPriority,
    String? status,
    DateTime? createdAt,
  }) {
    return ServerTaskModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      description: description ?? this.description,
      assignedToId: assignedToId ?? this.assignedToId,
      assignedToName: assignedToName ?? this.assignedToName,
      assignedById: assignedById ?? this.assignedById,
      assignedByName: assignedByName ?? this.assignedByName,
      dueDate: dueDate ?? this.dueDate,
      isPriority: isPriority ?? this.isPriority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
