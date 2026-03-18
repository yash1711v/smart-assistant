import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';

/// Use case that sends a user message and returns the assistant's reply.
///
/// Delegates to [ChatRepository.sendMessage] to perform the API call.
class SendMessage {
  final ChatRepository _repository;

  /// Creates a [SendMessage] use case backed by the given [repository].
  SendMessage(this._repository);

  /// Sends the [message] and returns the assistant's reply string.
  ///
  /// Throws if the underlying repository encounters a network error.
  Future<String> call({required String message}) {
    return _repository.sendMessage(message: message);
  }
}
