import 'package:equatable/equatable.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';

/// Base class for all chat-related states.
sealed class ChatState extends Equatable {
  /// Creates a [ChatState].
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any chat data has been loaded.
class ChatInitial extends ChatState {
  /// Creates a [ChatInitial] state.
  const ChatInitial();
}

/// State emitted once chat messages are available.
///
/// [messages] contains the current conversation in chronological order.
/// [isSending] indicates whether a message is currently being sent.
class ChatLoaded extends ChatState {
  /// The ordered list of chat messages in the conversation.
  final List<ChatMessage> messages;

  /// Whether a message is currently being sent to the API.
  final bool isSending;

  /// Creates a [ChatLoaded] state with the given [messages] list
  /// and optional [isSending] flag (defaults to `false`).
  const ChatLoaded({
    required this.messages,
    this.isSending = false,
  });

  /// Returns a copy of this state with optionally overridden fields.
  ChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
  }) {
    return ChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, isSending];
}
