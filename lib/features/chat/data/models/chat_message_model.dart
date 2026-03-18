import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.sender,
    required super.message,
    super.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final message = _readString(json, const [
      'message',
      'content',
      'text',
      'reply',
    ]);
    final sender = _readString(json, const ['sender', 'role']) ?? 'assistant';

    return ChatMessageModel(
      sender: sender,
      message: message ?? '',
      timestamp: _parseTimestamp(
        json['timestamp'] ?? json['createdAt'] ?? json['created_at'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
    };
  }

  factory ChatMessageModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return ChatMessageModel(
      sender: map['sender'] as String,
      message: map['message'] as String,
      timestamp: _parseTimestamp(map['timestamp']),
    );
  }

  Map<String, dynamic> toHiveMap() {
    return {
      'sender': sender,
      'message': message,
      'timestamp': (timestamp ?? DateTime.now()).millisecondsSinceEpoch,
    };
  }

  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      sender: entity.sender,
      message: entity.message,
      timestamp: entity.timestamp,
    );
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }
}
