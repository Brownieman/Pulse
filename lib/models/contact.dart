import 'message.dart';

class Contact {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String status;
  final String avatarUrl;
  final DateTime lastSeen;
  final List<Message> messages;
  final int unreadCount;
  final List<String> platforms;

  Contact({
    String? id,
    required this.name,
    required this.phone,
    required this.email,
    this.status = 'offline',
    this.avatarUrl = 'assets/images/contact.png',
    DateTime? lastSeen,
    List<Message>? messages,
    this.unreadCount = 0,
    List<String>? platforms,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        lastSeen = lastSeen ?? DateTime.now(),
        messages = messages ?? [],
        platforms = platforms ?? ['whatsapp'];

  String get lastMessage => messages.isNotEmpty ? messages.last.text : '';

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? 'offline',
      avatarUrl: json['avatarUrl'] as String? ?? 'assets/images/contact.png',
      lastSeen:
          json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => Message.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      unreadCount: json['unreadCount'] as int? ?? 0,
      platforms: (json['platforms'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'status': status,
      'avatarUrl': avatarUrl,
      'lastSeen': lastSeen.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'unreadCount': unreadCount,
      'platforms': platforms,
    };
  }
}
