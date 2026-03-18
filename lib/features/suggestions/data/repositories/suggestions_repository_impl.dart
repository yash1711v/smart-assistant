import 'package:smartassistant/core/error/exceptions.dart';
import 'package:smartassistant/core/error/failures.dart';
import 'package:smartassistant/features/suggestions/data/datasources/suggestions_remote_datasource.dart';
import 'package:smartassistant/features/suggestions/domain/entities/pagination_info.dart';
import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';
import 'package:smartassistant/features/suggestions/domain/repositories/suggestions_repository.dart';

/// Concrete implementation of [SuggestionsRepository].
///
/// Delegates to [SuggestionsRemoteDataSource] for network operations and
/// translates infrastructure exceptions into domain-level failures.
class SuggestionsRepositoryImpl implements SuggestionsRepository {
  final SuggestionsRemoteDataSource _remoteDataSource;

  /// Creates a [SuggestionsRepositoryImpl] with the given [remoteDataSource].
  const SuggestionsRepositoryImpl(this._remoteDataSource);

  /// Fetches paginated suggestions from the remote data source.
  ///
  /// Catches [ServerException] and wraps it as a [ServerFailure].
  @override
  Future<({List<Suggestion> suggestions, PaginationInfo pagination})>
      getSuggestions({required int page, required int limit}) async {
    try {
      final result = await _remoteDataSource.getSuggestions(
        page: page,
        limit: limit,
      );
      return (
        suggestions: result.suggestions,
        pagination: result.pagination,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
