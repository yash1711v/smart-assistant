import 'package:smartassistant/core/constants/api_constants.dart';
import 'package:smartassistant/core/error/exceptions.dart';
import 'package:smartassistant/core/network/dio_client.dart';
import 'package:smartassistant/features/chat/data/models/chat_message_model.dart';


class ChatRemoteDataSource {
  final DioClient _dioClient;


  ChatRemoteDataSource(this._dioClient);


  Future<String> sendMessage({required String message}) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.chat,
        data: {'message': message},
      );
      final body = response.data as Map<String, dynamic>;
      return body['reply'] as String;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to send message: $e');
    }
  }

  /// Fetches the full chat history from the remote API.
  ///
  /// GET request to [ApiConstants.chatHistory].
  /// Throws [ServerException] if the request fails or response is malformed.
  Future<List<ChatMessageModel>> getChatHistory() async {
    try {
      final response = await _dioClient.get(ApiConstants.chatHistory);
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>;
      return data
          .map((item) =>
              ChatMessageModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch chat history: $e');
    }
  }
}
