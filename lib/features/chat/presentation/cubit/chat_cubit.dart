import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';
import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';
import 'package:smartassistant/features/chat/domain/usecases/get_chat_history.dart';
import 'package:smartassistant/features/chat/domain/usecases/send_message.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_state.dart';

/// Cubit managing the chat conversation state.
///
/// Coordinates between [SendMessage] and [GetChatHistory] use cases,
/// and uses [ChatRepository] directly for local persistence.
class ChatCubit extends Cubit<ChatState> {
  final SendMessage _sendMessage;
  final GetChatHistory _getChatHistory;
  final ChatRepository _repository;

  /// Creates a [ChatCubit] with the required use cases and repository.
  ChatCubit({
    required SendMessage sendMessage,
    required GetChatHistory getChatHistory,
    required ChatRepository repository,
  }) : _sendMessage = sendMessage,
       _getChatHistory = getChatHistory,
       _repository = repository,
       super(const ChatInitial());

  /// Loads chat history, showing cached messages first then syncing remote.
  ///
  /// Emits [ChatLoaded] with local data immediately, then updates with
  /// remote data when available. Falls back to local data on remote failure.
  Future<void> loadChat() async {
    try {
      final localMessages = await _repository.getLocalChatHistory();
      emit(ChatLoaded(messages: localMessages));
    } catch (_) {
      emit(const ChatLoaded(messages: []));
    }

    try {
      final remoteMessages = await _getChatHistory();
      emit(ChatLoaded(messages: remoteMessages));
    } catch (_) {
      // Keep whatever state we already emitted from local cache.
    }
  }

  /// Sends a user [message] and appends both it and the reply to the list.
  ///
  /// Optimistically adds the user message, sets [ChatLoaded.isSending]
  /// to `true`, waits for the API reply, then appends the assistant
  /// response and persists both messages locally.
  Future<void> sendMessage(String message) async {
    final currentMessages = _currentMessages;

    final userMessage = ChatMessage(
      sender: 'user',
      message: message,
      timestamp: DateTime.now(),
    );

    emit(
      ChatLoaded(messages: [...currentMessages, userMessage], isSending: true),
    );

    try {
      final reply = await _sendMessage(message: message);

      final assistantMessage = ChatMessage(
        sender: 'assistant',
        message: reply,
        timestamp: DateTime.now(),
      );

      emit(
        ChatLoaded(
          messages: [...currentMessages, userMessage, assistantMessage],
        ),
      );
    } catch (_) {
      emit(ChatLoaded(messages: [...currentMessages, userMessage]));
    }
  }

  /// Extracts the current message list from state, defaulting to empty.
  List<ChatMessage> get _currentMessages {
    final current = state;
    if (current is ChatLoaded) {
      return current.messages;
    }
    return [];
  }
}
