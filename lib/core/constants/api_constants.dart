/// Centralized API configuration constants.
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://mock-api-boyt.onrender.com',
  );
  static const String suggestions = String.fromEnvironment(
    'API_SUGGESTIONS_PATH',
    defaultValue: '/suggestions',
  );
  static const String chat = String.fromEnvironment(
    'API_CHAT_PATH',
    defaultValue: '/chat',
  );
  static const String chatHistory = String.fromEnvironment(
    'API_CHAT_HISTORY_PATH',
    defaultValue: '/chat/history',
  );
  static const String authHeader = String.fromEnvironment(
    'API_AUTH_HEADER',
    defaultValue: 'Authorization',
  );
  static const String authToken = String.fromEnvironment('API_AUTH_TOKEN');

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
