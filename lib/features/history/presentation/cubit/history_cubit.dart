import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';
import 'package:smartassistant/features/history/presentation/cubit/history_state.dart';

/// Cubit managing the chat history screen state.
///
/// Loads messages from both local cache and remote API,
/// prioritizing local data for instant display.
class HistoryCubit extends Cubit<HistoryState> {
  final ChatRepository _repository;

  /// Creates a [HistoryCubit] with the given [repository].
  HistoryCubit({required ChatRepository repository})
      : _repository = repository,
        super(const HistoryInitial());

  /// Loads chat history from local cache first, then syncs with remote.
  ///
  /// Emits [HistoryLoading] initially, then [HistoryLoaded] with local data,
  /// and updates with remote data when available.
  Future<void> loadHistory() async {
    emit(const HistoryLoading());

    try {
      final localMessages = await _repository.getLocalChatHistory();
      if (localMessages.isNotEmpty) {
        emit(HistoryLoaded(messages: localMessages));
      }

      final remoteMessages = await _repository.getChatHistory();
      emit(HistoryLoaded(messages: remoteMessages));
    } catch (e) {
      final current = state;
      if (current is HistoryLoaded) return;
      emit(HistoryError(message: e.toString()));
    }
  }
}
