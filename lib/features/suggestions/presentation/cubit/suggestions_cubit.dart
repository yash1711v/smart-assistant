import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/core/constants/app_constants.dart';
import 'package:smartassistant/features/suggestions/domain/usecases/get_suggestions.dart';
import 'package:smartassistant/features/suggestions/presentation/cubit/suggestions_state.dart';

/// Cubit that manages the paginated suggestions list.
///
/// Supports initial loading via [loadSuggestions] and infinite-scroll
/// pagination via [loadMore].
class SuggestionsCubit extends Cubit<SuggestionsState> {
  final GetSuggestions _getSuggestions;
  int _currentPage = AppConstants.defaultStartPage;

  /// Creates a [SuggestionsCubit] with the given [getSuggestions] use case.
  SuggestionsCubit(this._getSuggestions) : super(const SuggestionsInitial());

  /// Resets pagination and loads the first page of suggestions.
  ///
  /// Emits [SuggestionsLoading] → [SuggestionsLoaded] on success,
  /// or [SuggestionsLoading] → [SuggestionsError] on failure.
  Future<void> loadSuggestions() async {
    _currentPage = AppConstants.defaultStartPage;
    emit(const SuggestionsLoading());

    try {
      final result = await _getSuggestions(
        page: _currentPage,
        limit: AppConstants.defaultPageLimit,
      );

      emit(SuggestionsLoaded(
        suggestions: result.suggestions,
        pagination: result.pagination,
      ));
    } catch (e) {
      emit(SuggestionsError(message: e.toString()));
    }
  }

  /// Loads the next page and appends results to the existing list.
  ///
  /// Does nothing if the current state is not [SuggestionsLoaded],
  /// if there is no next page, or if a load-more is already in progress.
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! SuggestionsLoaded) return;
    if (!currentState.pagination.hasNext) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));
    _currentPage++;

    try {
      final result = await _getSuggestions(
        page: _currentPage,
        limit: AppConstants.defaultPageLimit,
      );

      emit(SuggestionsLoaded(
        suggestions: [
          ...currentState.suggestions,
          ...result.suggestions,
        ],
        pagination: result.pagination,
      ));
    } catch (e) {
      _currentPage--;
      emit(SuggestionsError(message: e.toString()));
    }
  }
}
