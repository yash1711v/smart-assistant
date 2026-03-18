import 'package:smartassistant/features/suggestions/domain/entities/pagination_info.dart';
import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';
import 'package:smartassistant/features/suggestions/domain/repositories/suggestions_repository.dart';

/// Use case that retrieves a paginated list of suggestions.
///
/// Encapsulates the single business action of fetching suggestions,
/// keeping the presentation layer free of direct repository knowledge.
class GetSuggestions {
  final SuggestionsRepository _repository;

  /// Creates a [GetSuggestions] use case backed by the given [repository].
  const GetSuggestions(this._repository);

  /// Executes the use case.
  ///
  /// [page] is the 1-based page number to fetch.
  /// [limit] is the maximum items per page.
  ///
  /// Returns a record with the fetched [suggestions] and [pagination] info.
  Future<({List<Suggestion> suggestions, PaginationInfo pagination})> call({
    required int page,
    required int limit,
  }) {
    return _repository.getSuggestions(page: page, limit: limit);
  }
}
