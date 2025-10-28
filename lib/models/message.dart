enum MessageStatus { sending, sent, delivered, read }

enum MessageType { text, emoji, voice }

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final MessageStatus status;
  final MessageType type;
  final List<String> reactions;
  final String? voicePath;
  final Duration? voiceDuration;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.status = MessageStatus.sending,
    this.type = MessageType.text,
    List<String>? reactions,
    this.voicePath,
    this.voiceDuration,
  }) : reactions = reactions ?? [];

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${json['status'] ?? 'sent'}',
        orElse: () => MessageStatus.sent,
      ),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type'] ?? 'text'}',
        orElse: () => MessageType.text,
      ),
      reactions: (json['reactions'] as List<dynamic>?)?.cast<String>() ?? [],
      voicePath: json['voicePath'],
      voiceDuration: json['voiceDuration'] != null
          ? Duration(milliseconds: json['voiceDuration'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'reactions': reactions,
      'voicePath': voicePath,
      'voiceDuration': voiceDuration?.inMilliseconds,
    };
  }
}
