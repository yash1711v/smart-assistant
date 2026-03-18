import 'package:smartassistant/features/suggestions/domain/entities/pagination_info.dart';
import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';

/// Contract for fetching suggestions from any data source.
///
/// Implemented by the data layer to decouple domain logic from
/// infrastructure concerns (network, caching, etc.).
abstract class SuggestionsRepository {
  /// Fetches a paginated list of suggestions.
  ///
  /// [page] is the 1-based page number to retrieve.
  /// [limit] is the maximum number of items per page.
  ///
  /// Returns a record containing the [suggestions] list and [pagination] metadata.
  Future<({List<Suggestion> suggestions, PaginationInfo pagination})>
      getSuggestions({required int page, required int limit});
}
