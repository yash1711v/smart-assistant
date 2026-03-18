import 'package:hive/hive.dart';
import 'package:smartassistant/core/constants/app_constants.dart';
import 'package:smartassistant/core/error/exceptions.dart';
import 'package:smartassistant/features/chat/data/models/chat_message_model.dart';

class ChatLocalDataSource {
  Future<List<ChatMessageModel>> getMessages() async {
    try {
      final box = Hive.box(AppConstants.hiveChatBox);
      final messages = box.values
          .map(
            (item) =>
                ChatMessageModel.fromHiveMap(item as Map<dynamic, dynamic>),
          )
          .toList();
      messages.sort(_compareMessages);
      return messages;
    } catch (e) {
      throw CacheException(message: 'Failed to read local chat history: $e');
    }
  }

  Future<void> saveMessage(ChatMessageModel message) async {
    try {
      final box = Hive.box(AppConstants.hiveChatBox);
      await box.add(message.toHiveMap());
    } catch (e) {
      throw CacheException(message: 'Failed to save message locally: $e');
    }
  }

  Future<void> replaceMessages(List<ChatMessageModel> messages) async {
    try {
      final box = Hive.box(AppConstants.hiveChatBox);
      await box.clear();
      for (final message in messages) {
        await box.add(message.toHiveMap());
      }
    } catch (e) {
      throw CacheException(message: 'Failed to sync local chat history: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      final box = Hive.box(AppConstants.hiveChatBox);
      await box.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear local chat history: $e');
    }
  }

  int _compareMessages(ChatMessageModel first, ChatMessageModel second) {
    final firstTime = first.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
    final secondTime =
        second.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
    return firstTime.compareTo(secondTime);
  }
}
