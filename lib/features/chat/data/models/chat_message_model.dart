import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';


class ChatMessageModel extends ChatMessage {

  const ChatMessageModel({
    required super.sender,
    required super.message,
    super.timestamp,
  });


  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      sender: json['sender'] as String,
      message: json['message'] as String,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
    };
  }


  factory ChatMessageModel.fromHiveMap(Map<dynamic, dynamic> map) {
    return ChatMessageModel(
      sender: map['sender'] as String,
      message: map['message'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }


  Map<String, dynamic> toHiveMap() {
    return {
      'sender': sender,
      'message': message,
      'timestamp':
          (timestamp ?? DateTime.now()).millisecondsSinceEpoch,
    };
  }


  factory ChatMessageModel.fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      sender: entity.sender,
      message: entity.message,
      timestamp: entity.timestamp,
    );
  }
}
