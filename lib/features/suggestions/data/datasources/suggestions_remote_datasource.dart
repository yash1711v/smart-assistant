import 'package:smartassistant/core/constants/api_constants.dart';
import 'package:smartassistant/core/error/exceptions.dart';
import 'package:smartassistant/core/network/dio_client.dart';
import 'package:smartassistant/features/suggestions/data/models/pagination_model.dart';
import 'package:smartassistant/features/suggestions/data/models/suggestion_model.dart';

/// Remote data source that fetches suggestions from the backend API.
///
/// All network-level concerns (URL construction, JSON parsing,
/// error translation) are encapsulated here.
class SuggestionsRemoteDataSource {
  final DioClient _dioClient;

  /// Creates a [SuggestionsRemoteDataSource] backed by the given [dioClient].
  const SuggestionsRemoteDataSource(this._dioClient);

  /// Fetches a page of suggestions from the API.
  ///
  /// [page] is the 1-based page number.
  /// [limit] is the maximum number of items per page.
  ///
  /// Returns a record of parsed [SuggestionModel] list and [PaginationModel].
  /// Throws [ServerException] if the request fails or the response is malformed.
  Future<
      ({
        List<SuggestionModel> suggestions,
        PaginationModel pagination,
      })> getSuggestions({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dioClient.get(
        ApiConstants.suggestions,
        queryParameters: {
          'current_page': page,
          'limit': limit,
        },
      );

      final data = response.data as Map<String, dynamic>;

      final suggestions = (data['data'] as List<dynamic>)
          .map((item) =>
              SuggestionModel.fromJson(item as Map<String, dynamic>))
          .toList();

      final pagination = PaginationModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      );

      return (suggestions: suggestions, pagination: pagination);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Failed to parse suggestions response');
    }
  }
}
