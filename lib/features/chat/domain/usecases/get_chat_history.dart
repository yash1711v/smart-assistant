import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';
import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';

/// Use case that retrieves the full chat history from the remote API.
///
/// Delegates to [ChatRepository.getChatHistory] for data fetching.
class GetChatHistory {
  final ChatRepository _repository;

  /// Creates a [GetChatHistory] use case backed by the given [repository].
  GetChatHistory(this._repository);

  /// Fetches and returns the chronologically ordered chat history.
  ///
  /// Throws if the underlying repository encounters a network error.
  Future<List<ChatMessage>> call() {
    return _repository.getChatHistory();
  }
}
