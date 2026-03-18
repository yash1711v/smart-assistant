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
      return _extractReply(response.data);
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
      final data = _extractHistoryItems(response.data);
      final messages = data
          .map(
            (item) => ChatMessageModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      messages.sort((first, second) {
        final firstTime =
            first.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
        final secondTime =
            second.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);
        return firstTime.compareTo(secondTime);
      });
      return messages;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch chat history: $e');
    }
  }

  String _extractReply(dynamic body) {
    if (body is String && body.trim().isNotEmpty) {
      return body.trim();
    }

    if (body is! Map<String, dynamic>) {
      throw const ServerException(message: 'Unexpected chat response format');
    }

    final directReply = _firstNonEmptyString(body, const [
      'reply',
      'response',
      'answer',
      'content',
      'text',
      'message',
    ]);
    if (directReply != null) {
      return directReply;
    }

    final choices = body['choices'];
    if (choices is List && choices.isNotEmpty) {
      final choice = choices.first;
      if (choice is Map<String, dynamic>) {
        final message = choice['message'];
        if (message is Map<String, dynamic>) {
          final content = _firstNonEmptyString(message, const [
            'content',
            'text',
          ]);
          if (content != null) {
            return content;
          }
        }
      }
    }

    for (final key in const ['data', 'result']) {
      final nested = body[key];
      if (nested is Map<String, dynamic>) {
        final nestedReply = _extractReply(nested);
        if (nestedReply.trim().isNotEmpty) {
          return nestedReply;
        }
      }
    }

    throw const ServerException(message: 'Reply text missing from response');
  }

  List<dynamic> _extractHistoryItems(dynamic body) {
    if (body is List) {
      return body;
    }

    if (body is! Map<String, dynamic>) {
      throw const ServerException(
        message: 'Unexpected history response format',
      );
    }

    for (final key in const ['data', 'messages', 'history']) {
      final value = body[key];
      if (value is List) {
        return value;
      }
    }

    throw const ServerException(message: 'History items missing from response');
  }

  String? _firstNonEmptyString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
