import 'package:flutter_test/flutter_test.dart';
import 'package:smartassistant/core/network/dio_client.dart';
import 'package:smartassistant/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:smartassistant/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:smartassistant/features/chat/data/models/chat_message_model.dart';
import 'package:smartassistant/features/chat/data/repositories/chat_repository_impl.dart';

void main() {
  group('ChatRepositoryImpl', () {
    test('getChatHistory syncs remote messages into local cache', () async {
      final remoteMessages = [
        ChatMessageModel(
          sender: 'assistant',
          message: 'Welcome back',
          timestamp: DateTime(2024, 1, 1, 10),
        ),
      ];
      final local = _FakeChatLocalDataSource();
      final repository = ChatRepositoryImpl(
        _FakeChatRemoteDataSource(history: remoteMessages),
        local,
      );

      final result = await repository.getChatHistory();

      expect(result, remoteMessages);
      expect(local.replaceCalls, 1);
      expect(local.messages, remoteMessages);
    });

    test(
      'sendMessage stores the user message and assistant reply once',
      () async {
        final local = _FakeChatLocalDataSource();
        final repository = ChatRepositoryImpl(
          _FakeChatRemoteDataSource(reply: 'Hi there'),
          local,
        );

        final reply = await repository.sendMessage(message: 'Hello');

        expect(reply, 'Hi there');
        expect(local.savedMessages.length, 2);
        expect(local.savedMessages.first.sender, 'user');
        expect(local.savedMessages.first.message, 'Hello');
        expect(local.savedMessages.last.sender, 'assistant');
        expect(local.savedMessages.last.message, 'Hi there');
      },
    );
  });
}

class _FakeChatRemoteDataSource extends ChatRemoteDataSource {
  _FakeChatRemoteDataSource({this.reply = 'ok', this.history = const []})
    : super(DioClient());

  final String reply;
  final List<ChatMessageModel> history;

  @override
  Future<String> sendMessage({required String message}) async => reply;

  @override
  Future<List<ChatMessageModel>> getChatHistory() async => history;
}

class _FakeChatLocalDataSource extends ChatLocalDataSource {
  final List<ChatMessageModel> messages = [];
  final List<ChatMessageModel> savedMessages = [];
  int replaceCalls = 0;

  @override
  Future<List<ChatMessageModel>> getMessages() async => List.of(messages);

  @override
  Future<void> saveMessage(ChatMessageModel message) async {
    savedMessages.add(message);
    messages.add(message);
  }

  @override
  Future<void> replaceMessages(List<ChatMessageModel> newMessages) async {
    replaceCalls += 1;
    messages
      ..clear()
      ..addAll(newMessages);
  }
}
