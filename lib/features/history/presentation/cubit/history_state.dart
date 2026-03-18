import 'package:equatable/equatable.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';

/// Base class for all states emitted by [HistoryCubit].
sealed class HistoryState extends Equatable {
  /// Creates a [HistoryState].
  const HistoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any history data has been requested.
class HistoryInitial extends HistoryState {
  /// Creates a [HistoryInitial] state.
  const HistoryInitial();
}

/// State emitted while history is being fetched.
class HistoryLoading extends HistoryState {
  /// Creates a [HistoryLoading] state.
  const HistoryLoading();
}

/// State emitted when chat history has been successfully loaded.
class HistoryLoaded extends HistoryState {
  /// The ordered list of past chat messages.
  final List<ChatMessage> messages;

  /// Creates a [HistoryLoaded] state with the given [messages].
  const HistoryLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

/// State emitted when fetching history fails.
class HistoryError extends HistoryState {
  /// Human-readable error message to display.
  final String message;

  /// Creates a [HistoryError] state with the given [message].
  const HistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}
