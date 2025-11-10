import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkzy_beta1/models/server_model.dart';

class ServerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- Server Collection Operations ---

  Future<String> createServer(ServerModel server) async {
    try {
      print('🔥 Firestore: Creating server ${server.name}');

      DocumentReference docRef = await _firestore
          .collection('servers')
          .add(server.copyWith(id: '').toMap());

      // Update the document with its ID
      await docRef.update({'id': docRef.id});

      print('✅ Firestore: Server created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Firestore Error: ${e.toString()}');
      throw Exception('Failed to create server: ${e.toString()}');
    }
  }

  Future<ServerModel?> getServer(String serverId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('servers').doc(serverId).get();
      if (doc.exists) {
        return ServerModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get server: ${e.toString()}');
    }
  }

  Future<void> updateServer(String serverId, ServerModel server) async {
    try {
      await _firestore
          .collection('servers')
          .doc(serverId)
          .update(server.toMap());
      print('✅ Server updated: $serverId');
    } catch (e) {
      throw Exception('Failed to update server: ${e.toString()}');
    }
  }

  Future<void> deleteServer(String serverId) async {
    try {
      // Delete all messages in all channels
      final channelsSnapshot = await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .get();

      for (var channel in channelsSnapshot.docs) {
        final messagesSnapshot =
            await channel.reference.collection('messages').get();

        for (var message in messagesSnapshot.docs) {
          await message.reference.delete();
        }
        await channel.reference.delete();
      }

      // Delete the server
      await _firestore.collection('servers').doc(serverId).delete();
      print('✅ Server deleted: $serverId');
    } catch (e) {
      throw Exception('Failed to delete server: ${e.toString()}');
    }
  }

  Stream<ServerModel?> getServerStream(String serverId) {
    return _firestore
        .collection('servers')
        .doc(serverId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return ServerModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  Stream<List<ServerModel>> getUserServersStream(String userId) {
    return _firestore
        .collection('servers')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServerModel.fromMap(doc.data()))
          .toList();
    });
  }

  Stream<List<ServerModel>> getPublicServersStream() {
    return _firestore
        .collection('servers')
        .where('isPublic', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServerModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> joinServer(
      String serverId, String userId, String userName) async {
    try {
      final serverRef = _firestore.collection('servers').doc(serverId);

      await serverRef.update({
        'members': FieldValue.arrayUnion([userId]),
        'memberCount': FieldValue.increment(1),
      });

      print('✅ User $userId joined server $serverId');
    } catch (e) {
      throw Exception('Failed to join server: ${e.toString()}');
    }
  }

  Future<void> leaveServer(String serverId, String userId) async {
    try {
      final serverRef = _firestore.collection('servers').doc(serverId);

      await serverRef.update({
        'members': FieldValue.arrayRemove([userId]),
        'memberCount': FieldValue.increment(-1),
      });

      print('✅ User $userId left server $serverId');
    } catch (e) {
      throw Exception('Failed to leave server: ${e.toString()}');
    }
  }

  // --- Channel Operations ---

  Future<String> createChannel(
    String serverId,
    ServerChannelModel channel,
  ) async {
    try {
      print(
          '🔥 Firestore: Creating channel ${channel.name} in server $serverId');

      DocumentReference docRef = await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .add(channel.copyWith(id: '').toMap());

      // Update the document with its ID
      await docRef.update({'id': docRef.id});

      // Add channel ID to server's channels list
      await _firestore.collection('servers').doc(serverId).update({
        'channels': FieldValue.arrayUnion([docRef.id]),
      });

      print('✅ Channel created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Firestore Error: ${e.toString()}');
      throw Exception('Failed to create channel: ${e.toString()}');
    }
  }

  Future<List<ServerChannelModel>> getServerChannels(String serverId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .orderBy('order', descending: false)
          .get();

      return snapshot.docs
          .map((doc) =>
              ServerChannelModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get channels: ${e.toString()}');
    }
  }

  Stream<List<ServerChannelModel>> getServerChannelsStream(String serverId) {
    return _firestore
        .collection('servers')
        .doc(serverId)
        .collection('channels')
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServerChannelModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> deleteChannel(String serverId, String channelId) async {
    try {
      // Delete all messages in the channel
      final messagesSnapshot = await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .get();

      for (var message in messagesSnapshot.docs) {
        await message.reference.delete();
      }

      // Delete the channel
      await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .delete();

      // Remove channel ID from server's channels list
      await _firestore.collection('servers').doc(serverId).update({
        'channels': FieldValue.arrayRemove([channelId]),
      });

      print('✅ Channel deleted: $channelId');
    } catch (e) {
      throw Exception('Failed to delete channel: ${e.toString()}');
    }
  }

  // --- Server Message Operations ---

  Future<String> sendServerMessage(
    String serverId,
    String channelId,
    ServerMessageModel message,
  ) async {
    try {
      print(
          '🔥 Firestore: Sending message to server $serverId, channel $channelId');

      DocumentReference docRef = await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .add(message.copyWith(id: '').toMap());

      // Update the document with its ID
      await docRef.update({'id': docRef.id});

      print('✅ Message sent with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Firestore Error: ${e.toString()}');
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }

  Stream<List<ServerMessageModel>> getChannelMessagesStream(
    String serverId,
    String channelId,
  ) {
    return _firestore
        .collection('servers')
        .doc(serverId)
        .collection('channels')
        .doc(channelId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServerMessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> editServerMessage(
    String serverId,
    String channelId,
    String messageId,
    String newContent,
  ) async {
    try {
      await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .doc(messageId)
          .update({
        'content': newContent,
        'isEdited': true,
        'editedAt': Timestamp.fromDate(DateTime.now()),
      });

      print('✅ Message edited: $messageId');
    } catch (e) {
      throw Exception('Failed to edit message: ${e.toString()}');
    }
  }

  Future<void> deleteServerMessage(
    String serverId,
    String channelId,
    String messageId,
  ) async {
    try {
      await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('messages')
          .doc(messageId)
          .delete();

      print('✅ Message deleted: $messageId');
    } catch (e) {
      throw Exception('Failed to delete message: ${e.toString()}');
    }
  }

  // --- Server Task Operations ---

  Future<String> createServerTask(
    String serverId,
    String channelId,
    ServerTaskModel task,
  ) async {
    try {
      print(
          '🔥 Firestore: Creating task in server $serverId, channel $channelId');

      DocumentReference docRef = await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('tasks')
          .add(task.copyWith(id: '').toMap());

      // Update the document with its ID
      await docRef.update({'id': docRef.id});

      print('✅ Task created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Firestore Error: ${e.toString()}');
      throw Exception('Failed to create task: ${e.toString()}');
    }
  }

  Stream<List<ServerTaskModel>> getChannelTasksStream(
    String serverId,
    String channelId,
  ) {
    return _firestore
        .collection('servers')
        .doc(serverId)
        .collection('channels')
        .doc(channelId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ServerTaskModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> updateServerTask(
    String serverId,
    String channelId,
    String taskId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('tasks')
          .doc(taskId)
          .update(updates);

      print('✅ Task updated: $taskId');
    } catch (e) {
      throw Exception('Failed to update task: ${e.toString()}');
    }
  }

  Future<void> deleteServerTask(
    String serverId,
    String channelId,
    String taskId,
  ) async {
    try {
      await _firestore
          .collection('servers')
          .doc(serverId)
          .collection('channels')
          .doc(channelId)
          .collection('tasks')
          .doc(taskId)
          .delete();

      print('✅ Task deleted: $taskId');
    } catch (e) {
      throw Exception('Failed to delete task: ${e.toString()}');
    }
  }

  // --- Search Operations ---

  Future<List<ServerModel>> searchServers(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('servers')
          .where('isPublic', isEqualTo: true)
          .get();

      final allServers = snapshot.docs
          .map((doc) => ServerModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      // Client-side filtering for name and description
      return allServers
          .where((server) =>
              server.name.toLowerCase().contains(query.toLowerCase()) ||
              server.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search servers: ${e.toString()}');
    }
  }

  // --- Get all user members in a server ---
  Future<List<Map<String, dynamic>>> getServerMembers(String serverId) async {
    try {
      DocumentSnapshot serverDoc =
          await _firestore.collection('servers').doc(serverId).get();

      if (!serverDoc.exists) {
        return [];
      }

      List<String> memberIds =
          List<String>.from(serverDoc.get('members') ?? []);

      List<Map<String, dynamic>> members = [];

      for (String memberId in memberIds) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(memberId).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          userData['id'] = memberId;
          members.add(userData);
        }
      }

      return members;
    } catch (e) {
      throw Exception('Failed to get server members: ${e.toString()}');
    }
  }

  Stream<List<Map<String, dynamic>>> getServerMembersStream(String serverId) {
    return _firestore
        .collection('servers')
        .doc(serverId)
        .snapshots()
        .asyncExpand((serverDoc) async* {
      if (!serverDoc.exists) {
        yield [];
        return;
      }

      List<String> memberIds =
          List<String>.from(serverDoc.get('members') ?? []);

      List<Future<DocumentSnapshot>> futures = memberIds
          .map((id) => _firestore.collection('users').doc(id).get())
          .toList();

      List<DocumentSnapshot> userDocs = await Future.wait(futures);

      List<Map<String, dynamic>> members = [];
      for (int i = 0; i < userDocs.length; i++) {
        if (userDocs[i].exists) {
          Map<String, dynamic> userData =
              userDocs[i].data() as Map<String, dynamic>;
          userData['id'] = memberIds[i];
          members.add(userData);
        }
      }

      yield members;
    });
  }
}

extension ServerChannelModelExt on ServerChannelModel {
  ServerChannelModel copyWith({
    String? id,
    String? serverId,
    String? name,
    String? description,
    String? type,
    int? order,
    DateTime? createdAt,
  }) {
    return ServerChannelModel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
