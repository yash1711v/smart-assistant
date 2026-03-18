import 'package:flutter_test/flutter_test.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';
import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';
import 'package:smartassistant/features/chat/domain/usecases/get_chat_history.dart';
import 'package:smartassistant/features/chat/domain/usecases/send_message.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:smartassistant/features/chat/presentation/cubit/chat_state.dart';

void main() {
  group('ChatCubit', () {
    test(
      'loadChat emits local history first and then remote history',
      () async {
        final repository = _FakeChatRepository(
          localMessages: [
            ChatMessage(
              sender: 'user',
              message: 'Local',
              timestamp: DateTime(2024, 1, 1, 9),
            ),
          ],
          remoteMessages: [
            ChatMessage(
              sender: 'assistant',
              message: 'Remote',
              timestamp: DateTime(2024, 1, 1, 10),
            ),
          ],
        );
        final cubit = ChatCubit(
          sendMessage: SendMessage(repository),
          getChatHistory: GetChatHistory(repository),
          repository: repository,
        );
        final emittedStates = <ChatState>[];
        final subscription = cubit.stream.listen(emittedStates.add);

        await cubit.loadChat();
        await Future<void>.delayed(Duration.zero);

        expect(emittedStates, [
          ChatLoaded(messages: repository.localMessages),
          ChatLoaded(messages: repository.remoteMessages),
        ]);

        await subscription.cancel();
        await cubit.close();
      },
    );

    test(
      'sendMessage does not write duplicate local cache entries on success',
      () async {
        final repository = _FakeChatRepository(sendReply: 'Hello from API');
        final cubit = ChatCubit(
          sendMessage: SendMessage(repository),
          getChatHistory: GetChatHistory(repository),
          repository: repository,
        );
        final emittedStates = <ChatState>[];
        final subscription = cubit.stream.listen(emittedStates.add);

        await cubit.sendMessage('Hello');
        await Future<void>.delayed(Duration.zero);

        expect(repository.saveMessageLocallyCalls, 0);
        expect(emittedStates.length, 2);

        final sendingState = emittedStates.first as ChatLoaded;
        expect(sendingState.isSending, isTrue);
        expect(sendingState.messages.single.message, 'Hello');

        final loadedState = emittedStates.last as ChatLoaded;
        expect(loadedState.isSending, isFalse);
        expect(loadedState.messages.length, 2);
        expect(loadedState.messages.first.sender, 'user');
        expect(loadedState.messages.first.message, 'Hello');
        expect(loadedState.messages.last.sender, 'assistant');
        expect(loadedState.messages.last.message, 'Hello from API');

        await subscription.cancel();
        await cubit.close();
      },
    );
  });
}

class _FakeChatRepository implements ChatRepository {
  _FakeChatRepository({
    this.localMessages = const [],
    this.remoteMessages = const [],
    this.sendReply = 'ok',
  });

  final List<ChatMessage> localMessages;
  final List<ChatMessage> remoteMessages;
  final String sendReply;
  int saveMessageLocallyCalls = 0;

  @override
  Future<List<ChatMessage>> getChatHistory() async => remoteMessages;

  @override
  Future<List<ChatMessage>> getLocalChatHistory() async => localMessages;

  @override
  Future<void> saveMessageLocally(ChatMessage message) async {
    saveMessageLocallyCalls += 1;
  }

  @override
  Future<String> sendMessage({required String message}) async => sendReply;
}
