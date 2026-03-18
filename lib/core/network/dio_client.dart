import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

/// Singleton HTTP client wrapping [Dio] with base config and error handling.
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  /// Performs a GET request to [path] with optional [queryParameters].
  /// @throws [ServerException] on non-success responses or network errors.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  /// Performs a POST request to [path] with [data] body.
  /// @throws [ServerException] on non-success responses or network errors.
  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data?['message']?.toString() ??
            e.message ??
            'Network error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
