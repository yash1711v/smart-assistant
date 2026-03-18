import 'package:equatable/equatable.dart';
import 'package:smartassistant/features/suggestions/domain/entities/pagination_info.dart';
import 'package:smartassistant/features/suggestions/domain/entities/suggestion.dart';

/// Base class for all states emitted by [SuggestionsCubit].
sealed class SuggestionsState extends Equatable {
  /// Creates a [SuggestionsState].
  const SuggestionsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data has been requested.
class SuggestionsInitial extends SuggestionsState {
  /// Creates a [SuggestionsInitial] state.
  const SuggestionsInitial();
}

/// State emitted during the first page load.
///
/// Only used for the initial fetch — subsequent page loads use
/// [SuggestionsLoaded] with `isLoadingMore: true`.
class SuggestionsLoading extends SuggestionsState {
  /// Creates a [SuggestionsLoading] state.
  const SuggestionsLoading();
}

/// State emitted when suggestions have been successfully fetched.
class SuggestionsLoaded extends SuggestionsState {
  /// The accumulated list of suggestions across all loaded pages.
  final List<Suggestion> suggestions;

  /// Pagination metadata for the most recently fetched page.
  final PaginationInfo pagination;

  /// Whether an additional page is currently being fetched.
  final bool isLoadingMore;

  /// Creates a [SuggestionsLoaded] state.
  const SuggestionsLoaded({
    required this.suggestions,
    required this.pagination,
    this.isLoadingMore = false,
  });

  /// Returns a copy of this state with selectively overridden fields.
  SuggestionsLoaded copyWith({
    List<Suggestion>? suggestions,
    PaginationInfo? pagination,
    bool? isLoadingMore,
  }) {
    return SuggestionsLoaded(
      suggestions: suggestions ?? this.suggestions,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [suggestions, pagination, isLoadingMore];
}

/// State emitted when fetching suggestions fails.
class SuggestionsError extends SuggestionsState {
  /// Human-readable error message to display.
  final String message;

  /// Creates a [SuggestionsError] with the given [message].
  const SuggestionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
