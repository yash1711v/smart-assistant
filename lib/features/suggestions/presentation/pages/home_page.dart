import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartassistant/core/constants/app_constants.dart';
import 'package:smartassistant/features/suggestions/presentation/cubit/suggestions_cubit.dart';
import 'package:smartassistant/features/suggestions/presentation/cubit/suggestions_state.dart';
import 'package:smartassistant/features/suggestions/presentation/widgets/suggestions_list.dart';
import 'package:smartassistant/features/theme/cubit/theme_cubit.dart';
import 'package:smartassistant/features/theme/cubit/theme_state.dart';

/// Home page that displays a paginated list of suggestions.
///
/// Integrates with [SuggestionsCubit] via [BlocBuilder] to reactively
/// render loading, loaded, and error states.
class HomePage extends StatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<SuggestionsCubit>().loadSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        centerTitle: true,
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                icon: Icon(
                  themeState.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                tooltip: themeState.isDarkMode
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SuggestionsCubit, SuggestionsState>(
        builder: (context, state) {
          return switch (state) {
            SuggestionsInitial() => const SizedBox.shrink(),
            SuggestionsLoading() => _buildLoadingState(),
            SuggestionsLoaded() => _buildLoadedState(context, state),
            SuggestionsError() => _buildErrorState(context, state),
          };
        },
      ),
    );
  }

  /// Builds a centered loading indicator for the initial fetch.
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds the suggestions list from the loaded state.
  Widget _buildLoadedState(BuildContext context, SuggestionsLoaded state) {
    if (state.suggestions.isEmpty) {
      return _buildEmptyState();
    }

    return SuggestionsList(
      suggestions: state.suggestions,
      isLoadingMore: state.isLoadingMore,
      hasMore: state.pagination.hasNext,
      onLoadMore: () => context.read<SuggestionsCubit>().loadMore(),
    );
  }

  /// Builds an empty-state message when no suggestions are available.
  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No suggestions available',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an error view with a retry button.
  Widget _buildErrorState(BuildContext context, SuggestionsError state) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<SuggestionsCubit>().loadSuggestions(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
