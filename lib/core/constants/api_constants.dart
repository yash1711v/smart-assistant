/// Centralized API configuration constants.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://mock-api-boyt.onrender.com';
  static const String suggestions = '/suggestions';
  static const String chat = '/chat';
  static const String chatHistory = '/chat/history';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
