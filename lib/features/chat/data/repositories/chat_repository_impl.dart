import 'package:smartassistant/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:smartassistant/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:smartassistant/features/chat/data/models/chat_message_model.dart';
import 'package:smartassistant/features/chat/domain/entities/chat_message.dart';
import 'package:smartassistant/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;

  ChatRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<String> sendMessage({required String message}) async {
    final reply = await _remoteDataSource.sendMessage(message: message);

    final userModel = ChatMessageModel(
      sender: 'user',
      message: message,
      timestamp: DateTime.now(),
    );
    final assistantModel = ChatMessageModel(
      sender: 'assistant',
      message: reply,
      timestamp: DateTime.now(),
    );

    await _localDataSource.saveMessage(userModel);
    await _localDataSource.saveMessage(assistantModel);

    return reply;
  }


  @override
  Future<List<ChatMessage>> getChatHistory() async {
    final models = await _remoteDataSource.getChatHistory();
    return models;
  }


  @override
  Future<List<ChatMessage>> getLocalChatHistory() async {
    final models = await _localDataSource.getMessages();
    return models;
  }


  @override
  Future<void> saveMessageLocally(ChatMessage message) async {
    final model = ChatMessageModel.fromEntity(message);
    await _localDataSource.saveMessage(model);
  }
}
