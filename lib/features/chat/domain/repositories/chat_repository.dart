import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';

/// Contract for chat data operations.
///
/// Implementations must handle both remote API communication
/// and local Hive-based caching of chat messages.
abstract class ChatRepository {
  /// Sends a [message] to the assistant and returns the reply text.
  ///
  /// Throws on network or server errors.
  Future<String> sendMessage({required String message});

  /// Fetches the full chat history from the remote API.
  ///
  /// Returns a list of [ChatMessage] entities ordered chronologically.
  Future<List<ChatMessage>> getChatHistory();

  /// Retrieves locally cached chat messages from Hive storage.
  ///
  /// Returns an empty list when no local history exists.
  Future<List<ChatMessage>> getLocalChatHistory();

  /// Persists a single [message] to the local Hive cache.
  Future<void> saveMessageLocally(ChatMessage message);
}
