import 'package:equatable/equatable.dart';

/// Domain entity representing a single chat message in a conversation.
///
/// Each message has a [sender] indicating its origin ("user" or "assistant"),
/// the [message] text content, and an optional [timestamp] for ordering.
class ChatMessage extends Equatable {
  /// Who sent the message — either `"user"` or `"assistant"`.
  final String sender;

  /// The text content of the message.
  final String message;

  /// When the message was created. Defaults to [DateTime.now] if omitted.
  final DateTime? timestamp;

  /// Creates a [ChatMessage] with the required [sender] and [message],
  /// and an optional [timestamp].
  const ChatMessage({
    required this.sender,
    required this.message,
    this.timestamp,
  });

  @override
  List<Object?> get props => [sender, message, timestamp];
}
